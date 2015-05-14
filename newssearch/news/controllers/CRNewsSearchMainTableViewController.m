//
//  CRNewsSearchMainTableViewController.m
//  newssearch
//
//  Created by Vince Liang on 2015-05-13.
//  Copyright (c) 2015 crowley. All rights reserved.
//

#import "CRNewsSearchMainTableViewController.h"
#import "GTScrollNavigationBar.h"
#import "CRNewsAPIManager.h"
#import "CRNewsItemTableViewCell.h"
#import "CRWebViewViewController.h"
#import "CRWebContent.h"

@interface CRNewsSearchMainTableViewController ()
@property (nonatomic, assign)NSInteger rowIsReordering;
@end

@implementation CRNewsSearchMainTableViewController

#pragma mark - Initialization and Customization
- (void)viewDidLoad {
    [super viewDidLoad];
    
    /*
     the customization process within the view controller
     1. link the tableview with the scalable navigation bar
     2. add search bar to the title view of navigation item
     3. initialize cancel bar button item
     4. initialize news feed
     5. refresh control
     6. add a tap gesture handler for reordering
     7. load what we already have
     8. set the tableview editable
     */
    
    // 1.
    self.navigationController.scrollNavigationBar.scrollView = self.tableView;
    
    // 2.
    self.searchBar = [[UISearchBar alloc] init];
    self.searchBar.delegate = self;
    self.navigationItem.titleView = self.searchBar;
    
    // 3.
    self.cancelBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelBarButtonItemPressed)];
    
    // 4.
    self.newsFeed = [CRNewsFeed new];
    self.newsFeed.delegate = self;
    
    // 5.
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(refreshFeed) forControlEvents:UIControlEventValueChanged];
    
    // 6.
    // long press gesture
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHandler:)];
    [self.tableView addGestureRecognizer:tapGesture];
    
    // 7.
    NSArray *allItems = [CRNewsItem AR_all];
    for (CRNewsItem *newsItem in allItems) {
        [self.newsFeed.content addObject:newsItem];
    }
    [self.tableView reloadData];
    
    // 8.
    [self.tableView setEditing:YES animated:NO];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.scrollNavigationBar.scrollView = self.tableView;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self deselectAllCells];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI logics
- (void)cancelBarButtonItemPressed
{
    [self.searchBar resignFirstResponder];
}

- (void)deselectAllCells
{
    NSArray *visibleCells = [self.tableView visibleCells];
    for (CRNewsItemTableViewCell *otherCell in visibleCells) {
        if ([otherCell isKindOfClass:[CRNewsItemTableViewCell class]] &&
            otherCell.flatSwitch.selected) {
            [otherCell.flatSwitch setSelected:NO animated:YES];
        }
    }
}

#pragma mark - Gesture handler
- (void)tapHandler: (UITapGestureRecognizer *)gesture
{
    /*
     handler the tap gesture.
     1. if the cell is already moving, return
     2. find the cell indexpath and invoke selection method
     */
    
    // 1.
    if (self.rowIsReordering == 1) {
        return;
    }
    
    // 2.
    CGPoint point = [gesture locationInView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:point];
    [self tableView:self.tableView didSelectRowAtIndexPath:indexPath];
}

#pragma mark - Refresh Control
- (void)refreshFeed
{
    self.newsFeed.searchKeywords = self.searchBar.text;
    [self.newsFeed reload];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.newsFeed.content.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    /*
     1. check the class
     2. load news item from feed
     3. display accordingly
     */
    
    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"news_item_cell_identifier" forIndexPath:indexPath];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"news_item_cell_identifier"];
    // 1.
    if (cell && [cell isKindOfClass:[CRNewsItemTableViewCell class]]) {
        if (indexPath.row < self.newsFeed.content.count) {
            CRNewsItemTableViewCell *newsCell = (id)cell;
            // 2.
            CRNewsItem *news = [self.newsFeed.content objectAtIndex:indexPath.row];
            
            // 3.
            newsCell.newsTitleLabel.text = news.webTitle;
            newsCell.newsSectionLabel.text = news.sectionName;
            newsCell.flatSwitch.selected = NO;
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*
     when the users select a table cell, we will load the news into a new webview controller.
     1. update the flat switch status: only one flat switch is on at a time.
     2. load html from web or cache, in the meantime we popover an activityindicator
     3. initialize the web view controller and give it html content string to display.
     */
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell && [cell isKindOfClass:[CRNewsItemTableViewCell class]]) {
        CRNewsItemTableViewCell *newsCell = (id)cell;
        if (!newsCell.flatSwitch.selected) {
            // 1.
            [self deselectAllCells];
            [newsCell.flatSwitch setSelected:YES animated:YES];
            
            // 2.
            if (indexPath.row < self.newsFeed.content.count) {
                CRNewsItem *news = [self.newsFeed.content objectAtIndex:indexPath.row];
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                                      message:NSLocalizedString(@"Loading", nil)
                                                                     delegate:nil
                                                            cancelButtonTitle:nil
                                                            otherButtonTitles:nil, nil];
                [alertView show];
                
                // 3.
                [CRWebContent loadHtmlString:news.webUrl completion:^(NSString *responseHTML, NSError *error) {
                    [alertView dismissWithClickedButtonIndex:0 animated:YES];
                    CRWebViewViewController *webviewVC = [self.storyboard instantiateViewControllerWithIdentifier:@"webviewcontroller"];
                    webviewVC.urlString = news.webUrl;
                    webviewVC.htmlString = responseHTML;
                    [self.navigationController pushViewController:webviewVC animated:YES];
                }];
            }
        }
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*
     we do want to reorder the cell at anytime.
     */
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*
     no style should be displayed anytime
     */
    return UITableViewCellEditingStyleNone;
}


- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*
     we dont want the indent anytime at all.
     */
    return NO;
}

// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView willBeginReorderingRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.rowIsReordering = 1;
}

- (void)tableView:(UITableView *)tableView didEndReorderingRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.rowIsReordering = 0;
}

//
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    [self.newsFeed.content exchangeObjectAtIndex:fromIndexPath.row withObjectAtIndex:toIndexPath.row];
}

#pragma mark - Search Bar Related Methods
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    /*
     in this method we do the following things
     1. resign search bar from first responder
     2. check if we almost hit the bottom. if yes we gonna load more news
     3. if we are on top, show the navigation bar.
     4. prevent the rows being reordering
     */
    
    // 1.
    if (self.searchBar.isFirstResponder) {
        [self.searchBar resignFirstResponder];
    }
    
    // 2.
    if ([scrollView isEqual:self.tableView]) {
        if (self.tableView.contentOffset.y >= self.tableView.contentSize.height - self.tableView.bounds.size.height) {
            [self.newsFeed loadMore];
        }
    }
    
    // 3.
    if (self.tableView.contentOffset.y < 10) {
        [self.navigationController.scrollNavigationBar resetToDefaultPositionWithAnimation:YES];
    }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    /*
     we get what we have in the search bar textfield. and then send the query to api and refresh the datasource if any.
     */
    if ([self.searchBar isEqual:searchBar]) {
        self.newsFeed.searchKeywords = self.searchBar.text;
        [self.newsFeed reload];
    }
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    self.navigationItem.rightBarButtonItem = self.cancelBarButtonItem;
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    self.navigationItem.rightBarButtonItem = nil;
}

#pragma mark - Feed Delegates
- (void)feedFinishedLoadingMore
{
    [self.tableView reloadData];
}

- (void)feedFinishedReloading
{
    [self.refreshControl endRefreshing];
    [self.tableView reloadData];
}

- (void)feedEncounteredError:(NSError *)error
{
    [[[UIAlertView alloc]
      initWithTitle:NSLocalizedString(@"Error", nil)
      message:NSLocalizedString(error.localizedDescription, nil)
      delegate:nil
      cancelButtonTitle:NSLocalizedString(@"Okay", nil)
      otherButtonTitles: nil] show];
}

@end

//
//  CRNewsSearchMainTableViewController.h
//  newssearch
//
//  Created by Vince Liang on 2015-05-13.
//  Copyright (c) 2015 crowley. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CRNewsItem.h"
#import "CRNewsFeed.h"

@interface CRNewsSearchMainTableViewController : UITableViewController <UISearchBarDelegate, CRFeedDelegate>

// the feed will be the data store of the displaying content.
@property (nonatomic, strong)CRNewsFeed *newsFeed;

// user will use this search bar to search news with keywords.
@property (nonatomic, strong)UISearchBar *searchBar;

// when the search bar is active, this bar button item will show, give users another way to resign the search bar focus.
@property (nonatomic, strong)UIBarButtonItem *cancelBarButtonItem;

@end

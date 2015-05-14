//
//  CRNewsFeed.m
//  newssearch
//
//  Created by Vince Liang on 2015-05-13.
//  Copyright (c) 2015 crowley. All rights reserved.
//

#import "CRNewsFeed.h"
#import "CRNewsAPIManager.h"
#import "CRNewsItem.h"

@implementation CRNewsFeed

- (id)init
{
    self = [super init];
    if (self) {
        self.searchKeywords = @"";
    }
    return self;
}

- (void)reload
{
    /*
     reload the feed from server
     1. check if it's already reloading
     2. reload the news
     3. call super method to notify the delegate and finish the process.
     */
    
    // 1.
    if (self.isReloading) {
        return;
    }
    
    // 2.
    self.isReloading = YES;
    self.currentIndex = 0;
    [self.content removeAllObjects];
    [[CRNewsAPIManager manager] searchNews:self.searchKeywords
                                    atPage:self.currentIndex
                                completion:^(id response, NSError *error) {
                                    if (error) {
                                        [self.delegate feedEncounteredError:error];
                                    } else {
                                        NSArray *newsItemArray = [CRNewsItem AR_newOrUpdateWithJSONs:response[@"response"][@"results"]];
                                        for (CRNewsItem *item in newsItemArray) {
                                            [self.content addObject:item];
                                        }
                                    }
                                    // 3.
                                    [CRNewsItem AR_saveCompletion:^(BOOL success, NSError *error) {
                                        [super reload];
                                    }];
    }];
}

- (void)loadMore
{
    /*
     load more from server based on current index (page)
     1. check if it's already loading more
     2. reload the news
     3. call super method to notify the delegate and finish the process.
     */
    // 1.
    if (self.isLoadingMore) {
        return;
    }
    // 2.
    self.isLoadingMore = YES;
    self.currentIndex++;
    [[CRNewsAPIManager manager] searchNews:self.searchKeywords
                                    atPage:self.currentIndex
                                completion:^(id response, NSError *error) {
                                    if (error) {
                                        [self.delegate feedEncounteredError:error];
                                    } else {
                                        NSArray *newsItemArray = [CRNewsItem AR_newOrUpdateWithJSONs:response[@"response"][@"results"]];
                                        for (CRNewsItem *item in newsItemArray) {
                                            [self.content addObject:item];
                                        }
                                        if (newsItemArray.count == 0) {
                                            self.currentIndex--;
                                        }
                                    }
                                    // 3.
                                    [CRNewsItem AR_saveCompletion:^(BOOL success, NSError *error) {
                                        [super loadMore];
                                    }];
                                }];
}

@end

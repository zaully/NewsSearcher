//
//  CRBaseFeed.m
//  newssearch
//
//  Created by Vince Liang on 2015-05-13.
//  Copyright (c) 2015 crowley. All rights reserved.
//

#import "CRBaseFeed.h"

@implementation CRBaseFeed

- (id)init
{
    self = [super init];
    if (self) {
        self.content = [NSMutableArray array];
    }
    return self;
}

- (void)reload
{
    /*
     do nothing, just call the delegate
     */
    self.isReloading = NO;
    if (self.delegate) {
        [self.delegate feedFinishedReloading];
    }
}

- (void)loadMore
{
    /*
     do nothing, just call the delegate
     */
    self.isLoadingMore = NO;
    if (self.delegate) {
        [self.delegate feedFinishedLoadingMore];
    }
}

@end

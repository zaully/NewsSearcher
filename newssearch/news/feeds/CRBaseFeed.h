//
//  CRBaseFeed.h
//  newssearch
//
//  Created by Vince Liang on 2015-05-13.
//  Copyright (c) 2015 crowley. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CRFeedDelegate <NSObject>

- (void)feedFinishedReloading;
- (void)feedFinishedLoadingMore;
- (void)feedEncounteredError: (NSError *)error;

@end

@interface CRBaseFeed : NSObject

@property (nonatomic, weak)id<CRFeedDelegate> delegate;

@property (nonatomic, assign)BOOL isReloading;

@property (nonatomic, assign)BOOL isLoadingMore;

@property (nonatomic, strong)NSMutableArray *content;

- (void)reload;

- (void)loadMore;

@end

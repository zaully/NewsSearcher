//
//  CRNewsFeed.h
//  newssearch
//
//  Created by Vince Liang on 2015-05-13.
//  Copyright (c) 2015 crowley. All rights reserved.
//

#import "CRBaseFeed.h"

@interface CRNewsFeed : CRBaseFeed
@property (nonatomic, copy)NSString *searchKeywords;
@property (nonatomic, assign)NSInteger currentIndex;
@end

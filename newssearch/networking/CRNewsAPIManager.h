//
//  CRNewsAPIManager.h
//  newssearch
//
//  Created by Vince Liang on 2015-05-13.
//  Copyright (c) 2015 crowley. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CRNewsAPIManager : NSObject

#pragma mark - Shared Instance
+ (CRNewsAPIManager *)manager;

#pragma mark - NEWS
#pragma mark - Search
- (void)searchNews: (NSString *)keywords atPage: (NSInteger)page completion: (void (^)(id response, NSError *error))completion;

#pragma mark - Load HTML
- (void)loadHtml: (NSString *)urlString completion: (void (^)(id response, NSError *error))completion;
@end

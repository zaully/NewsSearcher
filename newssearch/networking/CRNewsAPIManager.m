//
//  CRNewsAPIManager.m
//  newssearch
//
//  Created by Vince Liang on 2015-05-13.
//  Copyright (c) 2015 crowley. All rights reserved.
//

#import "CRNewsAPIManager.h"
#import "AFNetworking.h"

@implementation CRNewsAPIManager

+ (CRNewsAPIManager *)manager
{
    static CRNewsAPIManager *manager = nil;
    static dispatch_once_t once;
    dispatch_once (&once, ^{
        manager = [[self alloc] init];
    });
    return manager;
}

- (NSString *)apiKey
{
    return @"vk7u4prbjpdnwt34vh9ezyru";
}

#pragma mark - NEWS
#pragma mark - Search
- (void)searchNews: (NSString *)keywords atPage: (NSInteger)page completion: (void (^)(id response, NSError *error))completion;
{
    /*
     1. establish the parameters for using. the page + 1 because in the app our index starts from 0, but in the api side, it starts at 1
     2. call the networking method and invoke callbacks accordingly.
     */
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    // 1.
    NSDictionary *searchNewsParameters = @{
                                           @"api-key" : [self apiKey],
                                           @"page" : @(page + 1),
                                           @"order-by" : @"newest",
                                           @"q" : keywords
                                           };
    
    // 2.
    [manager GET:@"http://content.guardianapis.com/search" parameters:searchNewsParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (completion) {
            completion(responseObject, nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completion) {
            completion(nil, error);
        }
    }];
}

#pragma mark - Load HTML
- (void)loadHtml: (NSString *)urlString completion: (void (^)(id response, NSError *error))completion
{
    /*
     call networking method and invoke callback
     */
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (completion) {
            completion(responseObject, nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completion) {
            completion(nil, error);
        }
    }];
}
@end

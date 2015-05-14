//
//  CRWebContent.m
//  newssearch
//
//  Created by Vince Liang on 2015-05-13.
//  Copyright (c) 2015 crowley. All rights reserved.
//

#import "CRWebContent.h"
#import "CRNewsAPIManager.h"

const struct CRWebContentAttributes CRWebContentAttributes = {
    .urlString = @"urlString",
    .htmlString = @"htmlString",
    .cacheDate = @"cacheDate"
};

@implementation CRWebContent
@synthesize urlString, htmlString, cacheDate;

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             CRWebContentAttributes.htmlString : CRWebContentAttributes.htmlString,
             CRWebContentAttributes.urlString : CRWebContentAttributes.urlString
             };
}

+ (NSString *)primaryKey
{
    return CRWebContentAttributes.urlString;
}

+ (void)loadHtmlString:(NSString *)urlString completion: (void (^)(NSString *responseHTML, NSError *error))completion;
{
    /*
     load html based on url.
     1. find existing object with the url (with the primary key)
     2. if found, check cache date. if not too old, callback. If too old, delete it and proceed
     3. if not found. use api manager to read from the url
     4. use the response data to create CRWebContent object, and save.
     5. after saving, callback.
     6. error handling
     */
    
    // 1.
    CRWebContent *content = [CRWebContent AR_firstWhereProperty:CRWebContentAttributes.urlString equalTo:urlString];
    if (content) {
        
        // 2.
        if (!content.cacheDate || [content.cacheDate timeIntervalSinceNow] < -180) {
            [content AR_delete];
        } else if (completion) {
            completion(content.htmlString, nil);
            return;
        }
    }
    // 3.
    [[CRNewsAPIManager manager] loadHtml:urlString completion:^(id response, NSError *error) {
        if ([response isKindOfClass:[NSData class]]) {
            
            // 4.
            CRWebContent *newContent = [CRWebContent AR_new];
            newContent.urlString = urlString;
            newContent.htmlString = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
            newContent.cacheDate = [NSDate date];
            [CRWebContent AR_saveCompletion:^(BOOL success, NSError *error) {
                
                // 5.
                if (completion) {
                    completion(newContent.htmlString, nil);
                }
            }];
        } else {
            
            // 6.
            completion(nil, error);
        }
    }];
}

+ (void)purgeOutdated
{
    /*
     search for web content older than 3 minutes and delete them.
     */
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"cacheDate <= %@", [[NSDate date] dateByAddingTimeInterval: -180]];
    NSArray *oldContentArray = [CRWebContent AR_allWithPredicate:predicate];
    for (CRWebContent *oldContent in oldContentArray) {
        [oldContent AR_delete];
    }
    [CRWebContent AR_saveAndWait];
}

@end

//
//  CRWebContent.h
//  newssearch
//
//  Created by Vince Liang on 2015-05-13.
//  Copyright (c) 2015 crowley. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "ARCoreData.h"

extern const struct CRWebContentAttributes {
    __unsafe_unretained NSString *urlString;
    __unsafe_unretained NSString *htmlString;
    __unsafe_unretained NSString *cacheDate;
} CRWebContentAttributes;

@interface CRWebContent : NSManagedObject <ARManageObjectMappingProtocol>

@property (nonatomic, copy) NSString *urlString;

@property (nonatomic, copy) NSString *htmlString;

@property (nonatomic, strong) NSDate *cacheDate;

+ (void)loadHtmlString:(NSString *)urlString completion: (void (^)(NSString *responseHTML, NSError *error))completion;

+ (void)purgeOutdated;

@end

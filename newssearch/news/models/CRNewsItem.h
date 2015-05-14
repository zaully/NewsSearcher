//
//  CRNewsItem.h
//  newssearch
//
//  Created by Vince Liang on 2015-05-13.
//  Copyright (c) 2015 crowley. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "ARCoreData.h"

extern const struct CRNewsItemAttributes {
    __unsafe_unretained NSString *newsId;
    __unsafe_unretained NSString *webTitle;
    __unsafe_unretained NSString *webPublicationDate;
    __unsafe_unretained NSString *sectionId;
    __unsafe_unretained NSString *sectionName;
    __unsafe_unretained NSString *webUrl;
} CRNewsItemAttributes;

@interface CRNewsItem : NSManagedObject <ARManageObjectMappingProtocol>

@property (nonatomic, copy) NSString *newsId;

@property (nonatomic, copy) NSString *webTitle;

@property (nonatomic, copy) NSString *webPublicationDate;

@property (nonatomic, copy) NSString *sectionId;

@property (nonatomic, copy) NSString *sectionName;

@property (nonatomic, copy) NSString *webUrl;

@end

//
//  CRNewsItem.m
//  newssearch
//
//  Created by Vince Liang on 2015-05-13.
//  Copyright (c) 2015 crowley. All rights reserved.
//

#import "CRNewsItem.h"

const struct CRNewsItemAttributes CRNewsItemAttributes = {
    .newsId = @"newsId",
    .webTitle = @"webTitle",
    .webPublicationDate = @"webPublicationDate",
    .sectionId = @"sectionId",
    .sectionName = @"sectionName",
    .webUrl = @"webUrl",
};

@implementation CRNewsItem
@synthesize newsId, webTitle, webPublicationDate, webUrl, sectionId, sectionName;

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             CRNewsItemAttributes.newsId : @"id",
             CRNewsItemAttributes.webPublicationDate : CRNewsItemAttributes.webPublicationDate,
             CRNewsItemAttributes.webTitle : CRNewsItemAttributes.webTitle,
             CRNewsItemAttributes.webUrl : CRNewsItemAttributes.webUrl,
             CRNewsItemAttributes.sectionId : CRNewsItemAttributes.sectionId,
             CRNewsItemAttributes.sectionName : CRNewsItemAttributes.sectionName
             };
}

+ (NSString *)primaryKey
{
    return CRNewsItemAttributes.newsId;
}
@end

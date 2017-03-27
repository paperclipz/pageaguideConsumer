//
//  PackageWrapperModel.m
//  paguide
//
//  Created by Evan Beh on 15/03/2017.
//  Copyright © 2017 Evan Beh. All rights reserved.
//

#import "PackageWrapperModel.h"

@implementation PackageWrapperModel


+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc]initWithDictionary:@{
                                                                 @"data": @"pageContent",
                                                                 @"data.data" : @"arrPackageList",
                                                                 
                                                                 }];
}
+(BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}


@end

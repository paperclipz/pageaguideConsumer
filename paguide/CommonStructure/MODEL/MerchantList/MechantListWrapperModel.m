//
//  MechantListWrapperModel.m
//  paguide
//
//  Created by Evan Beh on 02/05/2017.
//  Copyright © 2017 Evan Beh. All rights reserved.
//

#import "MechantListWrapperModel.h"

@implementation MechantListWrapperModel


+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc]initWithDictionary:@{
                                                      @"data": @"pageContent",
                                                      @"data.data" : @"arrMerchantList",
                                                      }];
}

+(BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}
@end

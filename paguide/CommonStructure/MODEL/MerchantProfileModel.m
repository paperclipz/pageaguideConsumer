//
//  MerchantProfileModel.m
//  paguide
//
//  Created by Evan Beh on 15/03/2017.
//  Copyright © 2017 Evan Beh. All rights reserved.
//

#import "MerchantProfileModel.h"

@implementation MerchantProfileModel
+(BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}


+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc]initWithDictionary:@{
                                                      @"description": @"desc",
                                                      }];
}


@end

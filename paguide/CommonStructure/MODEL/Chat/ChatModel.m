//
//  ChatModel.m
//  paguide
//
//  Created by Evan Beh on 29/09/2017.
//  Copyright © 2017 Evan Beh. All rights reserved.
//

#import "ChatModel.h"

@implementation ChatModel

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc]initWithDictionary:@{
                                                      @"id": @"cID",
                                                      }];
}

+(BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}
@end

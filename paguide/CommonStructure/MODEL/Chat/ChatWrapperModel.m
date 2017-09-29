//
//  ChatWrapperModel.m
//  paguide
//
//  Created by Evan Beh on 29/09/2017.
//  Copyright © 2017 Evan Beh. All rights reserved.
//

#import "ChatWrapperModel.h"

@implementation ChatWrapperModel

+(BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc]initWithDictionary:@{
                                                      @"data" : @"arrChatList"
                                                      }];
}
@end

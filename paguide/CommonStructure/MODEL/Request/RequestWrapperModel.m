//
//  RequestWrapperModel.m
//  paguide
//
//  Created by Evan Beh on 23/03/2017.
//  Copyright © 2017 Evan Beh. All rights reserved.
//

#import "RequestWrapperModel.h"

@implementation RequestWrapperModel

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc]initWithDictionary:@{
                                                      @"data": @"pageContent",
                                                      @"data.data" : @"arrAppointmentList",
                                                      }];
}

+(BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}
@end

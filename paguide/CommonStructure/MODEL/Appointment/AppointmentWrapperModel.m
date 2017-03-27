//
//  AppointmentWrapperModel.m
//  paguide
//
//  Created by Evan Beh on 20/03/2017.
//  Copyright © 2017 Evan Beh. All rights reserved.
//

#import "AppointmentWrapperModel.h"

@implementation AppointmentWrapperModel


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

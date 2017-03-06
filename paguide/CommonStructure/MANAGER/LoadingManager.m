//
//  LoadingManager.m
//  Beep
//
//  Created by Page Advisor on 07/09/2016.
//  Copyright © 2016 Paperclipz. All rights reserved.
//

#import "LoadingManager.h"
#import <KVNProgress/KVNProgress.h>

@implementation LoadingManager


+(void)hide
{
    [KVNProgress dismiss];
}

+(void)show
{
//    KVNProgressConfiguration *configuration = [[KVNProgressConfiguration alloc] init];
//    
//    configuration.statusColor = [UIColor whiteColor];
//    configuration.statusFont = [UIFont fontWithName:@"HelveticaNeue-Thin" size:15.0f];
//    configuration.fullScreen = YES;
//    configuration.stopRelativeHeight = 0.4f;
//    [KVNProgress setConfiguration:configuration];

    [KVNProgress showWithStatus:@"Loading"];
    
    
}

@end

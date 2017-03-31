//
//  PushNotificationManager.m
//  paguide
//
//  Created by Evan Beh on 30/03/2017.
//  Copyright © 2017 Evan Beh. All rights reserved.
//

#import "PushNotificationManager.h"



#if defined(__IPHONE_10_0) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
@import UserNotifications;
#endif


// Copied from Apple's header in case it is missing in some cases (e.g. pre-Xcode 8 builds).
#ifndef NSFoundationVersionNumber_iOS_9_x_Max
#define NSFoundationVersionNumber_iOS_9_x_Max 1299
#endif

@implementation PushNotificationManager

+ (id)Instance {
    
    static PushNotificationManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc]init];
        
    });
    return instance;
}

-(id)init
{
    self = [super init];
    
    
    return self;
}

-(void)configureNotificaiton:(UIApplication*)application
{
    //    UIUserNotificationType userNotificationTypes = (UIUserNotificationTypeAlert |
    //                                                    UIUserNotificationTypeBadge |
    //                                                    UIUserNotificationTypeSound);
    //    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:userNotificationTypes
    //                                                                             categories:nil];
    //    [application registerUserNotificationSettings:settings];
    //    [application registerForRemoteNotifications];
    //
    //
    //
    //    //firebase
    //    // [START configure_firebase]
    //    [FIRApp configure];
    //    // [END configure_firebase]
    //    [self connectToFcm];
    //
    //    // Add observer for InstanceID token refresh callback.
    //    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tokenRefreshNotification)
    //                                                 name:kFIRInstanceIDTokenRefreshNotification object:nil];
    //
    //
    // iOS 8 or later
    // [START register_for_notifications]
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_9_x_Max) {
        UIUserNotificationType allNotificationTypes =
        (UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge);
        UIUserNotificationSettings *settings =
        [UIUserNotificationSettings settingsForTypes:allNotificationTypes categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    } else {
        // iOS 10 or later
#if defined(__IPHONE_10_0) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
        UNAuthorizationOptions authOptions =
        UNAuthorizationOptionAlert
        | UNAuthorizationOptionSound
        | UNAuthorizationOptionBadge;
        [[UNUserNotificationCenter currentNotificationCenter]
         requestAuthorizationWithOptions:authOptions
         completionHandler:^(BOOL granted, NSError * _Nullable error) {
         }
         ];
        
        // For iOS 10 display notification (sent via APNS)
        [[UNUserNotificationCenter currentNotificationCenter] setDelegate:self];
        // For iOS 10 data message (sent via FCM)
        [[FIRMessaging messaging] setRemoteMessageDelegate:self];
#endif
    }
    
    [[UIApplication sharedApplication] registerForRemoteNotifications];
    // [END register_for_notifications]
    
    
    // [START configure_firebase]
    [FIRApp configure];
    // [END configure_firebase]
    // Add observer for InstanceID token refresh callback.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tokenRefreshNotification:)
                                                 name:kFIRInstanceIDTokenRefreshNotification object:nil];
    
}
@end

//
//  AppDelegate.m
//  paguide
//
//  Created by Evan Beh on 24/02/2017.
//  Copyright © 2017 Evan Beh. All rights reserved.
//

#import "AppDelegate.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <Bolts/Bolts.h>
#import <FBSdkCoreKit/FBSDKAppEvents.h>
#import <FBSDKCoreKit/FBSDKApplicationDelegate.h>

#import "Stripe.h"

@import Intercom;


#if defined(__IPHONE_10_0) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
@import UserNotifications;
#endif

#if defined(__IPHONE_10_0) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
@interface AppDelegate () <UNUserNotificationCenterDelegate, FIRMessagingDelegate>
@end
#endif

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [[UITabBar appearance] setTintColor:APP_MAIN_COLOR];

    [[UINavigationBar appearance] setTintColor:APP_MAIN_COLOR];

    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:APP_MAIN_COLOR}];

    [self customApplication:application didFinishLaunchingWithOptions:launchOptions];
    
    
    [[FBSDKApplicationDelegate sharedInstance] application:application
                             didFinishLaunchingWithOptions:launchOptions];

    [self.window setTintColor:APP_MAIN_COLOR];

    
    [self configureNotificaiton:application];
    
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(-200, 0)
                                                         forBarMetrics:UIBarMetricsDefault];
  //  do app update checking
    
    return YES;
}

//custom implementation for application launch

- (void)customApplication:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
 
    [[STPPaymentConfiguration sharedConfiguration] setPublishableKey:STRIPE_KEY];
    
    [Intercom setApiKey:intercom_key forAppId:intercom_appID];

    
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    
    [[FIRMessaging messaging] disconnect];
    
    NSLog(@"Disconnected from FCM");
    

    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    
    
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;

    NSLog(@"Connected to FCM Become Active");
    
    [self connectToFcm];

    
    [FBSDKAppEvents activateApp];

    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
    //    [NANTracking trackAppLaunch:url];
    
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                          openURL:url
                                                sourceApplication:sourceApplication
                                                       annotation:annotation
            ];
}


#pragma mark - Push Notification
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
    
    
    // ================================ [START configure_firebase] ================================
    
#ifdef is_itunes
    
#define google_service_info [[NSBundle mainBundle]pathForResource:@"GoogleService-Info-itunes" ofType:@"plist"]

    NSLog(@"is Itunes Built");
#else
    
#define google_service_info [[NSBundle mainBundle]pathForResource:@"GoogleService-Info" ofType:@"plist"]
    
    NSLog(@"is Enterprise Built");

#endif
    
    FIROptions* options = [[FIROptions alloc]initWithContentsOfFile:google_service_info];
    
    [FIRApp configureWithOptions:options];
    
    // ================================  [END configure_firebase] ================================
    
    
    // Add observer for InstanceID token refresh callback.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tokenRefreshNotification:)
                                                 name:kFIRInstanceIDTokenRefreshNotification object:nil];
    
}

- (void)connectToFcm {
    //if no add this it will cause fail login at 1st time get token
    if(![[FIRInstanceID instanceID] token])
        return;
    [[FIRMessaging messaging] connectWithCompletion:^(NSError * _Nullable error) {
        if (error != nil) {
        } else {
           // NSString *refreshedToken = [[FIRInstanceID instanceID] token];
            
           
        }
    }];
}

- (void)tokenRefreshNotification:(NSNotification *)notification {
    // Note that this callback will be fired everytime a new token is generated, including the first
    // time. So if you need to retrieve the token as soon as it is available this is where that
    // should be done.
    NSString *refreshedToken = [[FIRInstanceID instanceID] token];
    NSLog(@"InstanceID token: %@", refreshedToken);
    
    // Connect to FCM since connection may have failed when attempted before having a token.
    [self connectToFcm];
    
    // TODO: If necessary send token to application server.
    
    if (![Utils isStringNull:[Utils getToken]]) {
        
        [DataManager requestServerForRegisterDevice];
    }
}

// Receive displayed notifications for iOS 10 devices.
#if defined(__IPHONE_10_0) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
- (void)userNotificationCenter:(UNUserNotificationCenter *)center
       willPresentNotification:(UNNotification *)notification
         withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler {
    // Print message ID.
    NSDictionary *userInfo = notification.request.content.userInfo;
    NSLog(@"Message ID: %@", userInfo[@"gcm.message_id"]);
    
    // Print full message.
    NSLog(@"ios 10 notification %@", userInfo);
    
}

// Receive data message on iOS 10 devices.
- (void)applicationReceivedRemoteMessage:(FIRMessagingRemoteMessage *)remoteMessage {
    // Print full message
    NSLog(@"applicationReceivedRemoteMessage : %@", [remoteMessage appData]);
}
#endif


#pragma mark - Receive notification in background

- (void)application:(UIApplication*)application didReceiveRemoteNotification:(NSDictionary*)userInfo
{
    
    NSLog(@"notification object : %@",userInfo);
    
    [UIApplication sharedApplication].applicationIconBadgeNumber +=1;
    
}

#pragma mark - Receive Notification on fore ground
// To receive notifications for iOS 9 and below.
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    // If you are receiving a notification message while your app is in the background,
    // this callback will not be fired till the user taps on the notification launching the application.
    // TODO: Handle data of notification
    
    // Print message ID.
    NSLog(@"Message ID: %@", userInfo[@"gcm.message_id"]);
    
    // Print full message.
    NSLog(@"%@", userInfo);
    

}

-(void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    NSLog(@"register notification :%@",notificationSettings);
}

#pragma mark - Notification Delegate
// Delegation methods
- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    const unsigned *tokenBytes = [deviceToken bytes];
    NSString       *hexToken   = [NSString stringWithFormat:@"%08x%08x%08x%08x%08x%08x%08x%08x",
                                  ntohl(tokenBytes[0]), ntohl(tokenBytes[1]), ntohl(tokenBytes[2]),
                                  ntohl(tokenBytes[3]), ntohl(tokenBytes[4]), ntohl(tokenBytes[5]),
                                  ntohl(tokenBytes[6]), ntohl(tokenBytes[7])];
    
    NSLog(@"device Token From Default : %@",hexToken);
    
    [Intercom setDeviceToken:deviceToken];

    [[FIRInstanceID instanceID] setAPNSToken:deviceToken type:FIRInstanceIDAPNSTokenTypeUnknown];
    
    }

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
    NSLog(@"didFailToRegisterForRemoteNotificationsWithError : %@",error.description);
}

@end

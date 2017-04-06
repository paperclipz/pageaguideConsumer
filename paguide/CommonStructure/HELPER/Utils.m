
//
//  Utils.m
//  Beep
//
//  Created by Page Advisor on 07/09/2016.
//  Copyright © 2016 Paperclipz. All rights reserved.
//

#import "Utils.h"
#import "AppDelegate.h"
#import "AppModel.h"
#import <SAMKeychain.h>

#define BORDER_WIDTH 1.0f
#define KEY_APP_TOKEN @"app_token"
#define KEY_APP_USER_EMAIL @"user_email"

@implementation Utils

+(BOOL)isStringNull:(NSString*)str
{
    BOOL _isNUll = false;
    
    if ((id)str == [NSNull null] || ![str isKindOfClass:[NSString class]]) {
        return YES;
    }
    
    if ([str isEqualToString:@""] || str.length == 0 || str == nil || str == (id)[NSNull null] || [str isKindOfClass:[NSNull class]] || [str isEqual:[NSNull null]]) {
        _isNUll = true;
    }
    
    return _isNUll;
}

+(BOOL)isArrayNull:(NSArray*)array
{
    BOOL _isNUll = NO;
    
    if ([array isKindOfClass:[NSArray class]] || [array isKindOfClass:[NSMutableArray class]]) {
        
        if (array == nil || [array count] == 0) {
            _isNUll = YES;
        }
        
    }
    else{
        
        _isNUll = YES;
    }
    
    return _isNUll;
}

#pragma mark - UI Utils

+(void)setRoundBorder:(UIView*)view color:(UIColor*)color borderRadius:(float)borderRadius
{
    
    [[view layer] setBorderWidth:BORDER_WIDTH];
    [[view layer] setBorderColor:color.CGColor];
    [[view layer] setCornerRadius:borderRadius];
    [[view layer] setMasksToBounds:YES];
    
}

#pragma mark - App Utils

+(NSString*)getUniqueDeviceIdentifier
{

    
    NSString *appName = @"PAGEAGUIDE";
    
    NSString *strApplicationUUID = [SAMKeychain passwordForService:appName account:@"PAGEAGUIDE_ACCOUNT"];
    
    if (strApplicationUUID == nil)
    {
        strApplicationUUID  = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
        
        [SAMKeychain setPassword:strApplicationUUID forService:appName account:@"PAGEAGUIDE_ACCOUNT"];
    }
    
    return strApplicationUUID;
    
    
}

+(void)setUserEmail:(NSString*)email
{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults removeObjectForKey:KEY_APP_USER_EMAIL];
    
    if (![Utils isStringNull:email]) {
        
        [defaults setObject:email forKey:KEY_APP_USER_EMAIL];
        
        [defaults synchronize];
        
    }
    
}

+(NSString*)getUserEmail
{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSString * email = [defaults objectForKey:KEY_APP_USER_EMAIL];
    
    
    if (![Utils isStringNull:email]) {
        
        return email;
    }
    else{
        
        NSLog(@"NO user email Detected");
        
        return @"";
        
    }
    
}

+(void)setAppToken:(NSString*)token
{
    
 //   [GVUserDefaults standardUserDefaults].token = token;

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults removeObjectForKey:KEY_APP_TOKEN];
    
    if (![Utils isStringNull:token]) {
        
        [defaults setObject:token forKey:KEY_APP_TOKEN];
       
        [defaults synchronize];
        
    }
    
}

+(NSString*)getToken
{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSString * token = [defaults objectForKey:KEY_APP_TOKEN];
    
    if (![Utils isStringNull:token]) {
        
        return token;
    }
    else{
        
        NSLog(@"NO Token Detected");
        
        return @"";
        
    }
    
}


+(BOOL)isUserLogin
{
    if ([Utils isStringNull:[Utils getToken]]) {
        
        return NO;
    }
    else{
        return YES;

    }
}

+(NSString*)getAppVersion
{
    
    NSString* oriVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    
    NSString* version = oriVersion;
    
    return version;
}


+(void)logout
{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults removeObjectForKey:KEY_APP_TOKEN];
    
    [defaults removeObjectForKey:KEY_APP_USER_EMAIL];
    
    [defaults synchronize];

}

+(void)showRegisterPage
{
    
    
    UIViewController *rootController =(UIViewController*)[[(AppDelegate*)
                                                           [[UIApplication sharedApplication]delegate] window] rootViewController];
    
    
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Register" bundle:nil];
    UINavigationController *navC = [storyboard instantiateViewControllerWithIdentifier:@"Register_Main_Navigation"];
    
    
//    [navC.navigationBar setBackgroundImage:[UIImage new]
//                                                  forBarMetrics:UIBarMetricsDefault];
//    navC.navigationBar.shadowImage = [UIImage new];
//    navC.navigationBar.translucent = YES;
//    navC.view.backgroundColor = [UIColor clearColor];
//    navC.navigationBar.backgroundColor = [UIColor clearColor];
//
//    
    [rootController presentViewController:navC animated:YES completion:nil];
    
    //        if (!index.showTabBar) {
    
}

+(void)checkIsNeedUpateApp:(StringBlock)updateAppBlock NoNeedUpdate:(VoidBlock)noNeedUpdateBlock
{
  
        NSDictionary* dict = @{@"mobile_type" : @"ios"};
    
        [ConnectionManager requestServerWith:AFNETWORK_POST serverRequestType:ServerRequestTypePostHomeVersion parameter:dict appendString:nil success:^(id object) {
    
    
            NSError* error;
    
            AppModel* model = [[AppModel alloc]initWithDictionary:object[@"data"] error:&error];
    
    
            NSString* serverVersion = model.ios_consumer_version;
    
            NSString* appVersion = [Utils getAppVersion];
    
            if ([serverVersion compare:appVersion options:NSNumericSearch] == NSOrderedDescending) {
            
                if(updateAppBlock)
                {
                    updateAppBlock(model.ios_consumer_url);
                }
                
            } else {
               
                NSLog(@"Latest Version");
                if (noNeedUpdateBlock) {
                    noNeedUpdateBlock();
                }
            }
    
        } failure:^(id object) {
            
        }];
}


+(void)reloadAllAppointView
{
    UIViewController *rootController =(UIViewController*)[[(AppDelegate*)
                                                           [[UIApplication sharedApplication]delegate] window] rootViewController];
    
    
    

    if ([rootController isKindOfClass:[UITabBarController class]]) {
        
        UITabBarController* tabBarcontroller = (UITabBarController*)rootController;
        
        NSArray* array = tabBarcontroller.viewControllers;
        
        for (int i = 0; i<array.count; i++) {
            
        
            UIViewController* controller = array[i];
            
            if ([controller isKindOfClass:[UINavigationController class]]) {
                
                UINavigationController* navigationController = (UINavigationController*)controller;
                
                
                if (![Utils isArrayNull:navigationController.viewControllers]) {
                    UIViewController* innerViewController = navigationController.viewControllers[0];

                    
                    if ([innerViewController isKindOfClass:[BaseViewController class]]) {
                        BaseViewController* baseController = (BaseViewController*)innerViewController;
                        baseController.isNeedReload = YES;

                    }
                }
               
                
            }
        }
    }
    
    
}
+(void)setSelectedTabbarIndex:(int)index
{
    UIViewController *rootController =(UIViewController*)[[(AppDelegate*)
                                                           [[UIApplication sharedApplication]delegate] window] rootViewController];
    
    
    
    
    if ([rootController isKindOfClass:[UITabBarController class]]) {
     
        UITabBarController* tabBarcontroller = (UITabBarController*)rootController;
        
        tabBarcontroller.selectedIndex = index;

    }
}

#pragma mark - User Utils




@end

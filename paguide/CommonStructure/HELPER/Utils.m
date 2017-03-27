//
//  Utils.m
//  Beep
//
//  Created by Page Advisor on 07/09/2016.
//  Copyright © 2016 Paperclipz. All rights reserved.
//

#import "Utils.h"
#import "AppDelegate.h"

#define BORDER_WIDTH 1.0f
#define KEY_APP_TOKEN @"app_token"
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
    
   // return @"j77u4ZtdKb6xs7gTOqc4m6mXSLftiUhBgCo9VF5ABcQ";
    
    //NSString* token  = [GVUserDefaults standardUserDefaults].token;

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSString * token = [defaults objectForKey:KEY_APP_TOKEN];
    
   // NSString* token = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];

    
    
    if (![Utils isStringNull:token]) {
    
        return token;
    }
    else{
        return @"";

    }
    

}

+(NSString*)getAppVersion
{
    
    NSString* oriVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    
    NSString* version = oriVersion;
    
    return version;
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
#pragma mark - User Utils



@end

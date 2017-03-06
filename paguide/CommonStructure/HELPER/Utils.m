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
    UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"Register_Main_Navigation"];
    
    [rootController presentViewController:vc animated:YES completion:nil];
    //        if (!index.showTabBar) {
    
}
#pragma mark - User Utils



@end

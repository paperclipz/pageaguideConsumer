//
//  Utils.h
//  Beep
//
//  Created by Page Advisor on 07/09/2016.
//  Copyright © 2016 Paperclipz. All rights reserved.
//

#import <Foundation/Foundation.h>




#define IsNullConverstion(obj)  obj == nil ? @"" : obj   


@interface Utils : NSObject

//
+(BOOL)isStringNull:(NSString*)str;
//
+(BOOL)isArrayNull:(NSArray*)array;

+(void)logout;

#pragma mark - UI Utils

+(CGRect)getWindowFrame;

+(void)setRoundBorder:(UIView*)view color:(UIColor*)color borderRadius:(float)borderRadius;

#pragma mark - App Utils

+(BOOL)isDevBuilt;

+(NSString*)getAppVersion;

+(void)reloadAllFrontView;

+(NSString*)getUniqueDeviceIdentifier;

+(NSString*)getToken;

+(void)setAppToken:(NSString*)token;

+(NSString*)getUserEmail;

+(void)setUserEmail:(NSString*)email;


+(void)showRegisterPage;

//+(void)linkRegisterPin:(NSString*)pin;
//
//+(NSString*)getAppVersion;

+(void)checkIsNeedUpateApp:(StringBlock)updateAppBlock NoNeedUpdate:(VoidBlock)noNeedUpdateBlock;

+(BOOL)isUserLogin;

#pragma mark - User Utils
//+(void)signOut;
//
//+(BOOL)isUserLogin;
//
//+(void)showLogin;
//
//+(NSString*)getUniqueDeviceIdentifier;
//
//
//+(NSString*)convertToJsonString:(NSDictionary*)dict;


#pragma mark - Converstion Utils


#pragma mark - UI
+(void)setSelectedTabbarIndex:(int)index;


#pragma mark - App List Options


#pragma mark - App Specific

#pragma mark - Alert Utils

+(UIAlertController*)alertViewWithText:(NSString*)string AndButtonText:(NSString*)btnText;

@end

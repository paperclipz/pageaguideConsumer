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


#pragma mark - UI Utils

+(void)setRoundBorder:(UIView*)view color:(UIColor*)color borderRadius:(float)borderRadius;

#pragma mark - App Utils

+(void)showRegisterPage;

//+(void)linkRegisterPin:(NSString*)pin;
//
//+(NSString*)getAppVersion;

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


#pragma mark - App List Options


#pragma mark - App Specific
@end

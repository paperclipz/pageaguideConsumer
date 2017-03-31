//
//  FBLoginManager.h
//  Seeties
//
//  Created by Lai on 23/05/2016.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import "FacebookModel.h"

typedef void (^FBGraphRequestHandler)(FacebookModel *modal);
typedef void (^FBLoginHandler)(FBSDKLoginManagerLoginResult *result);

@interface FBLoginManager : NSObject

+ (void)performFacebookGraphRequest:(FBGraphRequestHandler)completionBlock;
+ (void)performFacebookLogin:(UIViewController *)viewController completionBlock:(FBLoginHandler)completionBlock;
+(void)performFacebookGraphRequestWithLoginRequest:(FBGraphRequestHandler)completionBlock InViewController:(UIViewController*)vc;

+(void)logout;

@end

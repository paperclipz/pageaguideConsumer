//
//  FBLoginManager.m
//  Seeties
//
//  Created by Lai on 23/05/2016.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import "FBLoginManager.h"
#import "FacebookModel.h"
#import "MessageManager.h"

@interface FBLoginManager()

@end

@implementation FBLoginManager


+(void)performFacebookGraphRequestWithLoginRequest:(FBGraphRequestHandler)completionBlock InViewController:(UIViewController*)vc
{
    if ([FBSDKAccessToken currentAccessToken]) {
        
        [FBLoginManager performFacebookGraphRequest:completionBlock];
         
        }
    else{
    
        [FBLoginManager performFacebookLogin:vc completionBlock:^(FBSDKLoginManagerLoginResult *result) {
            
            
            if (result.isCancelled) {
                
                NSLog(@"user cancel request from facebook");
                return;
            }
            else{
                [FBLoginManager performFacebookGraphRequest:completionBlock];

            }

        }];
    }
    
}

+ (void)performFacebookGraphRequest:(FBGraphRequestHandler)completionBlock {
    
    [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{@"fields": @"id, name, picture, email, gender, birthday, first_name, last_name"}]
     startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
         
         if (!error)
         {
             NSLog(@"resultis:%@",result);
             
             NSDictionary *facebookData = result;
             FacebookModel* model = [FacebookModel new];
             
             model.uID = facebookData[@"id"];
             model.name = facebookData[@"name"];
             model.userProfileImageURL = facebookData[@"picture"][@"data"][@"url"];
             model.email = facebookData[@"email"];
             model.gender = facebookData[@"gender"];
             model.dob = facebookData[@"birthday"];
             model.userName = facebookData[@"last_name"];
             model.userFullName = [NSString stringWithFormat:@"%@%@", facebookData[@"first_name"], facebookData[@"last_name"]];
             
             model.fbToken = [[FBSDKAccessToken currentAccessToken] tokenString];
             
//             [ConnectionManager dataManager].facebookLoginModel = model;
             
             if (completionBlock) {
                 completionBlock(model);
             }
         }
         else {
             
             NSLog(@"Process error : %@",error.userInfo.description);
             
//             [MessageManager showMessage:LocalisedString(@"system") SubTitle:@"Facebook Login Failed!" Type:TSMessageNotificationTypeError];
         }
     }];
}

+(void)logout
{
    FBSDKLoginManager *loginManager = [[FBSDKLoginManager alloc] init];
    
    [loginManager logOut];
}

+ (void)performFacebookLogin:(UIViewController *)viewController completionBlock:(FBLoginHandler)completionBlock {
    
    FBSDKLoginManager *loginManager = [[FBSDKLoginManager alloc] init];
    
    [loginManager logOut];
    
    loginManager.loginBehavior = FBSDKLoginBehaviorNative;
    
        [loginManager logInWithReadPermissions:@[@"public_profile", @"email"] fromViewController:viewController handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
            
            if (error) {
                NSLog(@"Process error : %@",error.userInfo.debugDescription);

                [MessageManager showMessage:@"Facebook Login Failed!" Type:TSMessageNotificationTypeError];
            
            } else {
                
                NSLog(@"Result : %@",result.debugDescription);

                if (completionBlock) {
                    completionBlock(result);
                }
            }
        }];

}

@end

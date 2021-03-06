//
//  MessageManager.m
//  SeetiesIOS
//
//  Created by Evan Beh on 1/27/16.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import "MessageManager.h"
#import "AppDelegate.h"
#import "UIViewController+Extension.h"
#import "AppDelegate.h"

@implementation MessageManager

+(void)showMessage:(NSString *)message Type:(TSMessageNotificationType)type
{
    UIViewController* rootController = [[[[UIApplication sharedApplication]delegate]window]rootViewController];
    
        [TSMessage showNotificationInViewController:[rootController topVisibleViewController] title:message subtitle:@"" type:type];

}

+(void)showMessage:(NSString *)message Type:(TSMessageNotificationType)type inViewController:(UIViewController*)vc
{
    
    [TSMessage showNotificationInViewController:vc title:message subtitle:@"" type:type];
    
}


@end

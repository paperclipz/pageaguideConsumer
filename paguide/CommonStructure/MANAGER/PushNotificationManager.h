//
//  PushNotificationManager.h
//  paguide
//
//  Created by Evan Beh on 30/03/2017.
//  Copyright © 2017 Evan Beh. All rights reserved.
//

#import <Foundation/Foundation.h>
@import Firebase;

@interface PushNotificationManager : NSObject
+ (id)Instance;

-(void)configureNotificaiton:(UIApplication*)application;
@end

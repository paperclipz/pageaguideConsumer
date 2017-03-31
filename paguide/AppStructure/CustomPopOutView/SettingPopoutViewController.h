//
//  SettingPopoutViewController.h
//  paguide
//
//  Created by Evan Beh on 30/03/2017.
//  Copyright © 2017 Evan Beh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingPopoutViewController : UIViewController


-(void)setupNotificationViewSMS:(BOOL)isSmsOn PushNotification:(BOOL)isPNOn;

@property (weak, nonatomic) IBOutlet UISwitch *ibSwitchTwo;

@property (weak, nonatomic) IBOutlet UISwitch *ibSwitchOne;

@property (nonatomic,copy)VoidBlock didCancelClickedBlock;

@property (nonatomic,copy)VoidBlock didSubmitClickedBlock;


@end

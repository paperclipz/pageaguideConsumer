//
//  GuestModeViewController.h
//  paguide
//
//  Created by Evan Beh on 02/11/2017.
//  Copyright © 2017 Evan Beh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GuestModeViewController : UIViewController

+(instancetype)instantiate;


-(void)userDidSelecGuestMode:(IDBlock)guestCompletion userDidLogin:(IDBlock)loginCompletion;
@end

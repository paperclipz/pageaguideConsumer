//
//  ResendVerificationCodeViewController.h
//  paguide
//
//  Created by Evan Beh on 29/03/2017.
//  Copyright © 2017 Evan Beh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ResendVerificationCodeViewController : UIViewController

@property(nonatomic,copy)VoidBlock didSelectResendBlock;
@property (weak, nonatomic) IBOutlet UITextField *txtEmail;

@end

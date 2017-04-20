//
//  ResendVerificationCodeViewController.h
//  paguide
//
//  Created by Evan Beh on 29/03/2017.
//  Copyright © 2017 Evan Beh. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^DoubleStringBlock) (NSString* prefix, NSString* number);

@interface ResendVerificationCodeViewController : UIViewController
@property(nonatomic,assign)BOOL isWithoutPhoneNumber;
@property(nonatomic,copy)VoidBlock didSelectResendBlock;
@property (weak, nonatomic) IBOutlet UITextField *txtEmail;
@property(nonatomic,copy)DoubleStringBlock didSelectResendWithNumberBlock;

@end

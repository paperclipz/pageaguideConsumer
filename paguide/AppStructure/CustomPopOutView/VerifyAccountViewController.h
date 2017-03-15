//
//  VerifyAccountViewController.h
//  paguide
//
//  Created by Evan Beh on 14/03/2017.
//  Copyright © 2017 Evan Beh. All rights reserved.
//

#import "CustomPopOutViewController.h"

@interface VerifyAccountViewController : CustomPopOutViewController



-(void)setupOTPView:(NSString*)mobileNumber Email:(NSString*)email didFinishVerify:(StringBlock)completion;

@end

//
//  VerifyAccountViewController.m
//  paguide
//
//  Created by Evan Beh on 14/03/2017.
//  Copyright © 2017 Evan Beh. All rights reserved.
//

#import "VerifyAccountViewController.h"

@interface VerifyAccountViewController ()
{
    NSString* emailAddress;
    NSString* mobile_number;
}
@property (weak, nonatomic) IBOutlet UITextField *txtVerifyCode;
@property (weak, nonatomic) IBOutlet UIButton *btnResend;
@property (weak, nonatomic) IBOutlet UIButton *btnActivate;
@property(nonatomic,copy)StringBlock didCompleteBlock;
@end

@implementation VerifyAccountViewController
- (IBAction)btnResendClicked:(id)sender {
    
    [self requestServerResendOtp];
}
- (IBAction)btnActivateClicked:(id)sender {
    
    
    if ([Utils isStringNull:self.txtVerifyCode.text]) {
        
        [MessageManager showMessage:@"Please input otp" Type:TSMessageNotificationTypeError inViewController:self];
    }
    else{

        
        
        if (self.didCompleteBlock) {
            self.didCompleteBlock(self.txtVerifyCode.text);
        }
    }
  
    
}


-(void)setupOTPView:(NSString*)mobileNumber Email:(NSString*)email didFinishVerify:(StringBlock)completion
{
    emailAddress = email;
    mobile_number = mobileNumber;
    
    self.didCompleteBlock = completion;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.txtVerifyCode.text = @"123456";
    [self.btnActivate setDefaultBorder];
    
    [self.btnResend setInvertedBorder];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)requestServerResendOtp
{
    
    NSDictionary* dict = @{@"mobile_number" :IsNullConverstion(mobile_number),
                           
                           @"email" : IsNullConverstion(emailAddress)
                           
                           };
    
    
    
    [ConnectionManager requestServerWith:AFNETWORK_POST serverRequestType:ServerRequestTypePostUserResendOTP parameter:dict appendString:nil success:^(id object) {
        
        NSError* error;

        BaseModel* model = [[BaseModel alloc]initWithDictionary:object error:&error];
        
        [MessageManager showMessage:model.displayMessage Type:TSMessageNotificationTypeSuccess inViewController:self];
        

        
    } failure:^(id object) {
        
        NSError* error;

        BaseModel* model = [[BaseModel alloc]initWithDictionary:object error:&error];
        
        [MessageManager showMessage:model.displayMessage Type:TSMessageNotificationTypeError inViewController:self];
        

    }];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

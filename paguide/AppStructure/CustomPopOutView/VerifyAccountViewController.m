//
//  VerifyAccountViewController.m
//  paguide
//
//  Created by Evan Beh on 14/03/2017.
//  Copyright © 2017 Evan Beh. All rights reserved.
//

#import "VerifyAccountViewController.h"
#import <STPopup/STPopup.h>


@interface VerifyAccountViewController ()
{
    BOOL isNeedAskForContact;
    
}
@property (strong, nonatomic)  NSString* emailAddress;


@property (weak, nonatomic) IBOutlet UITextField *txtVerifyCode;
@property (weak, nonatomic) IBOutlet UIButton *btnResend;
@property (weak, nonatomic) IBOutlet UIButton *btnActivate;
@property(nonatomic,copy)StringBlock didCompleteBlock;

@property (nonatomic,strong)ResendVerificationCodeViewController* resendVerificationCodeViewController;
@end

@implementation VerifyAccountViewController

-(void)awakeFromNib
{
    
    [super awakeFromNib];
    self.contentSizeInPopup = CGSizeMake([Utils getWindowFrame].size.width - 50, self.contentSizeInPopup.height);
    self.landscapeContentSizeInPopup = CGSizeMake([Utils getWindowFrame].size.width - 100, self.contentSizeInPopup.height);
}

- (IBAction)btnResendClicked:(id)sender {
    
    if (isNeedAskForContact) {
        
        [self performSegueWithIdentifier:@"resendVerification_withoutNumber" sender:self];
    }
    else{
        [self performSegueWithIdentifier:@"resendVerification" sender:self];

    }
    
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

-(void)setupOTPViewWithEmail:(NSString*)email didFinishVerify:(StringBlock)completion
{
    _emailAddress = email;
    
    LoginViewModel* model = [DataManager getLoginModel];
    
    if (![self.emailAddress isEqualToString:model.emailAddress] ||
        [Utils isStringNull:model.prefix] ||
        [Utils isStringNull:model.phoneNumber]) {
        
        isNeedAskForContact = YES;
    }
    
    self.didCompleteBlock = completion;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;

        [self.btnActivate setDefaultBorder];
    
    [self.btnResend setInvertedBorder];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)requestServerResendOtpWithEmail:(NSString*)email Completion:(VoidBlock)completion
{
    
    LoginViewModel* model = [DataManager getLoginModel];
    
    NSString* fullContact = [NSString stringWithFormat:@"%@%@",model.prefix,model.phoneNumber];
    
    NSDictionary* dict = @{
                           @"mobile_number" :IsNullConverstion(fullContact),
                           @"email" : IsNullConverstion(email),
                           };
    
    [ConnectionManager requestServerWith:AFNETWORK_POST serverRequestType:ServerRequestTypePostUserResendOTP parameter:dict appendString:nil success:^(id object) {
        
        if (completion) {
            completion();
        }
        
        NSError* error;

        BaseModel* model = [[BaseModel alloc]initWithDictionary:object error:&error];
        
        [MessageManager showMessage:model.displayMessage Type:TSMessageNotificationTypeSuccess];
      
    } failure:^(id object) {
        
        NSError* error;

        BaseModel* model = [[BaseModel alloc]initWithDictionary:object error:&error];
        
        [MessageManager showMessage:model.displayMessage Type:TSMessageNotificationTypeError];
        

    }];
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"resendVerification"] || [[segue identifier] isEqualToString:@"resendVerification_withoutNumber"]) {
        
        self.resendVerificationCodeViewController = [segue destinationViewController];
        
        __weak typeof (self)weakSelf = self;
        
        if (isNeedAskForContact) {
            
            self.resendVerificationCodeViewController.isWithoutPhoneNumber = YES;
        }
        else{
            self.resendVerificationCodeViewController.isWithoutPhoneNumber = NO;

        }
        
        self.resendVerificationCodeViewController.didSelectResendBlock = ^(void)
        {
            
            if ([Utils isStringNull:weakSelf.resendVerificationCodeViewController.txtEmail.text]) {
                [MessageManager showMessage:@"Please Input A Email Address" Type:TSMessageNotificationTypeError inViewController:weakSelf.resendVerificationCodeViewController];
            }
            else{
            
                [weakSelf requestServerResendOtpWithEmail:weakSelf.resendVerificationCodeViewController.txtEmail.text Completion:^{
                    
                    
                    [weakSelf.popupController popViewControllerAnimated:YES];
                }];
                
            }
           

        };
        
        self.resendVerificationCodeViewController.didSelectResendWithNumberBlock = ^(NSString* prefix, NSString* number)
        {
            if ([Utils isStringNull:prefix]) {
                [MessageManager showMessage:@"Please select prefix" Type:TSMessageNotificationTypeError inViewController:weakSelf.resendVerificationCodeViewController];
            }
            else if([Utils isStringNull:number]){
               
                [MessageManager showMessage:@"Please input phone number" Type:TSMessageNotificationTypeError inViewController:weakSelf.resendVerificationCodeViewController];
            }
            
            else{
                
                LoginViewModel* model = [DataManager getLoginModel];
                
                
                if (!model) {
                    
                    model = [LoginViewModel new];
                    
                }
                
                model.prefix = prefix;
                
                model.phoneNumber = number;
                
                model.emailAddress = weakSelf.emailAddress;
                
                [DataManager setLoginModel:model];
                
                [weakSelf requestServerResendOtpWithEmail:weakSelf.resendVerificationCodeViewController.txtEmail.text Completion:^{
                    
                    
                    [weakSelf.popupController popViewControllerAnimated:YES];
                }];
                
            }
            
            
        };

    
        
    }


    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end

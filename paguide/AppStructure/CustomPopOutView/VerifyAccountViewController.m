//
//  VerifyAccountViewController.m
//  paguide
//
//  Created by Evan Beh on 14/03/2017.
//  Copyright © 2017 Evan Beh. All rights reserved.
//

#import "VerifyAccountViewController.h"
#import <STPopup/STPopup.h>
#import "EBActionSheetViewController.h"

@protocol CountryModel;

@interface VerifyAccountViewController ()
{
    NSString* emailAddress;
    NSString* mobile_number;
    NSString* mobile_prefix;

}

@property (nonatomic, strong)NSArray<CountryModel>* arrCountryList;

@property (weak, nonatomic) IBOutlet UITextField *txtVerifyCode;
@property (weak, nonatomic) IBOutlet UIButton *btnResend;
@property (weak, nonatomic) IBOutlet UIButton *btnActivate;
@property(nonatomic,copy)StringBlock didCompleteBlock;

@property (nonatomic,strong)ResendVerificationCodeViewController* resendVerificationCodeViewController;
@end

@implementation VerifyAccountViewController
- (IBAction)btnResendClicked:(id)sender {
    
   
    
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

-(void)setupOTPViewWitPhonePrefix:(NSString*)prefix PhoneNumber:(NSString*)mobileNumber Email:(NSString*)email didFinishVerify:(StringBlock)completion
{
    emailAddress = email;
    mobile_number = mobileNumber;
    mobile_prefix = prefix;
    
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

-(NSArray*)getPrefixList:(NSArray*)countryList
{
    
    NSMutableArray* array = [NSMutableArray new];
    
    for (int i = 0; i<countryList.count; i++) {
        
        CountryModel* model = countryList[i];
        
        NSString* combinedString = [NSString stringWithFormat:@"%@ (%@)",model.c_prefix,model.c_name];
        
        [array addObject:combinedString];
    }
    
    return array;
}

-(void)showPrefixView:(StringBlock)completion
{
    
    VoidBlock openPopOutView = ^(void)
    {
        EBActionSheetViewController* viewC = [[EBActionSheetViewController alloc]initWithNibName:@"EBActionSheetViewController" bundle:nil];
        viewC.title = @"Prefix";
        
        viewC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        viewC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        
        viewC.arrItemList = [self getPrefixList:self.arrCountryList];
        
        [self presentViewController:viewC animated:YES completion:nil];
        
        [viewC setInitial:[NSIndexPath indexPathForRow:[self getSingaporeIndexPath] inSection:0]];

        __weak typeof (viewC)weakVC = viewC;
        
        viewC.didSelectAtIndexBlock = ^(NSIndexPath* indexPath)
        {
            [weakVC dismissViewControllerAnimated:YES completion:^{
                
                CountryModel* model = self.arrCountryList[indexPath.row];
                
                NSString* prefix = model.c_prefix;
                
                if (completion) {
                    completion(prefix);
                }
            }];
            
        };
    };
    
    
    
    [[DataManager Instance] getCountryList:^(NSArray *array) {
        
        self.arrCountryList = (NSArray<CountryModel>*)array;
        
        
        openPopOutView();
        
    }];
    
    
}

-(int)getSingaporeIndexPath
{
    
    int index = 0;
    
    for (int i = 0; i<self.arrCountryList.count; i++) {
        
        
        CountryModel* model = self.arrCountryList[i];
        
        if ([model.c_name isEqualToString:@"Singapore"]) {
            
            index = i;
            
            return index;
            
        }
    }
    
    return index;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"pop_resend_verify"]) {
        
        self.resendVerificationCodeViewController = [segue destinationViewController];
        
        __weak typeof (self)weakSelf = self;
        
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
    
        
    }
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end

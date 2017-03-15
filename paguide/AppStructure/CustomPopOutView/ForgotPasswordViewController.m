//
//  ForgotPasswordViewController.m
//  paguide
//
//  Created by Evan Beh on 14/03/2017.
//  Copyright © 2017 Evan Beh. All rights reserved.
//

#import "ForgotPasswordViewController.h"
#import "EBActionSheetViewController.h"
#import "CountryModel.h"

@protocol CountryModel

@end

@interface ForgotPasswordViewController ()

@property (weak, nonatomic) IBOutlet UIButton *btnReset;
@property (weak, nonatomic) IBOutlet UITextField *txtPhoneNumber;

@property (weak, nonatomic) IBOutlet UIButton *btnPrefix;
@property(nonatomic,copy)VoidBlock didPressResetBlock;

@property (nonatomic, strong)NSArray<CountryModel>* arrCountryList;

@end

@implementation ForgotPasswordViewController
- (IBAction)btnResetClicked:(id)sender {
    
    
    if ([self.btnPrefix.titleLabel.text isEqualToString:@"Prefix"] ||
        [Utils isStringNull:self.btnPrefix.titleLabel.text]) {
        
        [MessageManager showMessage:@"Please select a Prefix"Type:TSMessageNotificationTypeSuccess inViewController:self];

        
    }
    else if([Utils isStringNull:self.txtPhoneNumber.text])
    {
        [MessageManager showMessage:@"Please input phone number"Type:TSMessageNotificationTypeSuccess inViewController:self];

    }
    [self requestServerForForgotPassword];
//    if (self.didPressResetBlock) {
//        self.didPressResetBlock();
//    }
}
- (IBAction)btnPrefixClicked:(id)sender {
    
    [self showPrefixView:^(NSString *str) {
        
        
        [self.btnPrefix setTitle:str forState:UIControlStateNormal];
        
      
        
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.btnReset setDefaultBorder];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)showPrefixView:(StringBlock)completion
{
    
    VoidBlock openPopOutView = ^(void)
    {
        EBActionSheetViewController* viewC = [[EBActionSheetViewController alloc]initWithNibName:@"EBActionSheetViewController" bundle:nil];
        viewC.title = @"Country Selection";
        // viewC.view.backgroundColor = [UIColor colorWithRed:10 green:10 blue:10 alpha:0.5];
        //  UINavigationController* navC = [[UINavigationController alloc]initWithRootViewController:viewC];
        
        // [navC setNavigationBarHidden:YES];
        
        viewC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        viewC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        
        viewC.arrItemList = [self.arrCountryList valueForKey:@"c_prefix"];
        
        [self presentViewController:viewC animated:YES completion:nil];
        
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




-(void)requestServerForForgotPassword
{
    
    NSString* prefix = self.btnPrefix.titleLabel.text;
    
    NSString* number = self.txtPhoneNumber.text;
    
    
    NSString* combineNumber = [NSString stringWithFormat:@"%@%@",prefix,number];
    
    combineNumber = @"+60175168607";
    
    NSDictionary* dict = @{@"mobile_number" : IsNullConverstion(combineNumber)
                           };
    
    [ConnectionManager requestServerWith:AFNETWORK_POST serverRequestType:ServerRequestTypePostUserForgotPassword parameter:dict appendString:nil success:^(id object) {
        
        BaseModel* model = [[BaseModel alloc]initWithDictionary:object error:nil];
        
        [MessageManager showMessage:model.displayMessage Type:TSMessageNotificationTypeSuccess inViewController:self];

    
        
    } failure:^(id object) {
        
    }];
}



@end

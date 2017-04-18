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
        
        [MessageManager showMessage:@"Please select a Prefix"Type:TSMessageNotificationTypeError inViewController:self];
        
    }
    else if([Utils isStringNull:self.txtPhoneNumber.text])
    {
        [MessageManager showMessage:@"Please input phone number"Type:TSMessageNotificationTypeError inViewController:self];

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
        
        CountryModel* defaultSelection = [DataManager getDefaultPrefix];
        NSArray* arrDefault;
        
        if (defaultSelection) {
            
            arrDefault = @[defaultSelection];
            
            [viewC setDefaultData:[self getPrefixList:arrDefault]];
        }
        
        viewC.arrItemList = [self getPrefixList:self.arrCountryList];
        
        [self presentViewController:viewC animated:YES completion:nil];
        
        //   [viewC setInitial:[NSIndexPath indexPathForRow:[self getSingaporeIndexPath] inSection:[Utils isArrayNull:arrDefault]?0:1]];
        
        __weak typeof (viewC)weakVC = viewC;
        
        viewC.didSelectAtIndexBlock = ^(NSIndexPath* indexPath)
        {
            [weakVC dismissViewControllerAnimated:YES completion:^{
                NSString* prefix;
                
                if ([Utils isArrayNull:arrDefault]) {
                    
                    CountryModel* model = self.arrCountryList[indexPath.row];
                    
                    prefix = model.c_prefix;
                    
                    [DataManager saveDefaultPrefix:model];
                }
                else{
                    
                    
                    if (indexPath.section == 0) {
                        CountryModel* model = arrDefault[indexPath.row];
                        
                        prefix = model.c_prefix;
                    }
                    else{
                        
                        CountryModel* model = self.arrCountryList[indexPath.row];
                        
                        prefix = model.c_prefix;
                        
                        [DataManager saveDefaultPrefix:model];
                        
                    }
                    
                }
                
                
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

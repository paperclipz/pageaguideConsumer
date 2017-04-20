//
//  ResendVerificationCodeViewController.m
//  paguide
//
//  Created by Evan Beh on 29/03/2017.
//  Copyright © 2017 Evan Beh. All rights reserved.
//

#import "ResendVerificationCodeViewController.h"
#import "EBActionSheetViewController.h"

@protocol CountryModel;

@interface ResendVerificationCodeViewController ()
@property (weak, nonatomic) IBOutlet UIButton *btnResend;
@property (weak, nonatomic) IBOutlet UITextField *txtPhoneNumber;

@property (weak, nonatomic) IBOutlet UIButton *btnPrefix;
@property (nonatomic, strong)NSArray<CountryModel>* arrCountryList;

@end

@implementation ResendVerificationCodeViewController

- (IBAction)btnPrefixClicked:(id)sender {
    
    [self showPrefixView:^(NSString *str) {
        
        [self.btnPrefix setTitle:str forState:UIControlStateNormal];
    }];
}

- (IBAction)btnResendClicked:(id)sender {
    
    
    if (self.isWithoutPhoneNumber) {
        
        if (self.didSelectResendWithNumberBlock) {

            self.didSelectResendWithNumberBlock(self.btnPrefix.titleLabel.text,self.txtPhoneNumber.text);
        }
    }
    else{
    
        
        if (self.didSelectResendBlock)
        {
            self.didSelectResendBlock();
        }
    }
   
    
    
        
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;

    [self.btnResend setDefaultBorder];
    // Do any additional setup after loading the view from its nib.
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

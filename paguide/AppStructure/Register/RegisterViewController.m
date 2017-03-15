//
//  RegisterViewController.m
//  paguide
//
//  Created by Evan Beh on 27/02/2017.
//  Copyright © 2017 Evan Beh. All rights reserved.
//

#import "RegisterViewController.h"
#import "RegisterTableViewCell.h"
#import "EBActionSheetViewController.h"
#import "CountryModel.h"
#import "LoginViewModel.h"
#import "VerifyAccountViewController.h"
#import "ForgotPasswordViewController.h"

#define viewTypeLogin @"login"
#define viewTypeRegister @"register"

@protocol KeyValueModel;
@protocol CountryModel;


@interface RegisterViewController () <UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *ibTableView;
@property (strong, nonatomic)VerifyAccountViewController* verifyAccountViewController;
// UI
@property (weak, nonatomic) IBOutlet UIButton *btnSubmit;
@property (nonatomic,strong) NSMutableArray* arrItemList;
@property (nonatomic, strong)NSString* viewType;

// MODEL
@property (nonatomic, strong)NSArray<CountryModel>* arrCountryList;

@end

@implementation RegisterViewController
- (IBAction)btnForgetPasswordClicked:(id)sender {
    
    [self showForgetPasswordView];
}
- (IBAction)btnLoginClicked:(id)sender {
    
    
}
- (IBAction)btnFbLoginClicked:(id)sender {
}
- (IBAction)btnSubmitClicked:(id)sender {
  
    if ([self.viewType isEqualToString:viewTypeRegister]) {

        
        [self requestServerForRegister];

//        if (![self validateData]) {
//            
//            [self requestServerForRegister];
//        };
        
    }
}
- (IBAction)btnTestClicked:(id)sender {
    
   // self.definesPresentationContext = YES;
    
   // [self showActionView];
    
}
- (IBAction)btnBackClicked:(id)sender {
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - System lifecycle

-(void)viewWillAppear:(BOOL)animated
{
    
    if ([self.viewType isEqualToString:viewTypeLogin]) {
    
        [self.navigationController setNavigationBarHidden:YES];

    }
    else{
        [self.navigationController setNavigationBarHidden:NO];

    }
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    if ([self.viewType isEqualToString:viewTypeLogin]) {
        
        [self.navigationController setNavigationBarHidden:NO];
        
    }
    else
    {
        [self.navigationController setNavigationBarHidden:NO];

    }

}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self initSelfView];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - View Object


-(void)initSelfView
{
    [Utils setRoundBorder:self.btnSubmit color:[UIColor clearColor] borderRadius:5.0f];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.view.backgroundColor = [UIColor clearColor];
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    
}

-(NSMutableArray*)arrItemList
{
    
    if (!_arrItemList) {
        

        NSMutableArray* arrayTemp = [NSMutableArray new];
        
        LoginViewModel* obj = [LoginViewModel new];
        obj.type = REGISTER_CELL_TYPE_email_address;
        [arrayTemp addObject:obj];
        
        obj = [LoginViewModel new];
        obj.type = REGISTER_CELL_TYPE_name;
        [arrayTemp addObject:obj];
        
        obj = [LoginViewModel new];
        obj.type = REGISTER_CELL_TYPE_Password;
        [arrayTemp addObject:obj];
        
        obj = [LoginViewModel new];
        obj.type = REGISTER_CELL_TYPE_RE_Password;
        [arrayTemp addObject:obj];
        
        obj = [LoginViewModel new];
        obj.type = REGISTER_CELL_TYPE_country;
        [arrayTemp addObject:obj];
        
        obj = [LoginViewModel new];
        obj.type = REGISTER_CELL_TYPE_phone_number;
        [arrayTemp addObject:obj];
        
        obj = [LoginViewModel new];
        obj.type = REGISTER_CELL_TYPE_TNC;
        [arrayTemp addObject:obj];
        
        _arrItemList = arrayTemp;

        
    }

    return _arrItemList;
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrItemList.count;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    LoginViewModel* obj = self.arrItemList[indexPath.row];
    
    REGISTER_CELL_TYPE cellType = obj.type;

    
    if (cellType == REGISTER_CELL_TYPE_TNC) {
        
        RegisterTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"registerCell2"];
        
        KeyValueModel* model = [KeyValueModel new];
        model.key = @"termofservice";
        model.value = @"Terms of Service";
        
        KeyValueModel* model2 = [KeyValueModel new];
        model2.key = @"privacypolicy";
        model2.value = @"Privacy Policy";
        
        NSArray* array = @[model,model2];
        
        [cell setup:T_N_C KeyValue:array DidClickBlock:^(NSString *str) {
            
            
            for (int i = 0; i<array.count; i++) {
                
                KeyValueModel* tempModel = array[i];
                
                if ([tempModel.key isEqualToString:@"termofservice"] ) {
                    [self showTermOfUseView];
                    break;
                }
                else if ([tempModel.key isEqualToString:@"privacypolicy"] ) {
                    
                    [self showPrivacyView];
                    break;
                    
                }
            }
            
        }];
        return cell;


    }
    else if (cellType == REGISTER_CELL_TYPE_country)
    {
        RegisterTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"registercell3"];
        
        cell.loginViewModel = obj;
        
        
        __weak typeof (cell)weakCell = cell;
        
        cell.didSelectBlock = ^(void)
        {
            [self showCountryView:^(NSString *str) {
                
                weakCell.loginViewModel.countryName = str;
                
                [self.arrItemList replaceObjectAtIndex:indexPath.row withObject:weakCell.loginViewModel];
                
                [self.ibTableView reloadData];
                
            }];
        };
        
        return cell;

    
    
    }
    
    else if (cellType == REGISTER_CELL_TYPE_phone_number)
    {
        RegisterTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"registercell4"];
        
        cell.loginViewModel = obj;
        
        
        __weak typeof (cell)weakCell = cell;

        cell.didSelectBlock = ^(void)
        {
            //[self showActionView];
            
            [self showPrefixView:^(NSString *str) {
                
                weakCell.loginViewModel.prefix = str;
                
                [self.arrItemList replaceObjectAtIndex:indexPath.row withObject:weakCell.loginViewModel];
                
                [self.ibTableView reloadData];

            }];

        };
        
        
        cell.didUpdateModelBlock = ^(LoginViewModel* model)
        {
            [self.arrItemList replaceObjectAtIndex:indexPath.row withObject:model];
        };
        return cell;
        
    }
   
    else{
    
        RegisterTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"registerCell" forIndexPath:indexPath];

        cell.loginViewModel = obj;
    
        cell.didUpdateModelBlock = ^(LoginViewModel* model)
        {
            [self.arrItemList replaceObjectAtIndex:indexPath.row withObject:model];
        };
        
        return cell;
    }

    
   
}



-(void)showPrivacyView
{
    NSLog(@"showPrivacyView");

}

-(void)showTermOfUseView
{
    NSLog(@"showTermOfUseView");
}

-(void)showCountryView:(StringBlock)completion
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
        
        viewC.arrItemList = [self.arrCountryList valueForKey:@"c_name"];
        
        [self presentViewController:viewC animated:YES completion:nil];
        
        __weak typeof (viewC)weakVC = viewC;
        
        viewC.didSelectAtIndexBlock = ^(NSIndexPath* indexPath)
        {
            [weakVC dismissViewControllerAnimated:YES completion:^{
               
                
                CountryModel* model = self.arrCountryList[indexPath.row];
                
                NSString* countryName = model.c_name;
                
                if (completion) {
                    completion(countryName);
                }
            }];
           
        };
    };
    
    if ([Utils isArrayNull:self.arrCountryList]) {
        
        [self requestServerForCountryList:^{
            
            openPopOutView();
          //  openPopOutView();
        }];
    }
    else{
        openPopOutView();

    }
    
  
}

-(void)showOTPView
{
    
    LoginViewModel* model = [self getData];
    
    _verifyAccountViewController = nil;
    
    self.verifyAccountViewController = [VerifyAccountViewController new];
    
    self.verifyAccountViewController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    
    self.verifyAccountViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    
    [self presentViewController:self.verifyAccountViewController animated:YES completion:nil];
    
    
    [self.verifyAccountViewController setupOTPView:model.phoneNumber Email:model.emailAddress didFinishVerify:^(NSString* otp){
       
        [self requestServerForVerifyOTP:otp];
    }];
}
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
    
    if ([Utils isArrayNull:self.arrCountryList]) {
        
        [self requestServerForCountryList:^{
            
            openPopOutView();
            //  openPopOutView();
        }];
    }
    else{
        openPopOutView();
        
    }
    
    
    
    
}

-(void)showForgetPasswordView
{
    
    
    ForgotPasswordViewController* forgotPasswordViewController = [ForgotPasswordViewController new];
    
    forgotPasswordViewController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    
    forgotPasswordViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    
    [self presentViewController:forgotPasswordViewController animated:YES completion:nil];
    

}



#pragma mark - Request Server


-(void)requestServerForLogin
{
    
    NSDictionary* dict = @{@"email" : @"imexlight@gmail.com",
                           @"password" : @"pa12345",
                           };
    
    [ConnectionManager requestServerWith:AFNETWORK_POST serverRequestType:ServerRequestTypePostUserLogin parameter:dict appendString:nil success:^(id object) {
        
        
        BaseModel* model = [[BaseModel alloc]initWithDictionary:object error:nil];
        
        [self dismissViewControllerAnimated:YES completion:^{
            
            [MessageManager showMessage:model.displayMessage Type:TSMessageNotificationTypeSuccess];
            
        }];

    } failure:^(id object) {
        
    }];
    [GVUserDefaults standardUserDefaults].token = @"myusername";

}
-(void)requestServerForRegister
{
    
    LoginViewModel* model = [self getData];
    
    NSDictionary* dict = @{@"email" : IsNullConverstion(model.emailAddress),
                           @"username" : IsNullConverstion(model.name),
                           @"password" : IsNullConverstion(model.password),
                           @"mobile_number" : IsNullConverstion(model.phoneNumber),
                           @"country" : IsNullConverstion(model.countryName),
                           };

    [ConnectionManager requestServerWith:AFNETWORK_POST serverRequestType:ServerRequestTypePostUserRegister parameter:dict appendString:nil success:^(id object) {
        
        [self showOTPView];

        BaseModel* model = [[BaseModel alloc]initWithDictionary:object error:nil];
        
        [MessageManager showMessage:model.displayMessage Type:TSMessageNotificationTypeSuccess inViewController:self];

      
    } failure:^(id object) {
       
        BaseModel* model = [[BaseModel alloc]initWithDictionary:object error:nil];

        [MessageManager showMessage:model.displayMessage Type:TSMessageNotificationTypeError inViewController:self];
        
    }];
}


-(void)requestServerForCountryList:(VoidBlock)completionBlock
{
    
    [[DataManager Instance] getCountryList:^(NSArray *array) {
        
        self.arrCountryList = (NSArray<CountryModel>*)array;
        
        if (completionBlock)
        {
            completionBlock();
        }
            
    }];
    
}

-(void)requestServerForVerifyOTP:(NSString*)otp
{
    
    LoginViewModel* model = [self getData];
    
    NSDictionary* dict = @{@"mobile_number" :IsNullConverstion(model.phoneNumber) ,
                           
                           @"otp" : IsNullConverstion(otp),
                           };
    
    [ConnectionManager requestServerWith:AFNETWORK_POST serverRequestType:ServerRequestTypePostUserVerifyOTP parameter:dict appendString:nil success:^(id object) {
        
        
        NSError* error;
        
        BaseModel* model = [[BaseModel alloc]initWithDictionary:object error:&error];
        
        [self dismissViewControllerAnimated:YES completion:^{
            
            [self dismissViewControllerAnimated:YES completion:^{
                [MessageManager showMessage:model.displayMessage Type:TSMessageNotificationTypeSuccess];

            }];
 
        }];
               
        
    } failure:^(id object) {
        
        NSError* error;
        
        BaseModel* model = [[BaseModel alloc]initWithDictionary:object error:&error];
        
        [MessageManager showMessage:model.displayMessage Type:TSMessageNotificationTypeError inViewController:self.verifyAccountViewController];
        
        
    }];
}


#pragma mark - Validation

-(LoginViewModel*)getData
{
    LoginViewModel* tempModel = [LoginViewModel new];

    for (int  i = 0;i <self.arrItemList.count ; i++)
    {
        LoginViewModel* model = self.arrItemList[i];
        switch (model.type) {
            case REGISTER_CELL_TYPE_email_address:
                
             
                tempModel.emailAddress = model.emailAddress;
                
                break;
            case REGISTER_CELL_TYPE_name:
                
                tempModel.name = model.name;

                break;
            case REGISTER_CELL_TYPE_country:
                tempModel.countryName = model.countryName;

                break;
            case REGISTER_CELL_TYPE_phone_number:
                
                tempModel.prefix = model.prefix;

                tempModel.phoneNumber = model.phoneNumber;

                break;
            case REGISTER_CELL_TYPE_TNC:
                
                break;
            case REGISTER_CELL_TYPE_Password:
               
                tempModel.password = model.password;

                break;
            case REGISTER_CELL_TYPE_RE_Password:
                
                tempModel.retypepassword = model.retypepassword;
                break;
                
            default:
                break;
        }
        
    }

    
    //for testing only
  
    tempModel.emailAddress = @"imexlight@gmail.com";
    tempModel.name = @"paperclipz",
    tempModel.phoneNumber = @"+60175168607";
    tempModel.countryName = @"Malaysia";
    tempModel.password = @"pa12345";

    return tempModel;
}
-(BOOL)validateData
{
    
    BOOL hasError = NO;
    NSString* errorMessage = @"";
    LoginViewModel* model = [self getData];
  
    if ([Utils isStringNull:model.emailAddress]) {
        errorMessage = @"Please input email address";
        
        hasError = YES;
    }
    else  if ([Utils isStringNull:model.name]) {
        errorMessage = @"Please input your name";
        
        hasError = YES;

    }
    else if ([Utils isStringNull:model.password]) {
        errorMessage = @"Please input a password";
        hasError = YES;

    }
    
    
    else if ([Utils isStringNull:model.retypepassword]) {
        errorMessage = @"Please confirm your password";
        hasError = YES;

    }
    
    else if (![model.password isEqualToString:model.retypepassword]) {
        errorMessage = @"Confirm Password is not same as password";
        
        hasError = YES;

    }

    
    else  if ([model isCountryNull]) {
        errorMessage = @"Please select a country";
        hasError = YES;

    }
    else if ([model isPrefixNull]) {
        errorMessage = @"Please select a prefix";
        hasError = YES;

    }
    
    else if ([Utils isStringNull:model.phoneNumber]) {
        errorMessage = @"Please input phone number";
        hasError = YES;

    }
    

    if (hasError) {
        [MessageManager showMessage:errorMessage Type:TSMessageNotificationTypeError inViewController:self];

    }
    
    return hasError;
    
}

#pragma mark - Declaration

@end

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
#import "WebViewController.h"
#import "FBLoginManager.h"
#import "RegisterViewController.h"
#import <STPopup/STPopup.h>
#import "ResendVerificationCodeViewController.h"

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

@property (weak, nonatomic) IBOutlet UITextField *txtEmail;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;
@property (nonatomic, strong)STPopupController* stPopupController;


@end

@implementation RegisterViewController

- (IBAction)btnForgetPasswordClicked:(id)sender {
    
    [self showForgetPasswordView];
}
- (IBAction)btnLoginClicked:(id)sender {
    
    [self requestServerForLogin];
    
}
- (IBAction)btnFbLoginClicked:(id)sender {
    
    [FBLoginManager performFacebookGraphRequestWithLoginRequest:^(FacebookModel *modal) {
        
        self.fbModel = modal;
        
        [self requestServerForLoginWithFacebook:modal];

        
    } InViewController:self];
    
}

- (IBAction)btnSubmitClicked:(id)sender {
  
    if ([self.viewType isEqualToString:viewTypeRegister]) {

        
        if (self.type == REGISTER_TYPE_FACEBOOK) {
            
            [self requestServerForRegisterFacebook:self.fbModel];

        }
        else{
            [self requestServerForRegister];

        }

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
        
        if (self.type == REGISTER_TYPE_FACEBOOK) {
            
            NSMutableArray* arrayTemp = [NSMutableArray new];
            
            LoginViewModel* obj = [LoginViewModel new];
            obj.type = REGISTER_CELL_TYPE_email_address;
            [arrayTemp addObject:obj];
            
            obj = [LoginViewModel new];
            obj.type = REGISTER_CELL_TYPE_name;
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
        else{
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
            
            [self.view endEditing:YES];

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

    WebViewController* webView = [WebViewController new];
        
    webView.webViewURL = [NSString stringWithFormat:@"http://%@%@",[ConnectionManager getServerPath],@"/privacy"];

    [self presentViewController:webView animated:YES completion:nil];
}

-(void)showTermOfUseView
{
    NSLog(@"showTermOfUseView");
    
    WebViewController* webView = [WebViewController new];
    
    webView.webViewURL = [NSString stringWithFormat:@"http://%@%@",[ConnectionManager getServerPath],@"/terms"];

    
    [self presentViewController:webView animated:YES completion:nil];
}

-(void)showCountryView:(StringBlock)completion
{
    VoidBlock openPopOutView = ^(void)
    {
        EBActionSheetViewController* viewC = [[EBActionSheetViewController alloc]initWithNibName:@"EBActionSheetViewController" bundle:nil];
        viewC.title = @"Country";
        
        viewC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        viewC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        
        viewC.arrItemList = [self.arrCountryList valueForKey:@"c_name"];
        
        CountryModel* defaultSelection = [DataManager getDefaultCountry];
        
        NSArray* arrDefault;
        
        if (defaultSelection) {
            
            arrDefault = @[defaultSelection];
            
            [viewC setDefaultData:[arrDefault valueForKey:@"c_name"]];
        }
        
        
        [self presentViewController:viewC animated:YES completion:nil];
        
        //  [viewC setInitial:[NSIndexPath indexPathForRow:[self getSingaporeIndexPath] inSection:0]];
        
        __weak typeof (viewC)weakVC = viewC;
        
        viewC.didSelectAtIndexBlock = ^(NSIndexPath* indexPath)
        {
            [weakVC dismissViewControllerAnimated:YES completion:^{
                
                NSString* country;
                
                if ([Utils isArrayNull:arrDefault]) {
                    
                    CountryModel* model = self.arrCountryList[indexPath.row];
                    
                    country = model.c_name;
                    
                    [DataManager saveDefaultCountry:model];
                    
                }
                else{
                    
                    
                    if (indexPath.section == 0) {
                        
                        CountryModel* model = arrDefault[indexPath.row];
                        
                        country = model.c_name;
                    }
                    else{
                        
                        CountryModel* model = self.arrCountryList[indexPath.row];
                        
                        country = model.c_name;
                        
                        [DataManager saveDefaultCountry:model];
                    }
                    
                }
                
                
                
                
                
                if (completion) {
                    completion(country);
                }
            }];
            
        };
    };
    
    
    [[DataManager Instance] getCountryList:^(NSArray *array) {
        
        self.arrCountryList = (NSArray<CountryModel>*)array;
        
        
        openPopOutView();
        
    }];
    
    
}

-(void)showOTPView
{
        
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"PopOut" bundle:nil];
    
    self.verifyAccountViewController = [storyboard instantiateViewControllerWithIdentifier:@"sb_popout"];
    
    self.stPopupController = [[STPopupController alloc] initWithRootViewController:self.verifyAccountViewController];

    [self.verifyAccountViewController setupOTPViewWithEmail:self.txtEmail.text didFinishVerify:^(NSString *str) {
        
        [self requestServerForVerifyOTP:str Completion:^(NSString *message) {
            
            [MessageManager showMessage:message Type:TSMessageNotificationTypeSuccess inViewController:self];
            
            [self.stPopupController dismiss];
            
            [self.navigationController popToRootViewControllerAnimated:YES];
            
        }];
    }];
    
   
    [self.stPopupController presentInViewController:self];
}


-(void)showResendView
{
    
    
    
    VerifyAccountViewController* viewC = [VerifyAccountViewController new];
    
    viewC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    
    viewC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    
    [self presentViewController:viewC animated:YES completion:nil];
    
    

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
    
//    NSDictionary* dict = @{@"email" : @"imexlight@gmail.com",
//                           @"password" : @"pa12345",
//                           };
    
    NSDictionary* dict = @{@"email" : IsNullConverstion(self.txtEmail.text),
                           @"password" : IsNullConverstion(self.txtPassword.text),
                           };
    
    [self.view endEditing:YES];
    
    [LoadingManager show];
    
    [ConnectionManager requestServerWith:AFNETWORK_POST serverRequestType:ServerRequestTypePostUserLogin parameter:dict appendString:nil success:^(id object) {
        
        [LoadingManager hide];

        BaseModel* model = [[BaseModel alloc]initWithDictionary:object error:nil];
        
        [Utils setAppToken:model.token];
        
        [Utils setUserEmail:self.txtEmail.text];
        
        [Utils setSelectedTabbarIndex:0];
        
        [Utils reloadAllFrontView];
        
        [self dismissViewControllerAnimated:YES completion:^{
            
            [MessageManager showMessage:model.displayMessage Type:TSMessageNotificationTypeSuccess];
            
        }];
        
        [DataManager requestServerForRegisterDevice];

    } failure:^(id object) {
        
        [LoadingManager hide];

        BaseModel* model = [[BaseModel alloc]initWithDictionary:object error:nil];
        
        if ([model.status_code  isEqual: @(202)]) {
            
            
            [self performSegueWithIdentifier:@"register_fb" sender:self];
            //[self requestServerForRegisterFacebook:model];
            NSLog(@"fb ID not registered");
        }
        
        else if ([model.status_code  isEqual: @(205)]) {
            
            [self showOTPView];
            
            
        }
        else
        {
            [MessageManager showMessage:model.displayMessage Type:TSMessageNotificationTypeError inViewController:self];

        }

    }];

}

-(void)requestServerForLoginWithFacebook:(FacebookModel*)model
{
    
    NSDictionary* dict = @{@"fbid" : model.uID,
                           @"fb_access_token" : model.fbToken,
                           };
    
    [self.view endEditing:YES];

    [LoadingManager show];
    
    [ConnectionManager requestServerWith:AFNETWORK_POST serverRequestType:ServerRequestTypePostUserLogin parameter:dict appendString:nil success:^(id object) {
        
        [LoadingManager hide];

        BaseModel* bmodel = [[BaseModel alloc]initWithDictionary:object error:nil];
        
        [Utils setAppToken:bmodel.token];
        
        [Utils setUserEmail:model.uID];

        [Utils setSelectedTabbarIndex:0];

        [Utils reloadAllFrontView];

        [self dismissViewControllerAnimated:YES completion:^{
            
            [MessageManager showMessage:bmodel.displayMessage Type:TSMessageNotificationTypeSuccess];
            
        }];
        
        [DataManager requestServerForRegisterDevice];

        
    } failure:^(id object) {

        [LoadingManager hide];

        BaseModel* model = [[BaseModel alloc]initWithDictionary:object error:nil];
        
        if ([model.status_code  isEqual: @(202)]) {
            
            
            [self performSegueWithIdentifier:@"register_fb" sender:self];
            //[self requestServerForRegisterFacebook:model];
            NSLog(@"fb ID not registered");
        }
        
        else if ([model.status_code  isEqual: @(205)]) {

            [self showOTPView];
            
            
        }
    }];
    
}

-(void)requestServerForRegister
{
    LoginViewModel* model = [self getData];
    
    NSString* contactNo = [NSString stringWithFormat:@"%@%@",model.prefix,model.phoneNumber];

    NSDictionary* dict = @{@"email" : IsNullConverstion(model.emailAddress),
                           @"username" : IsNullConverstion(model.name),
                           @"password" : IsNullConverstion(model.password),
                           @"mobile_number" : IsNullConverstion(contactNo),
                           @"country" : IsNullConverstion(model.countryName),
                           };

    [ConnectionManager requestServerWith:AFNETWORK_POST serverRequestType:ServerRequestTypePostUserRegister parameter:dict appendString:nil success:^(id object) {
        
        [DataManager setLoginModel:model];
        
        [self showOTPView];

        BaseModel* model = [[BaseModel alloc]initWithDictionary:object error:nil];
        
        [MessageManager showMessage:model.displayMessage Type:TSMessageNotificationTypeSuccess inViewController:self];

      
    } failure:^(id object) {
       
        BaseModel* model = [[BaseModel alloc]initWithDictionary:object error:nil];

        [MessageManager showMessage:model.displayMessage Type:TSMessageNotificationTypeError inViewController:self];
        
    }];
}

-(void)requestServerForRegisterFacebook:(FacebookModel*)fbModel
{
    
    LoginViewModel* model = [self getData];
    
    NSString* contactNo = [NSString stringWithFormat:@"%@%@",model.prefix,model.phoneNumber];
    
    NSDictionary* dict = @{@"email" : IsNullConverstion(model.emailAddress),
                           @"username" : IsNullConverstion(model.name),
                           @"mobile_number" : IsNullConverstion(contactNo),
                           @"country" : IsNullConverstion(model.countryName),
                           @"fbid" : IsNullConverstion(fbModel.uID),
                           };
    
    [ConnectionManager requestServerWith:AFNETWORK_POST serverRequestType:ServerRequestTypePostUserRegister parameter:dict appendString:nil success:^(id object) {
        
        LoginViewModel* viewModel = [LoginViewModel new];
        
        viewModel = model;
        
        viewModel.fbid = fbModel.uID;
        
        viewModel.fbToken = fbModel.fbToken;
        
        [DataManager setLoginModel:viewModel];
        
        [self showOTPView];
        
        BaseModel* model = [[BaseModel alloc]initWithDictionary:object error:nil];
        
        [MessageManager showMessage:model.displayMessage Type:TSMessageNotificationTypeSuccess inViewController:self];
        
        
    } failure:^(id object) {
        
        BaseModel* model = [[BaseModel alloc]initWithDictionary:object error:nil];
        
        [MessageManager showMessage:model.displayMessage Type:TSMessageNotificationTypeError inViewController:self];
        
    }];
}

-(void)requestServerForVerifyOTP:(NSString*)otp Completion:(StringBlock)completion
{
    
    LoginViewModel* model = [DataManager getLoginModel];
    
    
    NSDictionary* dict = @{@"mobile_number" :IsNullConverstion(model.fullContactNumber) ,
                           
                           @"otp" : IsNullConverstion(otp),
                           };
    
    [ConnectionManager requestServerWith:AFNETWORK_POST serverRequestType:ServerRequestTypePostUserVerifyOTP parameter:dict appendString:nil success:^(id object) {
        
        
        NSError* error;
        
        BaseModel* model = [[BaseModel alloc]initWithDictionary:object error:&error];
        
        
        if (completion) {
            completion(model.displayMessage);
        }
        
        
    } failure:^(id object) {
        
        NSError* error;
        
        BaseModel* model = [[BaseModel alloc]initWithDictionary:object error:&error];
        
        [MessageManager showMessage:model.displayMessage Type:TSMessageNotificationTypeError];
        
        
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
  
//    tempModel.emailAddress = @"imexlight@gmail.com";
//    tempModel.name = @"paperclipz",
//    tempModel.phoneNumber = @"+60175168607";
//    tempModel.countryName = @"Malaysia";
//    tempModel.password = @"pa12345";

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

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([[segue identifier] isEqualToString:@"register_fb"]) {
        
        
        RegisterViewController* viewC = [segue destinationViewController];
        
        viewC.fbModel = self.fbModel;

        
        viewC.type = REGISTER_TYPE_FACEBOOK;
    }
    else  if ([[segue identifier] isEqualToString:@"register_normal"]) {
        
        RegisterViewController* viewC = [segue destinationViewController];
        
        viewC.type = REGISTER_TYPE_NORMAL;
    }
    

    
    
}

#pragma mark - Declaration

@end

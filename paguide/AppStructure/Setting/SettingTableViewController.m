//
//  SettingTableViewController.m
//  paguide
//
//  Created by Evan Beh on 29/03/2017.
//  Copyright © 2017 Evan Beh. All rights reserved.
//

#import "SettingTableViewController.h"
#import "WebViewController.h"
#import "SettingPopoutViewController.h"
#import <STPopup/STPopup.h>

#define cell_change_password @"Change Password"
#define cell_notification @"Notification"
#define cell_FAQ @"FAQ"
#define cell_Term @"Terms of Use"
#define cell_Privacy @"Privacy Policy"
#define cell_Logout @"Logout"
#define cell_Login @"Login"
#define cell_Version @"Version"


@interface SettingTableViewController ()


@property (nonatomic, strong)NSArray* arrCellList;

@property(nonatomic,strong)SettingPopoutViewController* settingPopoutViewController;
@end

@implementation SettingTableViewController


-(void)viewDidAppear:(BOOL)animated
{
    [self reloadData];

}

-(void)reloadData
{
    if ([Utils isUserLogin]) {
        
        self.arrCellList = @[
                             cell_change_password,
                             cell_notification,
                             cell_FAQ,
                             cell_Term,
                             cell_Privacy,
                             cell_Logout,
                             cell_Version,
                             ];
        
    }
    else{
        self.arrCellList = @[
                             cell_Login,
                             cell_Version,
                             ];
    }
    
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrCellList.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell_setting" forIndexPath:indexPath];
    
    cell.textLabel.text = self.arrCellList[indexPath.row];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    NSString* type = self.arrCellList[indexPath.row];

    if ([type isEqualToString:cell_Version]) {
        cell.accessoryType = UITableViewCellAccessoryNone;

        cell.textLabel.text = [NSString stringWithFormat:@"%@ : %@",type,[Utils getAppVersion]];

    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* type = self.arrCellList[indexPath.row];
    
    if ([type isEqualToString:cell_change_password]) {
        
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Change Password" message:@"" preferredStyle:UIAlertControllerStyleAlert];
        
        [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.placeholder = @"Password";
            textField.secureTextEntry = YES;
        }];
        
        [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.placeholder = @"Confirm Password";
            textField.secureTextEntry = YES;
        }];
        
        UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            
            NSString* password = [[alertController textFields][0] text];
            NSString* confirm_password = [[alertController textFields][1] text];

            NSLog(@"Password %@", [[alertController textFields][0] text]);

            NSLog(@"Confirm password %@", [[alertController textFields][1] text]);
            
            
            
            if ([Utils isStringNull:password]) {
                
                [MessageManager showMessage:@"Please Input Password" Type:TSMessageNotificationTypeError inViewController:self];
            }
            else if ([Utils isStringNull:confirm_password]) {
                [MessageManager showMessage:@"Please Input Confirm Password" Type:TSMessageNotificationTypeError inViewController:self];

            }
            
            else if (![confirm_password isEqualToString:password]) {
                [MessageManager showMessage:@"Password not same" Type:TSMessageNotificationTypeError inViewController:self];
                
            }
            else{
            
                [self requestServerToUpdatePassword:password];
            }
            //compare the current password and do action here
            
        }];
        [alertController addAction:confirmAction];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"Canelled");
        }];
        [alertController addAction:cancelAction];
        [self presentViewController:alertController animated:YES completion:nil];
        
    }
    else if ([type isEqualToString:cell_notification]) {
        
        [self showNotificationSettingView];
    }
    
    else if ([type isEqualToString:cell_FAQ]) {
    }
    else if ([type isEqualToString:cell_Term]) {
        
        [self showTermOfUseView];
    }
    else if ([type isEqualToString:cell_Privacy]) {
        
        [self showPrivacyView];

    }
    
    else if ([type isEqualToString:cell_Logout]) {
        
        
        [Utils logout];
        
        [self reloadData];
        
        //   [Utils showRegisterPage];

        
    }
    
    else if ([type isEqualToString:cell_Login]) {
        
        [Utils showRegisterPage];

    }
    
 

   
}


-(void)showTermOfUseView
{
    NSLog(@"showTermOfUseView");
    
    WebViewController* webView = [WebViewController new];
    
    webView.webViewURL = [NSString stringWithFormat:@"http://%@%@",[ConnectionManager getServerPath],@"/terms"];
    
    
    [self presentViewController:webView animated:YES completion:nil];
}

-(void)showPrivacyView
{
    NSLog(@"showPrivacyView");
    
    WebViewController* webView = [WebViewController new];
    
    webView.webViewURL = [NSString stringWithFormat:@"http://%@%@",[ConnectionManager getServerPath],@"/privacy"];
    
    [self presentViewController:webView animated:YES completion:nil];
}

-(void)showNotificationSettingView
{
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"PopOut" bundle:nil];

    SettingPopoutViewController* viewController = [storyboard instantiateViewControllerWithIdentifier:@"sb_popout_notification"];
    
    
    self.settingPopoutViewController = viewController;
    
    
    __weak typeof (self)weakSelf = self;
    
    self.settingPopoutViewController.didCancelClickedBlock = ^{
        
        [weakSelf.settingPopoutViewController.popupController dismiss];
        
    };
    
    viewController.didSubmitClickedBlock = ^{
        
        [self requestSeverToUpdateNotif:self.settingPopoutViewController.ibSwitchOne.on SMSOn:self.settingPopoutViewController.ibSwitchTwo.on Completion:^(BOOL isSuccess) {
            
            if (isSuccess) {
                [weakSelf.settingPopoutViewController.popupController dismiss];
            }
        }];
    };

    [GeneralRequestManager getProfileData:NO CompleteWithData:^(ProfileModel *pModel) {
        
        STPopupController* popVC = [[STPopupController alloc] initWithRootViewController:viewController];
        
        [viewController setupNotificationViewSMS:[pModel getSMS_on] PushNotification:[pModel getNotif_on]];
        
        [popVC presentInViewController:self];

    }];

}

-(void)requestServerToUpdatePassword:(NSString*)password
{
    
    NSString* token = [Utils getToken];
    
    NSDictionary* dict = @{@"password" : IsNullConverstion(password),
                           @"token" : token,
                           };
    
    [ConnectionManager requestServerWith:AFNETWORK_POST serverRequestType:ServerRequestTypePostUserUpdateProfile parameter:dict appendString:nil success:^(id object) {
        
        NSError* error;
        
        BaseModel* model = [[BaseModel alloc]initWithDictionary:object error:&error];
        
        [MessageManager showMessage:model.displayMessage Type:TSMessageNotificationTypeSuccess inViewController:self];
        
    } failure:^(id object) {
        
        
        NSError* error;
        
        BaseModel* model = [[BaseModel alloc]initWithDictionary:object error:&error];
        
        [MessageManager showMessage:model.displayMessage Type:TSMessageNotificationTypeError inViewController:self];
    }];
    
}


-(void)requestSeverToUpdateNotif:(BOOL)isNotifon SMSOn:(BOOL)isSMSon  Completion:(BoolBlock)completion
{
    
    NSString* pushNotif_on = isNotifon?@"Y":@"N";
    NSString* sms_on = isSMSon?@"Y":@"N";
    
    NSString* token = [Utils getToken];
    
    NSDictionary* dict = @{@"push_notif" : IsNullConverstion(pushNotif_on),
                           @"sms_notif" : IsNullConverstion(sms_on),
                           @"token" : token
                           };
    
    [ConnectionManager requestServerWith:AFNETWORK_POST serverRequestType:ServerRequestTypePostUserUpdateProfile parameter:dict appendString:nil success:^(id object) {
        
        NSError* error;
        
        BaseModel* model = [[BaseModel alloc]initWithDictionary:object error:&error];
        
        [MessageManager showMessage:model.displayMessage Type:TSMessageNotificationTypeSuccess inViewController:self];
        
        [GeneralRequestManager reloadProfileData:^(ProfileModel *pModel) {
          
            if(completion)
            {
                completion(YES);
            }
        }];
        
        
    } failure:^(id object) {
        
        NSError* error;
        
        BaseModel* model = [[BaseModel alloc]initWithDictionary:object error:&error];
        
        [MessageManager showMessage:model.displayMessage Type:TSMessageNotificationTypeError];
        
        if(completion)
        {
            completion(NO);
        }
    }];

    

}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

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
#import "UnratedViewController.h"
#import "GeneralTableViewCell.h"
#import "PackageBookmarkTableViewController.h"
#import "EBActionSheetViewController.h"
#import "ActionSheetStringPicker.h"
#import "ProfileV2TableViewCell.h"
#import "DLFPhotosPickerViewController.h"
#import "TourGuidePageViewController.h"


#import <STPopup/STPopup.h>
#import "AppointmentModel.h"


@protocol CountryModel;

#define cell_profile @"Profile"

#define cell_change_password @"Change Password"
#define cell_notification @"Notification"
#define cell_FAQ @"FAQ"
#define cell_Term @"Terms of Use"
#define cell_Privacy @"Privacy Policy"
#define cell_Logout @"Logout"
#define cell_Login @"Login"
#define cell_Version @"Version"
#define cell_Rate @"Rating"
#define cell_None @" "


@interface SettingTableViewController () <UITableViewDelegate,
                                          UITableViewDataSource,
                                          DLFPhotosPickerViewControllerDelegate>
{
   BOOL isEditMode;
    
}
@property (weak, nonatomic) IBOutlet UIView *ibBackgroundView;

@property (nonatomic, strong)NSArray* arrCellList;
@property (nonatomic, strong)NSArray<CountryModel>* arrCountryList;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic,strong)SettingPopoutViewController* settingPopoutViewController;
@property(nonatomic,strong)TourGuidePageViewController* tourGuidePageViewController;

@property(nonatomic)ProfileModel* profileModel;
@property(nonatomic,copy)ProfileModel* editProfileModel;

@end

@implementation SettingTableViewController

- (IBAction)tabProfileImage:(UITapGestureRecognizer *)sender {
    
    [self showGalleryView];
        
}

-(void)viewDidAppear:(BOOL)animated
{
    [self reloadData];
    
    
    if ([Utils isUserLogin]) {
        
        if (!self.profileModel) {
            [self requestServerForUserProfile];
        }
    }
    
}

-(void)reloadData
{
    if ([Utils isUserLogin]) {
        
        self.arrCellList = @[
                             cell_profile,
                             cell_change_password,
                             cell_notification,
                             //cell_FAQ,
                             cell_Term,
                             cell_Privacy,
                             cell_Rate,
                             cell_Logout,
                             cell_Version,
                             ];
        
    }
    else{
        self.arrCellList = @[
                             cell_None,
                             cell_Login,
                             cell_Version,
                             ];
    }
    
    [self.tableView reloadData];
    
   // [self.tableView scrollsToTop];
}

//- (UIStatusBarStyle)preferredStatusBarStyle
//{
//    return UIStatusBarStyleLightContent;
//}

- (void)viewWillAppear:(BOOL)animated {
    
    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
    
    if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
        
        statusBar.backgroundColor = [UIColor clearColor];
    }
    
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewWillDisappear:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];

    
    isEditMode = NO;
        self.tableView.estimatedRowHeight = 600.0f;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    UIEdgeInsets inset = UIEdgeInsetsMake(0, 0, 50, 0);
    self.tableView.contentInset = inset;

    [self.tableView registerNib:[UINib nibWithNibName:@"ProfileV2TableViewCell" bundle:nil] forCellReuseIdentifier:@"cell_profile2"];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"ProfileV2TableViewCellEdit" bundle:nil] forCellReuseIdentifier:@"cell_profile2_edit"];

    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.title = [@"PROFILE" uppercaseString];
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = self.view.bounds;
    
    gradient.colors = @[
                        (id)[self.class colorFromHexString:@"#780206"].CGColor,
                        (id)[self.class colorFromHexString:@"#360033"].CGColor,
                        (id)[self.class colorFromHexString:@"#061161"].CGColor,
                        // (id)[self.class colorFromHexString:@"#ec38bc"].CGColor,
                        //(id)[self.class colorFromHexString:@"#fdeff9"].CGColor
                        ];
    
    gradient.colors = @[
                        (id)[self.class colorFromHexString:@"#780206"].CGColor,
                        (id)[self.class colorFromHexString:@"#360033"].CGColor,
                        (id)[self.class colorFromHexString:@"#061161"].CGColor,
                        // (id)[self.class colorFromHexString:@"#ec38bc"].CGColor,
                        //(id)[self.class colorFromHexString:@"#fdeff9"].CGColor
                        ];

    [self.ibBackgroundView.layer insertSublayer:gradient atIndex:0];

    self.tableView.backgroundColor = [UIColor clearColor];
    
   // [self requestServerForUserProfile];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
+ (UIColor *) colorFromHexString:(NSString *)hexString {
    NSString *cleanString = [hexString stringByReplacingOccurrencesOfString:@"#" withString:@""];
    if([cleanString length] == 3) {
        cleanString = [NSString stringWithFormat:@"%@%@%@%@%@%@",
                       [cleanString substringWithRange:NSMakeRange(0, 1)],[cleanString substringWithRange:NSMakeRange(0, 1)],
                       [cleanString substringWithRange:NSMakeRange(1, 1)],[cleanString substringWithRange:NSMakeRange(1, 1)],
                       [cleanString substringWithRange:NSMakeRange(2, 1)],[cleanString substringWithRange:NSMakeRange(2, 1)]];
    }
    if([cleanString length] == 6) {
        cleanString = [cleanString stringByAppendingString:@"ff"];
    }
    
    unsigned int baseValue;
    [[NSScanner scannerWithString:cleanString] scanHexInt:&baseValue];
    
    float red = ((baseValue >> 24) & 0xFF)/255.0f;
    float green = ((baseValue >> 16) & 0xFF)/255.0f;
    float blue = ((baseValue >> 8) & 0xFF)/255.0f;
    float alpha = ((baseValue >> 0) & 0xFF)/255.0f;
    
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}
#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString* cellType = self.arrCellList[indexPath.row];
  
    if ([cellType isEqualToString:cell_profile]) {
        
        if (isEditMode) {
            
            return UITableViewAutomaticDimension;

        }
        else{
            return UITableViewAutomaticDimension;

            
        }
    }
    else
    {
        return UITableViewAutomaticDimension;

    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrCellList.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    NSString* cellType = self.arrCellList[indexPath.row];
    
    if ([cellType isEqualToString:cell_profile]) {
        ProfileV2TableViewCell* cell;

        if (isEditMode) {
         cell = [tableView dequeueReusableCellWithIdentifier:@"cell_profile2_edit" forIndexPath:indexPath];
        
            [self setupEditCell:cell IndexPath:indexPath];
           
        }
        else{
            
            cell = [tableView dequeueReusableCellWithIdentifier:@"cell_profile2" forIndexPath:indexPath];

            [self setupDisplayCell:cell IndexPath:indexPath];
        }
        cell.lblTitle.text = self.profileModel.email;
        
        return cell;
    }
    else
    {
        ProfileV2TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell_setting" forIndexPath:indexPath];
        
        cell.lblTitle.text = self.arrCellList[indexPath.row];
        cell.lblTitle.font = [UIFont boldSystemFontOfSize:12];

     //   cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        NSString* type = self.arrCellList[indexPath.row];
        
        cell.ibBorderView.hidden = NO;

        if ([type isEqualToString:cell_Version]) {
            
            cell.lblTitle.font = [UIFont systemFontOfSize:10];
            cell.lblTitle.text = [NSString stringWithFormat:@"%@ :%@%@",type,[Utils isDevBuilt]?@"Dev":@" ",[Utils getAppVersion]];
            
        }
        else if ([type isEqualToString:cell_None])
        {
            cell.ibBorderView.hidden = YES;

        }
        
        return cell;
    }
   
}



-(void)setupEditCell:(ProfileV2TableViewCell*)cell IndexPath:(NSIndexPath*)indexPath
{
    
    [Utils setRoundBorder:cell.ibBorderView3 color:APP_MAIN_COLOR borderRadius:cell.ibBorderView3.frame.size.width/2 BorderWitdh:5.0f];

    [Utils setRoundBorder:cell.ibImageView color:[UIColor clearColor] borderRadius:cell.ibImageView.frame.size.width/2];

    cell.lblTitle2.text = @"Country";
    cell.lblTitle3.text = @"Prefix";
    cell.lblTitle4.text = @"Name";
    cell.lblTitle5.text = @"Gender";
    cell.lblTitle6.text = @"Phone Number";

    [cell.ibButtonAction1 setTitle:self.editProfileModel.country forState:UIControlStateNormal];
    [cell.ibButtonAction2 setTitle:self.editProfileModel.temp_prefix forState:UIControlStateNormal];
    cell.txtField.text = self.editProfileModel.temp_mobile_number;
    cell.txtField2.text = self.editProfileModel.username;
    [cell.ibButtonAction3 setTitle:self.editProfileModel.gender forState:UIControlStateNormal];
    
    
    cell.lblTitle2.font = [UIFont boldSystemFontOfSize:12];
    cell.lblTitle3.font = [UIFont boldSystemFontOfSize:12];
    cell.lblTitle4.font = [UIFont boldSystemFontOfSize:12];
    cell.lblTitle5.font = [UIFont boldSystemFontOfSize:12];
    cell.lblTitle6.font = [UIFont boldSystemFontOfSize:12];

    cell.lblDescription2.font = [UIFont systemFontOfSize:12];
    cell.lblDescription3.font = [UIFont systemFontOfSize:12];
    cell.lblDescription4.font = [UIFont systemFontOfSize:12];
    cell.lblDescription5.font = [UIFont systemFontOfSize:12];
    
    
    [Utils setRoundBorder:cell.ibButton1 color:[UIColor clearColor] borderRadius:5.0f];
    [Utils setRoundBorder:cell.ibButton2 color:[UIColor clearColor] borderRadius:5.0f];
    
    cell.ibButton1.tintColor = [UIColor whiteColor];
    cell.ibButton1.backgroundColor =APP_MAIN_COLOR;
    
    cell.ibButton2.tintColor = [UIColor whiteColor];
    cell.ibButton2.backgroundColor =APP_MAIN_COLOR;
    
    [cell.ibButton1 setTitle:@"Apply" forState:UIControlStateNormal];
    [cell.ibButton2 setTitle:@"Cancel" forState:UIControlStateNormal];
    
    [Utils setRoundBorder:cell.ibBorderView4 color:[UIColor clearColor] borderRadius:5.0f];
    
    
    cell.ibButtonAction1.tintColor = APP_MAIN_COLOR;
     [cell.ibButtonAction1 addTarget:self action:@selector(showCountrySelectionView) forControlEvents:UIControlEventTouchUpInside];
    
    cell.ibButtonAction2.tintColor = APP_MAIN_COLOR;
    [cell.ibButtonAction2 addTarget:self action:@selector(showPrefixSelectionView) forControlEvents:UIControlEventTouchUpInside];
    
    cell.txtField.placeholder = @"Mobile Number";
    cell.txtField2.placeholder = @"Name";

    cell.ibButtonAction3.tintColor = APP_MAIN_COLOR;
    
    [cell.ibButtonAction3 addTarget:self action:@selector(showGenderSelectionView) forControlEvents:UIControlEventTouchUpInside];

    cell.didSelectInnerButton1Block = ^()
    {
        
        [self requestServerForUserUpdateProfile:^{
          
            
            self.editProfileModel = nil;
            
            [self requestServerForUserProfile];
            
            isEditMode = !isEditMode;
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }];
      
        
    };
    
    cell.didSelectInnerButton2Block = ^()
    {
        isEditMode = !isEditMode;
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    };
    
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tabProfileImage:)];
    cell.ibBorderView3.userInteractionEnabled = YES;
    [cell.ibBorderView3 addGestureRecognizer:gestureRecognizer];
    
    
    
    if (self.editProfileModel.uploadImage) {
        
        cell.ibImageView.image = self.editProfileModel.uploadImage;
    }
    else{
        [cell.ibImageView sd_setImageWithURL:[NSURL URLWithString:self.profileModel.profile_img] placeholderImage:[UIImage imageNamed:@"ic_camera_enhance"]];
    }

}

-(void)setupDisplayCell:(ProfileV2TableViewCell*)cell IndexPath:(NSIndexPath*)indexPath
{
    
    [Utils setRoundBorder:cell.ibBorderView3 color:[UIColor whiteColor] borderRadius:cell.ibBorderView3.frame.size.width/2];

    cell.lblTitle2.text = @"Country";
    cell.lblTitle3.text = @"Contact Number";
    cell.lblTitle4.text = @"Name";
    cell.lblTitle5.text = @"Gender";
    
    cell.lblDescription2.text = self.profileModel.country;
    cell.lblDescription3.text =  [NSString stringWithFormat:@"%@%@",self.profileModel.temp_prefix,self.profileModel.temp_mobile_number];
    cell.lblDescription4.text = self.profileModel.username;
    cell.lblDescription5.text = self.profileModel.gender;
    
    
    cell.lblTitle2.font = [UIFont boldSystemFontOfSize:12];
    cell.lblTitle3.font = [UIFont boldSystemFontOfSize:12];
    cell.lblTitle4.font = [UIFont boldSystemFontOfSize:12];
    cell.lblTitle5.font = [UIFont boldSystemFontOfSize:12];
    
    cell.lblDescription2.font = [UIFont systemFontOfSize:12];
    cell.lblDescription3.font = [UIFont systemFontOfSize:12];
    cell.lblDescription4.font = [UIFont systemFontOfSize:12];
    cell.lblDescription5.font = [UIFont systemFontOfSize:12];
    
    [cell.ibButton1 setTitle:@"Update Profile" forState:UIControlStateNormal];
    [cell.ibButton1 setTitleColor:APP_MAIN_COLOR forState:UIControlStateNormal];
    
    [cell.ibButton2 setImage:[UIImage imageNamed:@"icon_bookmark_red.png"] forState:UIControlStateNormal];
    
    
    cell.didSelectInnerButton1Block = ^()
    {
        
        self.editProfileModel = self.profileModel;

        self.editProfileModel.uploadImage = nil;

        isEditMode = !isEditMode;
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
    };
    
    cell.didSelectInnerButton2Block = ^()
    {
        [self.navigationController pushViewController:self.tourGuidePageViewController animated:YES];

        
    };
    
    [cell.ibImageView sd_setImageWithURL:[NSURL URLWithString:self.profileModel.profile_img] placeholderImage:[UIImage imageNamed:@"ic_camera_enhance"]];

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
        
        self.profileModel = nil;
        
        self.editProfileModel = nil;
        
        [self reloadData];
        
        //   [Utils showRegisterPage];

        
    }
    
    else if ([type isEqualToString:cell_Login]) {
        
        [Utils showRegisterPage];

    }
    else if ([type isEqualToString:cell_Rate]) {
        
        [self requestServerForUnratedmerchant];
        
    }
    
    
 

}

#pragma mark - Show View

-(void)showSelectorTitle:(NSString*)title List:(NSArray*)array SelectedIndex:(int)index Completion:(IntBlock)comBlock
{
    
    [self resignFirstResponder];
    
    [self.view endEditing:YES];
    
    [ActionSheetStringPicker showPickerWithTitle:title
                                            rows:array
                                initialSelection:index
                                       doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
                                           NSLog(@"Picker: %@, Index: %ld, value: %@",
                                                 picker, (long)selectedIndex, selectedValue);
                                           
                                           if (comBlock) {
                                               comBlock((int)selectedIndex);
                                           }
                                           
                                       }
                                     cancelBlock:^(ActionSheetStringPicker *picker) {
                                         NSLog(@"Block Picker Canceled");
                                     }
                                          origin:self];
}

-(void)showCountrySelectionView
{
    [self showCountryView:^(NSString *str) {
      
        self.editProfileModel.country = str;

        [self.tableView reloadData];
    }];
    
}

-(void)showGenderSelectionView
{
    
    NSString* title = self.editProfileModel.gender;
    int index = 0;
    
    if ([title isEqualToString:@"female"]) {
        index = 1;
    }
    
    NSArray* arrayGenders = @[@"male",@"female"] ;
    
    [self showSelectorTitle:@"Select Gender" List:arrayGenders SelectedIndex:index Completion:^(int count) {
        
        self.editProfileModel.gender = arrayGenders[count];
        
        [self.tableView reloadData];
    }];
    
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
-(void)showPrefixSelectionView{
    
    [self showPrefixView:^(NSString *str) {
       
        self.editProfileModel.temp_prefix = str;
        
        [self.tableView reloadData];
    }];
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

-(void)showTermOfUseView
{
    NSLog(@"showTermOfUseView");
    
    WebViewController* webView = [WebViewController new];
    
    webView.webViewURL = [NSString stringWithFormat:@"https://%@%@",[ConnectionManager getServerPath],@"/terms"];
    
    
    [self presentViewController:webView animated:YES completion:nil];
}

-(void)showPrivacyView
{
    NSLog(@"showPrivacyView");
    
    WebViewController* webView = [WebViewController new];
    
    webView.webViewURL = [NSString stringWithFormat:@"https://%@%@",[ConnectionManager getServerPath],@"/privacy"];
    
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
    
    [DataManager getUserProfile:^(ProfileModel *pModel) {
        
        STPopupController* popVC = [[STPopupController alloc] initWithRootViewController:viewController];
        
        [viewController setupNotificationViewSMS:[pModel getSMS_on] PushNotification:[pModel getNotif_on]];
        
        [popVC presentInViewController:self];
        
    }];
    
}


#pragma mark - Image Picker and Delegate
-(void)showGalleryView
{
    DLFPhotosPickerViewController *picker = [[DLFPhotosPickerViewController alloc] init];
    [picker setPhotosPickerDelegate:self];
    picker.multipleSelections = NO;
    [self presentViewController:picker animated:YES completion:nil];
}

- (void)photosPicker:(DLFPhotosPickerViewController *)photosPicker detailViewController:(DLFDetailViewController *)detailViewController didSelectPhoto:(PHAsset *)photo {
    
    
    NSLog(@"DONE SELECT");

    
    [photosPicker dismissViewControllerAnimated:YES completion:^{
        [[PHImageManager defaultManager] requestImageForAsset:photo targetSize:PHImageManagerMaximumSize contentMode:PHImageContentModeDefault options:nil resultHandler:^(UIImage *result, NSDictionary *info) {
            NSLog(@"Selected one asset");
            
            self.editProfileModel.uploadImage = result;
            
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            
            //self.ibProfileImgView.image = result;
            
        }];
    }];
}

- (void)photosPickerDidCancel:(DLFPhotosPickerViewController *)photosPicker
{
    [photosPicker dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - Request Server

-(void)requestServerForUserProfile
{
    
    NSString* token = [Utils getToken];
    
    NSDictionary* dict = @{@"token" : IsNullConverstion(token)};
    
    [LoadingManager show];
    
    [ConnectionManager requestServerWith:AFNETWORK_POST serverRequestType:ServerRequestTypePostUserProfile parameter:dict appendString:nil success:^(id object) {
        
        [LoadingManager hide];
        
        NSError* error;
        
        self.profileModel = [[ProfileModel alloc]initWithDictionary:object[@"data"] error:&error];
        
        
        [self.profileModel processPrefix:^{
            
            [DataManager setUserProfile:self.profileModel];
            
            [self.tableView reloadData];
            
        }];
        
        
//        [self.ibProfileImgView sd_setImageWithURL:[NSURL URLWithString:self.profileModel.profile_img]placeholderImage:[UIImage imageNamed:@"placeholder_profile.png"]];
        
    } failure:^(id object) {
        
        
        [LoadingManager hide];
        
        NSError* error;
        
        
        BaseModel* model = [[BaseModel alloc]initWithDictionary:object error:&error];
        
        [MessageManager showMessage:model.displayMessage Type:TSMessageNotificationTypeError];
    }];
}


-(void)getData
{
    GeneralTableViewCell* cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    self.editProfileModel.temp_mobile_number = cell.txtField.text;
    
    self.editProfileModel.username = cell.txtField2.text;
}

-(void)requestServerForUserUpdateProfile:(VoidBlock)completed
{
    [self getData];
    
    NSString* token = [Utils getToken];
    
    
    NSString* new_contact_number = [NSString stringWithFormat:@"%@%@",self.editProfileModel.temp_prefix,self.editProfileModel.temp_mobile_number];
    
    NSDictionary* dict = @{@"username" : IsNullConverstion(self.editProfileModel.username),
                           @"country" : IsNullConverstion(self.editProfileModel.country),
                           @"gender" : IsNullConverstion(self.editProfileModel.gender),
                           @"mobile_number" : IsNullConverstion(new_contact_number),
                           //                           @"profile_img" : @"",
                           @"token" : token
                           };
    
    if (self.editProfileModel.uploadImage) {
        
        NSData *imageData= UIImageJPEGRepresentation(self.editProfileModel.uploadImage, 0.5);
        
        [LoadingManager show];
        
        [ConnectionManager requestServerWith:AFNETWORK_POST serverRequestType:ServerRequestTypePostUserUpdateProfile parameter:dict ConstructBodyBlock:^(id<AFMultipartFormData> formData) {
            
            
            [formData appendPartWithFileData:imageData
                                        name:@"profile_img"
                                    fileName:@"avatar" mimeType:@"image/jpeg"];
            
        } appendString:nil success:^(id object) {
            
            [LoadingManager hide];
            
            NSError* error;
            
            BaseModel* model = [[BaseModel alloc]initWithDictionary:object error:&error];
            
            [MessageManager showMessage:model.displayMessage Type:TSMessageNotificationTypeSuccess];
            
            if (completed) {
                completed();
            }
            
            [self.tableView reloadData];
            
            
            
        } failure:^(id object) {
            
            [LoadingManager hide];
            NSError* error;
            
            
            BaseModel* model = [[BaseModel alloc]initWithDictionary:object error:&error];
            
            [MessageManager showMessage:model.displayMessage Type:TSMessageNotificationTypeError];
            
            
            
        }];
    }
    
    
    else{
        [LoadingManager show];
        
        [ConnectionManager requestServerWith:AFNETWORK_POST serverRequestType:ServerRequestTypePostUserUpdateProfile parameter:dict appendString:nil success:^(id object) {
            
            [LoadingManager hide];
            
            NSError* error;
            
            BaseModel* model = [[BaseModel alloc]initWithDictionary:object error:&error];
            
            [MessageManager showMessage:model.displayMessage Type:TSMessageNotificationTypeSuccess];
            
            if (completed) {
                completed();
            }
            [self.tableView reloadData];
            
            
            
            
        } failure:^(id object) {
            [LoadingManager hide];
            NSError* error;
            
            
            BaseModel* model = [[BaseModel alloc]initWithDictionary:object error:&error];
            
            [MessageManager showMessage:model.displayMessage Type:TSMessageNotificationTypeError];
            
        }];
        
    }
    
    
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
        
        [DataManager reloadUserProfile:^(ProfileModel *pModel) {
            
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


-(void)requestServerForUnratedmerchant
{
    
    NSString* token = [Utils getToken];
    
    NSDictionary* dict = @{@"token" : token};
    
    [LoadingManager show];
    
    [ConnectionManager requestServerWith:AFNETWORK_POST serverRequestType:ServerRequestTypePostAppointmentCheckComplete parameter:dict appendString:nil success:^(id object) {
        
        [LoadingManager hide];

        NSMutableArray* array = [AppointmentModel arrayOfModelsFromDictionaries:object[@"data"] error:nil];
        
        if ([Utils isArrayNull:array]) {
            
            [MessageManager showMessage:@"No Merchant to be rated" Type:TSMessageNotificationTypeSuccess inViewController:self];
        }
        else{
        
            [self showRatingView:array];

        }
        
    } failure:^(id object) {
        
        [LoadingManager hide];

    }];
}

#pragma mark - Declaration
-(TourGuidePageViewController*)tourGuidePageViewController
{
    if (!_tourGuidePageViewController) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        _tourGuidePageViewController = [storyboard instantiateViewControllerWithIdentifier:@"sb_bookmark_main"];
        
      //  _tourGuidePageViewController.view.tag = 0;
        
    }
    
    return _tourGuidePageViewController;
}

#pragma mark - show view

-(void)showRatingView:(NSArray*)array
{
    UnratedViewController* ratingViewController = [[UnratedViewController alloc]initWithNibName:@"UnratedViewControllerV2" bundle:nil];
    
    ratingViewController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    ratingViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    
    ratingViewController.arrayAppointments = [array mutableCopy];
    
    [self presentViewController:ratingViewController animated:YES completion:^{
        
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

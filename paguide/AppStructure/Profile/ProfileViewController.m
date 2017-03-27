//
//  ProfileViewController.m
//  paguide
//
//  Created by Evan Beh on 01/03/2017.
//  Copyright © 2017 Evan Beh. All rights reserved.
//

#import "ProfileViewController.h"
#import "ProfileTableViewCell.h"
#import "RegisterTableViewCell.h"
#import "EBActionSheetViewController.h"
#import "ProfileModel.h"
#import "ActionSheetStringPicker.h"
#import "DLFPhotosPickerViewController.h"

#define cell_name @"Name"
#define cell_country @"Country"
#define cell_contact @"Contact Number"
#define cell_gender @"Gender"

@protocol CountryModel;


@interface ProfileViewController () <UITableViewDelegate, UITableViewDataSource,DLFPhotosPickerViewControllerDelegate>
{
    int segmentedControlIndex;
    
    BOOL isEditable;
    
}
@property (weak, nonatomic) IBOutlet UIBarButtonItem *btnEdit;
@property (weak, nonatomic) IBOutlet UITableView *ibTableView;
@property (weak, nonatomic) IBOutlet UIImageView *ibProfileImgView;

@property(nonatomic)NSArray* arrCellList;
@property(nonatomic)ProfileModel* profileModel;
@property(nonatomic)ProfileModel* editProfileModel;
@property (nonatomic, strong)NSArray<CountryModel>* arrCountryList;
@property (weak, nonatomic) IBOutlet UILabel *lblEmail;

@end

@implementation ProfileViewController

- (IBAction)tabProfileImage:(UITapGestureRecognizer *)sender {
    
    [self showGalleryView];
}
- (IBAction)btnBackClicked:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btnEditClicked:(id)sender {
    
    if (isEditable) {
        
        
        NSLog(@"edit profile : %@",self.editProfileModel);
        
        [self.btnEdit setTitle:@"Submit"];
        
        [self requestServerForUserUpdateProfile];
    }
    else{
        
        _editProfileModel = nil;
        
        _editProfileModel = self.profileModel;
        
        [self.btnEdit setTitle:@"Edit"];

    }
    isEditable = !isEditable;
    
    [self.ibTableView reloadData];

}


-(void)validateProfile
{
    
    NSString* errorMessage;
    
    if ([Utils isStringNull:self.editProfileModel.country] || [self.editProfileModel.country isEqualToString:@"Country"]) {
        
        
        errorMessage = @"Plese select Country";
    }
    
    else if ([Utils isStringNull:self.editProfileModel.temp_prefix] || [self.editProfileModel.temp_prefix isEqualToString:@"Prefix"]) {
        
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    isEditable = NO;
    
    
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    //[self.ibTableView setContentInset:UIEdgeInsetsMake(150,0,0,0)];

    [self.ibProfileImgView sd_setImageWithURL:[NSURL URLWithString:@"https://s-media-cache-ak0.pinimg.com/736x/8b/b1/60/8bb160c9f3b45906ef8ffab6ac972870.jpg"]];
    [Utils setRoundBorder:self.ibProfileImgView color:[UIColor clearColor] borderRadius:self.ibProfileImgView.frame.size.height/2];
    
    
    self.arrCellList = @[cell_country,cell_contact,cell_name,cell_gender];
    
    
    
    [self requestServerForUserProfile];
    
    // Do any additional setup after loading the view.
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrCellList.count;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* type = self.arrCellList[indexPath.row];

    if (isEditable) {
        
        if ([type isEqualToString:cell_name]) {
            
            ProfileTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"profile_cell_edit1"];

            cell.txtDefault.placeholder = type;
            
            cell.txtDefault.text = self.profileModel.username;

            
            cell.didUpdateStringBlock = ^(NSString* str)
            {
                self.editProfileModel.username = str;
                
            };
            
            return cell;
            
        }else if ([type isEqualToString:cell_country]) {
            
            ProfileTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"profile_cell_edit3"];
            
            
            cell.didSelectBlock = ^(void)
            {
                [self showCountryView:^(NSString *str) {
                    
                    
                    self.editProfileModel.country = str;
                    
                    [self.ibTableView reloadData];

                }];
                
            };

            
            if ([Utils isStringNull:self.profileModel.country]) {
                [cell.btnOne setTitle:type forState:UIControlStateNormal];

            }
            else{
                [cell.btnOne setTitle:self.profileModel.country forState:UIControlStateNormal];

            }
            
            return cell;
        }
        else if ([type isEqualToString:cell_contact]) {
            ProfileTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"profile_cell_edit2"];
            
            cell.txtDefault.placeholder = type;
            
            [cell.btnOne setTitle:self.profileModel.temp_prefix forState:UIControlStateNormal];

            
            cell.didSelectBlock = ^(void)
            {
                [self showPrefixView:^(NSString *str) {
                    
                    
                    self.editProfileModel.temp_prefix = str;
                    
                    [self.ibTableView reloadData];
                }];
                
            };
            
            cell.didUpdateStringBlock = ^(NSString* str)
            {
                self.editProfileModel.temp_mobile_number = str;

                [self.ibTableView reloadData];

            };

            cell.txtDefault.text = self.profileModel.temp_mobile_number;

            
            return cell;
        }else if ([type isEqualToString:cell_gender]) {
            
            ProfileTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"profile_cell_edit3"];
            
            __weak typeof (cell)weakCell = cell;
            cell.didSelectBlock = ^(void)
            {
                
                int index = 0;
                
                if ([weakCell.btnOne.titleLabel.text isEqualToString:@"female"]) {
                    index = 1;
                }
                
                
                NSArray* arrayGenders = @[@"male",@"female"] ;
                
                [self showSelector:weakCell.btnOne Title:@"Select Gender" List:arrayGenders SelectedIndex:index Completion:^(int count) {
                    
                    self.editProfileModel.gender = arrayGenders[count];
                }];
            };
            
            
            if ([Utils isStringNull:self.profileModel.gender]) {
                [cell.btnOne setTitle:type forState:UIControlStateNormal];
                
            }
            else{
                [cell.btnOne setTitle:self.profileModel.gender forState:UIControlStateNormal];
                
            }
            
            return cell;
        }

        
        
        

    }
    else{
    
        ProfileTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"profile_cell"];
        
        NSString* title = self.arrCellList[indexPath.row];
        
        cell.lblTitle.text = title;

        if ([title isEqualToString:cell_name]) {
            
            cell.lblDesc.text = self.profileModel.username;

        }else if ([type isEqualToString:cell_country]) {
            
            cell.lblDesc.text = self.profileModel.country;

        }
        else if ([type isEqualToString:cell_contact]) {
            
            cell.lblDesc.text = [NSString stringWithFormat:@"%@%@",self.profileModel.temp_prefix,self.profileModel.temp_mobile_number];

        }
        else if ([type isEqualToString:cell_gender]) {
            
            cell.lblDesc.text = self.profileModel.gender;
            
        }
        
        
        return cell;

    }
    
    return nil;
}

#pragma mark - Show View

-(void)showGalleryView
{
    DLFPhotosPickerViewController *picker = [[DLFPhotosPickerViewController alloc] init];
    [picker setPhotosPickerDelegate:self];
    picker.multipleSelections = NO;
    [self presentViewController:picker animated:YES completion:nil];
}

- (void)photosPicker:(DLFPhotosPickerViewController *)photosPicker detailViewController:(DLFDetailViewController *)detailViewController didSelectPhoto:(PHAsset *)photo {
    [photosPicker dismissViewControllerAnimated:YES completion:^{
        [[PHImageManager defaultManager] requestImageForAsset:photo targetSize:PHImageManagerMaximumSize contentMode:PHImageContentModeDefault options:nil resultHandler:^(UIImage *result, NSDictionary *info) {
            NSLog(@"Selected one asset");
            
            
            self.editProfileModel.uploadImage = result;
            
            self.ibProfileImgView.image = result;
            
        }];
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
        
        [self presentViewController:viewC animated:YES completion:nil];
        
        __weak typeof (viewC)weakVC = viewC;
        
        viewC.didSelectAtIndexBlock = ^(NSIndexPath* indexPath)
        {
            [weakVC dismissViewControllerAnimated:YES completion:^{
                
                CountryModel* model = self.arrCountryList[indexPath.row];
                
                NSString* country = model.c_name;
                
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

-(void)showPrefixView:(StringBlock)completion
{
    
    VoidBlock openPopOutView = ^(void)
    {
        EBActionSheetViewController* viewC = [[EBActionSheetViewController alloc]initWithNibName:@"EBActionSheetViewController" bundle:nil];
        viewC.title = @"Prefix";
        
        
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


-(void)showSelector:(UIButton*)sender Title:(NSString*)title List:(NSArray*)array SelectedIndex:(int)index Completion:(IntBlock)comBlock
{
    
    [self resignFirstResponder];
    
    [self.view endEditing:YES];
    
    [ActionSheetStringPicker showPickerWithTitle:title
                                            rows:array
                                initialSelection:index
                                       doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
                                           NSLog(@"Picker: %@, Index: %ld, value: %@",
                                                 picker, (long)selectedIndex, selectedValue);
                                           
                                           [sender setTitle:selectedValue forState:UIControlStateNormal];
                                           
                                           if (comBlock) {
                                               comBlock((int)selectedIndex);
                                           }
                                           
                                       }
                                     cancelBlock:^(ActionSheetStringPicker *picker) {
                                         NSLog(@"Block Picker Canceled");
                                     }
                                          origin:sender];
}


#pragma mark - Request Server

-(void)requestServerForUserProfile
{
    
    NSString* token = [Utils getToken];

    NSDictionary* dict = @{@"token" : IsNullConverstion(token)};
    
    [ConnectionManager requestServerWith:AFNETWORK_POST serverRequestType:ServerRequestTypePostUserProfile parameter:dict appendString:nil success:^(id object) {
        
        NSError* error;
        
        self.profileModel = [[ProfileModel alloc]initWithDictionary:object[@"data"] error:&error];
        
        [self.profileModel processPrefix:^{
            
            [self.ibTableView reloadData];

        }];
        
        self.lblEmail.text = self.profileModel.email;

        
    } failure:^(id object) {
        
        NSError* error;
        
        
        BaseModel* model = [[BaseModel alloc]initWithDictionary:object error:&error];
        
        [MessageManager showMessage:model.displayMessage Type:TSMessageNotificationTypeError];
    }];
}

-(void)requestServerForUserUpdateProfile
{
    
    
    NSString* token = [Utils getToken];

    NSDictionary* dict = @{@"username" : IsNullConverstion(self.editProfileModel.username),
                           @"country" : IsNullConverstion(self.editProfileModel.country),
                           @"gender" : IsNullConverstion(self.editProfileModel.gender),
                           @"mobile_number" : IsNullConverstion(self.editProfileModel.mobile_number),
//                           @"profile_img" : @"",
                           
                           @"token" : token
                           };
    
    
    [LoadingManager show];
    [ConnectionManager requestServerWith:AFNETWORK_POST serverRequestType:ServerRequestTypePostUserUpdateProfile parameter:dict appendString:nil success:^(id object) {
        
        [LoadingManager hide];

        NSError* error;
        
        BaseModel* model = [[BaseModel alloc]initWithDictionary:object error:&error];
        
        [MessageManager showMessage:model.displayMessage Type:TSMessageNotificationTypeSuccess];
        
        [self.ibTableView reloadData];
        
        
    } failure:^(id object) {
        [LoadingManager hide];
        NSError* error;

        
        BaseModel* model = [[BaseModel alloc]initWithDictionary:object error:&error];
        
        [MessageManager showMessage:model.displayMessage Type:TSMessageNotificationTypeError];

    }];
}

#pragma mark - Navigation

//// In a storyboard-based application, you will often want to do a little preparation before navigation
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    // Get the new view controller using [segue destinationViewController].
//    // Pass the selected object to the new view controller.
//    
//    if ([[segue identifier] isEqualToString:@"appointment_details"]) {
//        
//        // Get destination view
//        AppointmentViewController *vc = [segue destinationViewController];
//        
//        
//    }
//
//}


@end

//
//  AppointmentViewController.m
//  paguide
//
//  Created by Evan Beh on 02/03/2017.
//  Copyright © 2017 Evan Beh. All rights reserved.
//

#import "AppointmentViewController.h"
#import "ApptHeaderTableViewCell.h"
#import "GeneralTableViewCell.h"
#import "HeaderView.h"
#import "AppointmentModel.h"
#import "AppointmentWrapperModel.h"
#import "PackageDetailsTableViewCell.h"
#import "RatingViewController.h"
#import "MerchantProfileViewController.h"
#import "NSString+Extra.h"



#define cell_title @"cell_title"
#define cell_detail1 @"cell_detail1"
#define cell_map @"cell_map"
#define cell_details_more @"appt_detail_more"


@interface AppointmentViewController () <UITableViewDelegate, UITableViewDataSource>
{
    __weak IBOutlet NSLayoutConstraint *constHeight_verify;
    NSArray* arrCellTypeList;
    __weak IBOutlet NSLayoutConstraint *constHeight_complete;
    
    MerchantProfileModel* merchantProfileModel;

}
@property (weak, nonatomic) IBOutlet UITableView *ibTableView;
@property (strong, nonatomic)AppointmentModel* appointmentModel;
@property (nonatomic,strong)RatingViewController* ratingViewController;
@property (weak, nonatomic) IBOutlet UITextField *txtVerifyCode;
@property (weak, nonatomic) IBOutlet UIButton *btnComplete;
@property (weak, nonatomic) IBOutlet UIButton *btnVerify;

@end

@implementation AppointmentViewController
- (IBAction)btnCompleteClicked:(id)sender {
    
    [self.view endEditing:YES];

    [self showRatingView:^(int rate, NSString *reviews) {
        
        [self requestServerForAppointmentRating:rate Review:reviews AppointmentID:self.appointmentModel.appointment_id Completion:^{
            
            [self.ratingViewController dismissViewControllerAnimated:YES completion:^{
                
                
                [self resetMainPage];
                
                [self.navigationController popToRootViewControllerAnimated:YES];

                
                //[self showQuitView];
                
            }];
                        
        }];
    }];
}

-(void)setupData:(AppointmentModel*)model
{
    self.appointmentModel = model;
}

- (IBAction)btnVerifyClicked:(id)sender {
    
    [self.view endEditing:YES];
    
    if ([Utils isStringNull:self.txtVerifyCode.text]) {
        
        [MessageManager showMessage:@"Please Input a verification code" Type:TSMessageNotificationTypeError];
        
        return;
    }
    [self requestServerForAppointmentValidateCode:self.txtVerifyCode.text AppointmentID:self.appointmentModel.appointment_id];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;

    self.ibTableView.rowHeight = UITableViewAutomaticDimension;
    
    self.ibTableView.estimatedRowHeight = 120.0f;
    
    arrCellTypeList = @[cell_title,cell_detail1,cell_details_more,cell_map];
    
    // Do any additional setup after loading the view.
    
    
    [Utils setRoundBorder:self.btnVerify color:[UIColor clearColor] borderRadius:5.0f];
    
    [Utils setRoundBorder:self.btnComplete color:[UIColor clearColor] borderRadius:5.0f];

    
    [self initData];
    
}

-(void)initData
{
    if (self.viewType == APPOITNMENT_VIEW_TYPE_VERIFY) {
        
        constHeight_verify.constant = 70;
        constHeight_complete.constant = 0;
        
    }
    else if (self.viewType == APPOITNMENT_VIEW_TYPE_COMPLETE){
        constHeight_verify.constant = 0;
        constHeight_complete.constant = 70;
    }
    
    else{
        constHeight_verify.constant = 0;
        constHeight_complete.constant = 0;
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return arrCellTypeList.count;
}


//- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    
//    NSString* type = arrCellTypeList[section];
//    
//    
//    
//    if ([type isEqualToString:cell_details_more]) {
//        
//        UIView* view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"header_cell"];
//        
//        if (!view) {
//            
//            view = [HeaderView initializeCustomView];
//            
//        }
//        
//        HeaderView* headerView = (HeaderView*)view;
//        
//        headerView.lblTitle2.hidden = YES;
//        
//        headerView.lblTitle1.text = @"6 in 1 Bundle";
//        
//        
//        
//        return headerView;
//    }
//  
//    return nil;
//}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    NSString* type = arrCellTypeList[section];
//    
//    if ([type isEqualToString:cell_details_more]) {
//        
//        
//        return 50.0f;
//    }
//    
//    return 0.0f;
//}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    NSString* type = arrCellTypeList[section];
    
    if ([type isEqualToString:@"cell_title"]) {
        
        
        if (self.appointmentModel.package_info_model.merchant_group_active) {
            
            return 0;
        }

        else{
            return 1;

        }
    
    }
    else  if ([type isEqualToString:@"cell_detail1"]) {
        
        return 1;
    
    }
    
    else  if ([type isEqualToString:cell_details_more]) {
        
        return 1;
        
    }
    else  if ([type isEqualToString:@"cell_map"]) {
        
        return 1;
    }
    
    return 0;

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* type = arrCellTypeList[indexPath.section];
    
    if ([type isEqualToString:@"cell_title"]) {
        
        return 120.0f;
    }
    else  if ([type isEqualToString:@"cell_detail1"]) {
        
        return UITableViewAutomaticDimension;
    }
    else  if ([type isEqualToString:@"cell_map"]) {
        
        return 150.0f;
    }
    else  if ([type isEqualToString:cell_details_more]) {
        
        return UITableViewAutomaticDimension;
    }

    
    return 0;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString* type = arrCellTypeList[indexPath.section];
    
    if ([type isEqualToString:@"cell_title"]) {
        ApptHeaderTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"appt_title"];
        
        cell.lblTitle.text = [NSString validateText:self.appointmentModel.merchant_info_model.name];
        cell.lblTitle2.text = [NSString validateText:self.appointmentModel.merchant_info_model.mobile_number];
        cell.lblTitle3.text = [NSString validateText:self.appointmentModel.merchant_info_model.email];
        [cell.ratingView setupRatingOutOfFive:round([self.appointmentModel.merchant_info_model.overall_rating doubleValue])];

        return cell;
        
    }
    else  if ([type isEqualToString:@"cell_detail1"]) {
        ApptHeaderTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"appt_detail1"];
        
        cell.lblTitle.text = [NSString stringWithFormat:@"%@ %@",self.appointmentModel.currency,self.appointmentModel.price];
        cell.lblTitle2.text = [NSString stringWithFormat:@"%@ %@",@"Purchase Date :",self.appointmentModel.transaction_date];
        
        cell.lblTitle3.text = [NSString validateText:self.appointmentModel.package_info_model.name];

        cell.lblTitle4.text = [NSString validateText:self.appointmentModel.appointment_code];

        cell.lblTitle5.text = [NSString stringWithFormat:@"Appointment Date : %@",self.appointmentModel.package_info_model.package_date];

        cell.lblTitle6.text = [NSString stringWithFormat:@"Pax : %@ pax",self.appointmentModel.package_info_model.pax];
        
        return cell;
    }
    
    else  if ([type isEqualToString:cell_details_more]) {
        GeneralTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"appt_detail_more"];
        
        cell.lblTitle.text = @"Description";
        
        
        
        UIFont *font = [UIFont fontWithName:@"Arial" size:12.0f];
        cell.lblDescription.attributedText = [[NSAttributedString alloc] initWithData:[self.appointmentModel.package_info_model.desc dataUsingEncoding:NSUTF8StringEncoding]
                                         options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
                                                   
                                                   NSCharacterEncodingDocumentAttribute: @(NSUTF8StringEncoding),
                                                   NSFontAttributeName : font
                                                   }
                              documentAttributes:nil error:nil];

        return cell;
    }
    else  if ([type isEqualToString:@"cell_map"]) {
        PackageDetailsTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"appt_map"];
        
        NSArray* coordinate = [self.appointmentModel.package_info_model.latlng componentsSeparatedByString:@","];
        
        float latitude = [coordinate[0] floatValue];
        
        float longtitude = [coordinate[1] floatValue];
        
        CLLocation *location = [[CLLocation alloc]initWithLatitude:latitude longitude:longtitude];
        
        [cell setLocation:location];

        
        return cell;
    }
    
    return nil;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString* type = arrCellTypeList[indexPath.section];
    
    if ([type isEqualToString:@"cell_title"]) {
        
        
        [self showMerchantView];

    }
}

-(void)showRatingView:(RateAndReviewBlock)rateNreview
{
    self.ratingViewController = [RatingViewController new];
    self.ratingViewController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    self.ratingViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    
    [self.tabBarController presentViewController:self.ratingViewController animated:YES completion:nil];
    
    __weak typeof (self.ratingViewController)weakRatingVC = self.ratingViewController;
    self.ratingViewController.didFinishRateBlock = ^(void)
    {
 
        if ([Utils isStringNull:weakRatingVC.txtRating.text]) {
            [MessageManager showMessage:@"Please Input A Review" Type:TSMessageNotificationTypeError inViewController:weakRatingVC];
        }
        else{
            
            if (rateNreview) {
                rateNreview(weakRatingVC.rating, weakRatingVC.txtRating.text);
            }
        }
        
        
        NSLog(@"txt:%@",weakRatingVC.txtRating.text);
        
        NSLog(@"rating:%i",weakRatingVC.rating);
        
    };
}

-(void)requestServerForAppointmentRating:(int)rating Review:(NSString*)review AppointmentID:(NSString*)apptID
                             Completion :(VoidBlock)completion
{
    [self resignFirstResponder];

    NSString* token = [Utils getToken];
    
    NSDictionary* dict = @{@"token" : IsNullConverstion(token),
                           @"appointment_id" : IsNullConverstion(apptID),
                           @"type" : self.appointmentModel.type,
                           @"rate" : @(rating),
                           @"reviews" : IsNullConverstion(review),
                           };
    
    [ConnectionManager requestServerWith:AFNETWORK_POST serverRequestType:ServerRequestTypePostAppointmentComplete parameter:dict appendString:nil success:^(id object) {
        
        NSError* error;
        
        BaseModel* model = [[BaseModel alloc]initWithDictionary:object error:&error];
        
        [MessageManager showMessage:model.generalMessage Type:TSMessageNotificationTypeSuccess];
        
        if (completion) {
            completion();
        }
    } failure:^(id object) {
        
        NSError* error;
        
        BaseModel* model = [[BaseModel alloc]initWithDictionary:object error:&error];
        
        [MessageManager showMessage:model.generalMessage Type:TSMessageNotificationTypeError];
        

    }];
}


-(void)requestServerForAppointmentValidateCode:(NSString*) verifyCode AppointmentID:(NSString*)apptID
{
    
    [self resignFirstResponder];
    
    NSString* token  = [Utils getToken];
    NSDictionary* dict = @{@"token" : token,
                           @"appointment_id" : apptID,
                           @"verification_code" : verifyCode,
                           @"type" : @"package"
                           };
    
    [ConnectionManager requestServerWith:AFNETWORK_POST serverRequestType:ServerRequestTypePostAppointmentValidatecode parameter:dict appendString:nil success:^(id object) {
        
        NSError* error;
        
        BaseModel* model = [[BaseModel alloc]initWithDictionary:object error:&error];
        
        [MessageManager showMessage:model.generalMessage Type:TSMessageNotificationTypeSuccess];
        
        [self showAppointmentComleteview];
        
        [self resetMainPage];

        
    } failure:^(id object) {
       
        NSError* error;
        
        BaseModel* model = [[BaseModel alloc]initWithDictionary:object error:&error];
        
        [MessageManager showMessage:model.generalMessage Type:TSMessageNotificationTypeError];
    }];
}

-(void)showAppointmentComleteview
{
    
    
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    AppointmentViewController *appointmentViewController = [storyboard instantiateViewControllerWithIdentifier:@"sb_appointment_detail"];
    
    [appointmentViewController setupData:self.appointmentModel];
    
    appointmentViewController.viewType = APPOITNMENT_VIEW_TYPE_COMPLETE;
    
    [self.navigationController pushViewController:appointmentViewController animated:YES];

}

-(void)showMerchantView
{
    [LoadingManager show];

    [MerchantProfileViewController requestServerForMerchantID:self.appointmentModel.merchant_info_model.merchant_id Completion:^(NSDictionary *dict) {
        
        [LoadingManager hide];
        
        MerchantProfileModel* model = [[MerchantProfileModel alloc]initWithDictionary:dict[@"data"] error:nil];
        
        merchantProfileModel = model;
        
        [self performSegueWithIdentifier:@"merchant_profile" sender:self];
        
        
    } Fail:^(NSDictionary *dict) {
        
        [LoadingManager hide];
        
        [MessageManager showMessage:@"Load Merchant data Fail" Type:TSMessageNotificationTypeError];
        
    }];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([[segue identifier] isEqualToString:@"merchant_profile"]) {
        
        
        MerchantProfileViewController* mViewController = [segue destinationViewController];
        
        [mViewController setUpMerchantProfileWithRequestGuide:merchantProfileModel];

        
    }
        

}


@end

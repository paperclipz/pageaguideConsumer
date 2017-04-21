//
//  AppointmentRequestViewController.m
//  paguide
//
//  Created by Evan Beh on 23/03/2017.
//  Copyright © 2017 Evan Beh. All rights reserved.
//

#import "AppointmentRequestViewController.h"
#import "GeneralTableViewCell.h"
#import "ApptHeaderTableViewCell.h"
#import "HeaderView.h"
#import "RatingViewController.h"
#import "AppointmentViewController.h"
#import "FormDataModel.h"
#import "MerchantProfileViewController.h"

#define cell_title @"cell_title"
#define cell_merchant_offer @"cell_merchant_offer"
#define cell_request_guide @"MY Request Guide"


@interface AppointmentRequestViewController () <UITableViewDelegate, UITableViewDataSource>
{
    NSArray* arrCellList;

    __weak IBOutlet NSLayoutConstraint *constHeight_verify;

    __weak IBOutlet NSLayoutConstraint *constHeight_complete;
    
    
}
@property (strong, nonatomic) MerchantProfileModel* selectedMerchantProfileModel;

@property (weak, nonatomic) IBOutlet UIButton *btnComplete;
@property (weak, nonatomic) IBOutlet UIButton *btnVerify;
@property (weak, nonatomic) IBOutlet UITextField *txtVerify;
@property (nonatomic,strong)RatingViewController* ratingViewController;

@property (strong, nonatomic)AppointmentModel* appointmentModel;

@property (weak, nonatomic) IBOutlet UITableView *ibTableView;

@property (nonatomic,strong)NSMutableArray* arrAppointmentList;
@end

@implementation AppointmentRequestViewController
- (IBAction)btnVerifyClicked:(id)sender {
    
    

    if ([Utils isStringNull:self.txtVerify.text]) {
        
        [MessageManager showMessage:@"Please Input a verification code" Type:TSMessageNotificationTypeError];
        
        return;
    }
    [self requestServerForAppointmentValidateCode:self.txtVerify.text AppointmentID:self.appointmentModel.appointment_id];

}

- (IBAction)btnCompleteClicked:(id)sender {
    
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


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;

    self.ibTableView.delegate = self;
    self.ibTableView.dataSource  = self;
    
    
    self.ibTableView.rowHeight = UITableViewAutomaticDimension;
    
    self.ibTableView.estimatedRowHeight  =120.0f;
    
    self.title = @"Request Guide";
    
    arrCellList = @[cell_title,cell_merchant_offer,cell_request_guide];
    
    [Utils setRoundBorder:self.btnVerify color:[UIColor clearColor] borderRadius:5.0f];
    
    [Utils setRoundBorder:self.btnComplete color:[UIColor clearColor] borderRadius:5.0f];
    
    
    
    [self initData];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
    
}


- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{

    NSString* type = arrCellList[section];



    if ([type isEqualToString:cell_merchant_offer]) {

        UIView* view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"header_cell"];

        if (!view) {

            view = [HeaderView initializeCustomView];

        }

        HeaderView* headerView = (HeaderView*)view;

        headerView.lblTitle2.hidden = YES;

        headerView.lblTitle1.text = @"Merchant Offer";



        return headerView;
    }else if ([type isEqualToString:cell_request_guide]) {
        
        UIView* view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"header_cell"];
        
        if (!view) {
            
            view = [HeaderView initializeCustomView];
            
        }
        
        HeaderView* headerView = (HeaderView*)view;
        
        headerView.lblTitle2.hidden = YES;
        
        headerView.lblTitle1.text = @"My Request Guide";
        
        
        return headerView;
    }


    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{

    NSString* type = arrCellList[section];
    
    
    
    if ([type isEqualToString:cell_merchant_offer]||
        [type isEqualToString:cell_request_guide]) {
    
        return 30.0f;
    }
    
    return 0.0f;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return arrCellList.count;
    
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString* type = arrCellList[section];

    if ([type isEqualToString:cell_title]) {
        
        return 1;
    }
    else if ([type isEqualToString:cell_merchant_offer]) {
        return self.appointmentModel.arr_Merchant_info.count;
    
    }
   
    else if ([type isEqualToString:cell_request_guide]) {
        return self.appointmentModel.request_info.arrRequest_field.count;

    }
    return 0;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    NSString* type = arrCellList[indexPath.section];
    
    if ([type isEqualToString:cell_title]) {
        ApptHeaderTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"appt_request_title"];
        
        NSString* title = [self.appointmentModel.request_info.specialty componentsJoinedByString:@","];
        
        cell.lblTitle.text = title;
        
        cell.lblTitle2.text = self.appointmentModel.appointment_code;

        cell.lblTitle3.text = [NSString stringWithFormat:@"Completed At : %@",self.appointmentModel.request_info.updated_at];

        cell.lblTitle4.text = self.appointmentModel.merchant_info_model.country;
        
        return cell;
    }
    
    else if ([type isEqualToString:cell_merchant_offer]) {
      
    
        
        MerchantProfileModel* model  = self.appointmentModel.arr_Merchant_info[indexPath.row];
        
  
        if (model.isExpand) {
            
            GeneralTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"appt_request_offer_expand"];
            
            cell.lblTitle.text = [NSString stringWithFormat:@"%@ %@",model.offer_currency,model.offer_price];
            
            cell.lblDescription.text = model.name;
            
            cell.lblTitle2.text = @"Bid Detail";
            
            
            cell.lblDescription2.attributedText = [[NSAttributedString alloc] initWithData:[model.offer_details dataUsingEncoding:NSUTF8StringEncoding]
                                                                                   options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
                                                                                             NSCharacterEncodingDocumentAttribute: @(NSUTF8StringEncoding)}
                                                                        documentAttributes:nil error:nil];
            
            
            cell.didSelectInnerButton1Block = ^{
            
                self.selectedMerchantProfileModel = self.appointmentModel.arr_Merchant_info[indexPath.row];

                [self performSegueWithIdentifier:@"merchant_profile" sender:self];
            };
            return cell;
        }
        else{
            
            GeneralTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"appt_request_offer"];
            
            
            cell.lblTitle.text = [NSString stringWithFormat:@"%@ %@",model.offer_currency,model.offer_price];
            
            cell.lblDescription.text = model.name;
            
            cell.didSelectInnerButton1Block = ^{
                
                
                self.selectedMerchantProfileModel = self.appointmentModel.arr_Merchant_info[indexPath.row];
                
                [self performSegueWithIdentifier:@"merchant_profile" sender:self];

            };
            
            return cell;
            
        }
      
    
    }
  
    else if ([type isEqualToString:cell_request_guide]) {
        GeneralTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"appt_request_detail"];
        
        FormDataModel* fModel = self.appointmentModel.request_info.arrRequest_field[indexPath.row];
        
        cell.lblTitle.text = fModel.title;
        
        cell.lblDescription.text = fModel.value;

      
        return cell;
    }
    
    
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* type = arrCellList[indexPath.section];
    
    if ([type isEqualToString:cell_merchant_offer]) {
        
        if ([Utils isArrayNull:self.appointmentModel.arr_Merchant_info]) {
            return;
        }
        MerchantProfileModel* model  = self.appointmentModel.arr_Merchant_info[indexPath.row];
        
        model.isExpand = !model.isExpand;
        
        [self.appointmentModel.arr_Merchant_info replaceObjectAtIndex:indexPath.row withObject:model];
        
        
        [self.ibTableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section]] withRowAnimation:UITableViewRowAnimationNone];
        
    }
    
}

#pragma mark - Show View
-(void)showRatingView:(RateAndReviewBlock)rateNreview
{
    self.ratingViewController = [RatingViewController new];
    self.ratingViewController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    self.ratingViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    
    [self.tabBarController presentViewController:self.ratingViewController animated:YES completion:nil];
    
    __weak typeof (self)weakSelf = self;
    self.ratingViewController.didFinishRateBlock = ^(void)
    {
        
        if ([Utils isStringNull:weakSelf.ratingViewController.txtRating.text]) {
            [MessageManager showMessage:@"Please Input A Review" Type:TSMessageNotificationTypeError inViewController:weakSelf.ratingViewController];
        }
        else{
            
            if (rateNreview) {
                rateNreview(weakSelf.ratingViewController.rating, weakSelf.ratingViewController.txtRating.text);
            }
        }
        NSLog(@"txt:%@",weakSelf.ratingViewController.txtRating.text);
        
        NSLog(@"rating:%i",weakSelf.ratingViewController.rating);
        
    };
    
}

-(void)showAppointmentComleteview
{
    
    
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    AppointmentRequestViewController *appointmentViewController = [storyboard instantiateViewControllerWithIdentifier:@"sb_appointment_request_details"];
    
    [appointmentViewController setupData:self.appointmentModel];
    
    appointmentViewController.viewType = APPOITNMENT_VIEW_TYPE_COMPLETE;
    
    [self.navigationController pushViewController:appointmentViewController animated:YES];
    
}

#pragma mark - Request Server
-(void)requestServerForAppointmentRating:(int)rating Review:(NSString*)review AppointmentID:(NSString*)apptID
                             Completion :(VoidBlock)completion
{
    
    NSString* token = [Utils getToken];
    
    NSDictionary* dict = @{@"token" : IsNullConverstion(token),
                           @"appointment_id" : IsNullConverstion(apptID),
                           @"type" : @"request",
                           @"rate" : @(rating),
                           @"reviews" : IsNullConverstion(review),
                           };
    
    [ConnectionManager requestServerWith:AFNETWORK_POST serverRequestType:ServerRequestTypePostAppointmentComplete parameter:dict appendString:nil success:^(id object) {
        
        
        if (completion) {
            completion();
        }
    } failure:^(id object) {
        
    }];
}

-(void)requestServerForAppointmentValidateCode:(NSString*) verifyCode AppointmentID:(NSString*)apptID
{
    
    [self resignFirstResponder];
    
    NSString* token  = [Utils getToken];
    NSDictionary* dict = @{@"token" : token,
                           @"appointment_id" : apptID,
                           @"verification_code" : verifyCode,
                           @"type" : @"request"
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

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([[segue identifier] isEqualToString:@"merchant_profile"]) {
        
        
        MerchantProfileViewController* mViewController = [segue destinationViewController];
        
        [mViewController setUpMerchantProfile:self.selectedMerchantProfileModel];
    }
}


@end

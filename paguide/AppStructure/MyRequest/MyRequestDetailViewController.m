//
//  MyRequestDetailViewController.m
//  paguide
//
//  Created by Evan Beh on 23/03/2017.
//  Copyright © 2017 Evan Beh. All rights reserved.
//

#import "MyRequestDetailViewController.h"
#import "AppointmentModel.h"
#import "HeaderView.h"
#import "ApptHeaderTableViewCell.h"
#import "GeneralTableViewCell.h"
#import "EmptyTableViewCell.h"
#import "NSString+Extra.h"

#import "UILabel+Extra.h"
#import "PromoCodeViewController.h"
#import "FormDataModel.h"

#define cell_title @"cell_title"
#define cell_merchant_offer @"cell_merchant_offer"
#define cell_request_guide @"MY Request Guide"

@interface MyRequestDetailViewController () <UITableViewDelegate, UITableViewDataSource>
{
    NSArray* arrCellList;
}

@property (weak, nonatomic) IBOutlet UIButton *btnMakePayment;
@property (strong, nonatomic)AppointmentModel* appointmentModel;

@property (weak, nonatomic) IBOutlet UITableView *ibTableView;

@property (nonatomic,strong)NSMutableArray* arrAppointmentList;
@property (nonatomic,strong)TransactionModel* transactionModel;
@property (nonatomic,strong)PromoCodeViewController* promoCodeViewController;


@end

@implementation MyRequestDetailViewController
- (IBAction)btnMakePaymentClicked:(id)sender {
    
    [self showPromoCodeViewAndPayment];
}

-(void)setupData:(AppointmentModel*)model
{
    self.appointmentModel = model;

}

-(void)initSelfView
{
    [self.btnMakePayment setDefaultBorder];
    [self.btnMakePayment setTitle:@"Make Payment" forState:UIControlStateNormal];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initSelfView];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.ibTableView.delegate = self;
    self.ibTableView.dataSource  = self;
    self.ibTableView.rowHeight = UITableViewAutomaticDimension;
    self.ibTableView.estimatedRowHeight  =120.0f;
    [self.ibTableView reloadData];

    self.title = @"Request Guide";
    
     [self.ibTableView registerNib:[UINib nibWithNibName:@"EmptyTableViewCell" bundle:nil] forCellReuseIdentifier:@"empty_cell"];
    
    arrCellList = @[cell_title,cell_merchant_offer,cell_request_guide];

    
    if (![Utils isStringNull:self.appointmentModel.request_id]) {
        [self requestServerForBiddingList];
    }
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
        
        
        if (self.arrAppointmentList.count == 0) {
            return 1;
        }
        else{
            return self.arrAppointmentList.count;

        }
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
        
        cell.lblTitle2.text = self.appointmentModel.request_code;
        
        cell.lblTitle3.text = [NSString stringWithFormat:@"Requested Date : %@",self.appointmentModel.request_info.created_at];
        
        cell.lblTitle4.text = [NSString stringWithFormat:@"Status : %@",self.appointmentModel.status];
        
        return cell;
    }
    else if ([type isEqualToString:cell_merchant_offer]) {
       
        
        if (self.arrAppointmentList.count == 0) {
            EmptyTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"empty_cell"];
            
            cell.lblTitle.text = @"No Offer Receive";
          
            return cell;
        }
        
        else
        {
            AppointmentModel* aModel  = self.arrAppointmentList[indexPath.row];

            MerchantProfileModel* model = aModel.merchant_info_model;
            
            if (model.isExpand) {
                
                GeneralTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"appt_request_offer_expand"];
                
                cell.lblTitle.text = [NSString stringWithFormat:@"%@ %@",aModel.currency,aModel.price];
                
                cell.lblDescription.text = model.name;
                
                cell.didSelectBlock = ^{
                
                    model.isSelect = !model.isSelect;
                    
                    [self.arrAppointmentList replaceObjectAtIndex:indexPath.row withObject:aModel];
                    
                    [self.ibTableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section]] withRowAnimation:UITableViewRowAnimationNone];

                };
                
                [cell.btnSelection setImage:[self getImageForSelection:model.isSelect] forState:UIControlStateNormal];
                
                cell.lblTitle2.text = @"Bid Detail";
                
                cell.lblDescription2.attributedText = [aModel.offer_details getAttributedText];
                
                return cell;
            }
            else{
            
                GeneralTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"appt_request_offer"];
                
                
                cell.lblTitle.text = [NSString stringWithFormat:@"%@ %@",aModel.currency,aModel.price];
                
                cell.lblDescription.text = model.name;
                
                cell.didSelectBlock = ^{
                    
                    model.isSelect = !model.isSelect;
                    
                    [self.arrAppointmentList replaceObjectAtIndex:indexPath.row withObject:aModel];
                    
                    [self.ibTableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section]] withRowAnimation:UITableViewRowAnimationNone];

                };
                
                [cell.btnSelection setImage:[self getImageForSelection:model.isSelect] forState:UIControlStateNormal];

                return cell;

            }
            
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
        
        if ([Utils isArrayNull:self.arrAppointmentList]) {
            return;
        }
        AppointmentModel* aModel  = self.arrAppointmentList[indexPath.row];
        
        MerchantProfileModel* model = aModel.merchant_info_model;

        
        model.isExpand = !model.isExpand;
        
        [self.arrAppointmentList replaceObjectAtIndex:indexPath.row withObject:aModel];
        
        
        [self.ibTableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section]] withRowAnimation:UITableViewRowAnimationNone];

    }

}


-(UIImage*)getImageForSelection:(BOOL)isSelected
{
    if (isSelected) {
        return [UIImage imageNamed:@"icon_check_red.png"];
    }
    else{
        return [UIImage imageNamed:@"icon_uncheck_red.png"];

    }
    
}

#pragma mark - Request Server

-(void)requestServerForBiddingList
{
    
    [LoadingManager show];
    
    NSString* token = [Utils getToken];
    
    NSDictionary* dict = @{@"token" : token,
                           @"request_id" : self.appointmentModel.request_id
                           //@"request_id" : @"lPrsXYAUmnzk6dimvslymedhxOHeTgGeL1QRO5BTZ0E"
                           };
    
    
    [ConnectionManager requestServerWith:AFNETWORK_POST serverRequestType:ServerRequestTypePostRequestBiddinglist parameter:dict appendString:nil success:^(id object) {
        
        [LoadingManager hide];

        NSError* error;
        
        self.arrAppointmentList = [AppointmentModel arrayOfModelsFromDictionaries:object[@"data"] error:&error];
        
        NSLog(@"response requestServerForBiddingList : %@",object);
        
        [self.ibTableView reloadData];
        
    } failure:^(id object) {
        [LoadingManager hide];

    }];
    
}

-(BOOL)validatePayment
{
    
    for (int i = 0; i<self.arrAppointmentList.count; i++) {
        
        AppointmentModel* model = self.arrAppointmentList[i];
        
        if (model.merchant_info_model.isSelect) {
            
            
            return YES;
            
        }
    }
    
    return NO;

}

-(void)showPromoCodeViewAndPayment
{
    
    if (![self validatePayment]) {
        
        
        [MessageManager showMessage:@"Please Choose an offer" Type:TSMessageNotificationTypeWarning];
        
        return;
    }
    
    
    self.promoCodeViewController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    self.promoCodeViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    
    [self.tabBarController presentViewController:self.promoCodeViewController animated:YES completion:nil];
    
    __weak typeof (self)weakSelf = self;
    
    self.promoCodeViewController.didApplyPromoBlock = ^(NSString* promocode)
    {
        
        [weakSelf requestServerToCheckPromoCode:promocode Completion:^{
            
            
            [weakSelf requetServerToPurchaseBidRequestPromoCode:promocode Success:^(NSString *str) {
                
                
                [weakSelf.promoCodeViewController dismissViewControllerAnimated:YES completion:^{
                    
                    [weakSelf showAlert:[NSString stringWithFormat:@"Purchase price is %@ %@",weakSelf.transactionModel.currency,weakSelf.transactionModel.total_price] Message:@"" OK:^{
                        
                        [weakSelf requestForStripeToken:^{
                            
                            [weakSelf requestServerForPayment:weakSelf.transactionModel];
                            
                        } Failure:^{
                            
                        }];
                        
                    } Cancel:nil];
                    
                }];
                
                

               
            } Failure:^(NSString *str) {
                
                [MessageManager showMessage:str Type:TSMessageNotificationTypeError];

            }];
           
        }];
        
    };
    
    
    self.promoCodeViewController.didApplyNoPromoBlock = ^(void)
    {
        
        [weakSelf requetServerToPurchaseBidRequestPromoCode:@"" Success:^(NSString *str) {
            
            
            [weakSelf.promoCodeViewController dismissViewControllerAnimated:YES  completion:^{
               
                [weakSelf requestForStripeToken:^{
                    
                    [weakSelf requestServerForPayment:weakSelf.transactionModel];
                    
                } Failure:^{
                    
                }];
                
            }];
            
            
           
            
        } Failure:^(NSString *str) {
            
            [MessageManager showMessage:str Type:TSMessageNotificationTypeError inViewController:weakSelf.promoCodeViewController];
            
        }];
        
        
    };
    
}


-(void)requetServerToPurchaseBidRequestPromoCode:(NSString*)promocode Success:(StringBlock)completion Failure:(StringBlock)failure
{
    NSString* token = [Utils getToken];
    
    
    NSMutableArray* arrayOfferID = [NSMutableArray new];
    
    for (int i = 0; i<self.arrAppointmentList.count; i++) {
        
        
        AppointmentModel* model = self.arrAppointmentList[i];
        
        if (model.merchant_info_model.isSelect) {
            
            [arrayOfferID addObject:model.offer_id];
        }
    }
    
    NSMutableDictionary* dict = [NSMutableDictionary new];
    
    NSDictionary* oriDict = @{@"token" : IsNullConverstion(token),
                              @"request_id": IsNullConverstion(self.appointmentModel.request_id),
                              @"offer_id" : @"",
                              };
    
    [dict addEntriesFromDictionary:oriDict];
    
    if (![Utils isStringNull:promocode]) {
        
        NSDictionary* dictPromo = @{
                                    @"promo_code" : promocode,
                                    };
        
        [dict addEntriesFromDictionary:dictPromo];
    }
    
    if (![Utils isArrayNull:arrayOfferID]) {
        
        NSDictionary* dictApptChoosen = @{
                                    @"offer_id" : arrayOfferID,
                                    };
        
        [dict addEntriesFromDictionary:dictApptChoosen];


    }
    
    
    [ConnectionManager requestServerWith:AFNETWORK_POST serverRequestType:ServerRequestTypePostRequestBidselection parameter:dict appendString:nil success:^(id object) {
        
        NSError* error;
        
        BaseModel* bModel = [[BaseModel alloc]initWithDictionary:object error:&error];
        
        TransactionModel* model = [[TransactionModel alloc]initWithDictionary:object error:&error];
        
        
        // get transaction id
        self.transactionModel.transaction_id = model.transaction_id;
        self.transactionModel.total_price = model.total_price;
        self.transactionModel.currency = model.currency;
        self.transactionModel.type = @"request";
        
        
        if (completion) {
            completion(bModel.displayMessage);
        }
        
    } failure:^(id object) {
        
        
        NSError* error;
        
        BaseModel* bModel = [[BaseModel alloc]initWithDictionary:object error:&error];
        
        if (failure) {
            failure(bModel.displayMessage);
        }
        
        
    }];
}
-(void)requestServerToCheckPromoCode:(NSString*)promocode Completion:(VoidBlock)completion
{
    
    
    NSDictionary* dict = @{@"token" : [Utils getToken],
                           @"promo_code" : IsNullConverstion(promocode),
                           };
    
    [ConnectionManager requestServerWith:AFNETWORK_POST serverRequestType:ServerRequestTypePostPromocodeCheck parameter:dict appendString:nil success:^(id object) {
        
        NSError* error;
        
        BaseModel* bModel = [[BaseModel alloc]initWithDictionary:object error:&error];
        
        [MessageManager showMessage:bModel.generalMessage Type:TSMessageNotificationTypeSuccess inViewController:self.promoCodeViewController];
        
        if (completion) {
            completion();
        }
        
    } failure:^(id object) {
        
        NSError* error;
        
        BaseModel* bModel = [[BaseModel alloc]initWithDictionary:object error:&error];
        
        [MessageManager showMessage:bModel.generalMessage Type:TSMessageNotificationTypeError inViewController:self.promoCodeViewController];
    }];
}


-(void)requestForStripeToken:(VoidBlock)completion Failure:(VoidBlock)failure
{
    PaymentManager* manager = [PaymentManager Instance];
    
    [manager setupCardPayment:self Success:^(STPToken *token) {
        
        
        self.transactionModel.stripetoken = token.tokenId;
        
        if (completion) {
            completion();
        }
        
        
    } Failure:^(NSError * _Nullable error) {
        
        
        if (failure) {
            failure();
        }
        
    } PresentIn:self];

    
}

-(void)requestServerForPayment:(TransactionModel*)model
{
    
    
    [LoadingManager show];
    NSString* token = [Utils getToken];
    NSDictionary* dict = @{
                           @"token" : IsNullConverstion(token),
                           @"transaction_id" : model.transaction_id,
                           @"stripetoken" : model.stripetoken,
                           @"type" : model.type,
                           
                           };
    
    [ConnectionManager requestServerWith:AFNETWORK_POST serverRequestType:ServerRequestTypePostPaymentStripeCharge parameter:dict appendString:nil success:^(id object) {
        [LoadingManager hide];
        
        NSError* error;
        
        BaseModel* model = [[BaseModel alloc]initWithDictionary:object error:&error];
        
        [MessageManager showMessage:model.generalMessage Type:TSMessageNotificationTypeSuccess inViewController:self];
        
        [self resetMainPage];
        
        [Utils reloadAllFrontView];

        [self showQuitView];
        
        
    } failure:^(id object) {
        
        [LoadingManager hide];
        
        NSError* error;
        
        BaseModel* bModel = [[BaseModel alloc]initWithDictionary:object error:&error];
        
        [MessageManager showMessage:bModel.displayMessage Type:TSMessageNotificationTypeSuccess inViewController:self];
        
    }];
}



#pragma mark - Alert View

-(IBAction)showQuitView
{
    
    
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:@"Confirm"
                                  message:@"Do You still want to continue with this purchase?"
                                  preferredStyle:UIAlertControllerStyleAlert];
    
    
    UIAlertAction* ok = [UIAlertAction
                         actionWithTitle:@"NO"
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                         {

                             [self.navigationController popToRootViewControllerAnimated:YES];
                             
                             
                         }];
    [alert addAction:ok]; // add action to uialertcontroller
    
    UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alert addAction:cancel];
    
    
    [self presentViewController:alert animated:YES completion:nil];
    
    
}


#pragma mark - Declaration


-(TransactionModel*)transactionModel
{
    if (!_transactionModel) {
        _transactionModel = [TransactionModel new];
    }
    return _transactionModel;
}

-(PromoCodeViewController*)promoCodeViewController
{
    if (!_promoCodeViewController) {
        _promoCodeViewController  = [PromoCodeViewController new];
    }
    
    return _promoCodeViewController;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(void)showAlert:(NSString*)title Message:(NSString*)message OK:(VoidBlock)okAction Cancel:(VoidBlock)cancelAction
{
    
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:title
                                  message:message
                                  preferredStyle:UIAlertControllerStyleAlert];
    
    
    UIAlertAction* ok = [UIAlertAction
                         actionWithTitle:@"OK"
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                         {
                             
                             if (okAction) {
                                 okAction();
                             }
                             
                         }];
    [alert addAction:ok]; // add action to uialertcontroller
    
    UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        if (cancelAction) {
            cancelAction();
        }
    }];
    
    [alert addAction:cancel];
    
    [self presentViewController:alert animated:YES completion:nil];
    
    
}
@end

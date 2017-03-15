//
//  PackageDetailsViewController.m
//  paguide
//
//  Created by Evan Beh on 06/03/2017.
//  Copyright © 2017 Evan Beh. All rights reserved.
//

#import "PackageDetailsViewController.h"
#import "PackageDetailsTableViewCell.h"
#import "HeaderView.h"
#import "RatingView.h"
#import "CalenderViewController.h"
#import "QuantitySelectionViewController.h"
#import "PromoCodeViewController.h"

#define cell_type_title @"title"
#define cell_type_details @"details"
#define cell_type_map @"map"

@interface PackageDetailsViewController () <UITableViewDelegate, UITableViewDataSource>
{
    __weak IBOutlet NSLayoutConstraint *constHeight_availability;
    __weak IBOutlet NSLayoutConstraint *constHeight_makepayment;
    NSArray* arrCellList;
}
@property (weak, nonatomic) IBOutlet UITableView *ibTableView;
@property (weak, nonatomic) IBOutlet UIImageView *ibImgProfileView;
@property (weak, nonatomic) IBOutlet UILabel *lblDesc_bottom;
@property (weak, nonatomic) IBOutlet UIView *ibRatingContentView;

@property (weak, nonatomic) IBOutlet UIButton *btnAvailability;
@property (strong, nonatomic) RatingView *ratingView;
@property (weak, nonatomic) IBOutlet UIButton *btnMakePayment;
@property (weak, nonatomic) IBOutlet UILabel *lblGrandTotal_makepayment;
@property (weak, nonatomic) IBOutlet UILabel *lblPrice_makepayment;


@property(nonatomic,strong)QuantitySelectionViewController* quantitySelectionViewController;
@property(nonatomic,strong)PackageDetailsViewController* packageDetailsMakePaymentViewController;
@property(nonatomic,strong)PromoCodeViewController* promoCodeViewController;
@end

@implementation PackageDetailsViewController
- (IBAction)btnMakePaymentClicked:(id)sender {
    
    [self showPromoCodeView];
}

- (IBAction)btnAvailableClicked:(id)sender {
    
    [self showCalenderView];
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initData];
    
    [self initSelfView];
    
    
    arrCellList = @[cell_type_title,cell_type_details,cell_type_map];
    
    
}

-(void)initSelfView
{

    if (_viewType == PACKAGE_VIEW_TYPE_AVAILABILIY) {
        constHeight_makepayment.constant = 0;
        constHeight_availability.constant = 70;

    }
    else{
        constHeight_makepayment.constant = 70;
        constHeight_availability.constant = 0;

    }
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self.ibImgProfileView sd_setImageWithURL:[NSURL URLWithString:@"https://s-media-cache-ak0.pinimg.com/736x/8b/b1/60/8bb160c9f3b45906ef8ffab6ac972870.jpg"]];
    
    self.ibTableView.estimatedRowHeight = 120.0f;
    
    self.ibTableView.rowHeight = UITableViewAutomaticDimension;
    
    [self.ibRatingContentView addSubview:self.ratingView];
    
    self.ratingView.frame = CGRectMake(0, 0, self.ibRatingContentView.frame.size.width, self.ibRatingContentView.frame.size.height);
    
    [self.ratingView setupRatingOutOfFive:4];

    [Utils setRoundBorder:self.btnAvailability color:[UIColor clearColor] borderRadius:5.0f];
    [Utils setRoundBorder:self.btnMakePayment color:[UIColor clearColor] borderRadius:5.0f];

}

-(void)initData
{
    
    // setup view for check availability

    NSString* string1 = @"RM 73.50 per person";
    
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:string1];
    
    NSRange string1_range1 = [attributeString.string rangeOfString:@"RM 73.50"];
    NSRange string1_range2 = [attributeString.string rangeOfString:@"per person"];
    
    

    
    
    [attributeString addAttribute:NSFontAttributeName
                            value:[UIFont fontWithName:@"Helvetica-Bold" size:15.0]
                            range:string1_range1];
    
    
    [attributeString addAttribute:NSForegroundColorAttributeName
                            value:[UIColor darkGrayColor]
                            range:string1_range1];
    
    
    [attributeString addAttribute:NSFontAttributeName
                            value:[UIFont fontWithName:@"Helvetica" size:12.0]
                            range:string1_range2];
    
    
    [attributeString addAttribute:NSForegroundColorAttributeName
                            value:[UIColor grayColor]
                            range:string1_range2];
    
    self.lblDesc_bottom.attributedText = attributeString;
    
    
    // setup view for make payment
    
    
    NSString* stringGrandTotal = @"Total: RM 442.80";
    
    NSMutableAttributedString *attributeString2 = [[NSMutableAttributedString alloc] initWithString:stringGrandTotal];
    
    NSRange string2_range1 = [attributeString2.string rangeOfString:@"Total:"];
    NSRange string2_range2 = [attributeString2.string rangeOfString:@"RM 442.80"];
    
    
    
    
    
    [attributeString2 addAttribute:NSFontAttributeName
                            value:[UIFont fontWithName:@"Helvetica-Bold" size:15.0]
                            range:string2_range1];
    
    
    [attributeString2 addAttribute:NSForegroundColorAttributeName
                            value:[UIColor redColor]
                            range:string2_range1];
    
    
    [attributeString2 addAttribute:NSFontAttributeName
                            value:[UIFont fontWithName:@"Helvetica" size:15.0]
                            range:string2_range2];
    
    
    [attributeString2 addAttribute:NSForegroundColorAttributeName
                            value:[UIColor grayColor]
                            range:string2_range2];
    
    self.lblGrandTotal_makepayment.attributedText = attributeString2;

    self.lblPrice_makepayment.text = @"RM 73.80 * 6";

}


//-(void)viewWillDisappear:(BOOL)animated
//{
//    
//    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
//    [self.navigationController.navigationBar setShadowImage:nil];
//}
//
//-(void)viewWillAppear:(BOOL)animated
//{
//
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
//    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
//    
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString* type = arrCellList[indexPath.section];
    
    if ([type isEqualToString:cell_type_map]) {
        
        return 120;
        
        
    }
    else if ([type isEqualToString:cell_type_details]) {
        
        return 30;
        
        
    }

    return UITableViewAutomaticDimension;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    NSString* type = arrCellList[section];
    
    
    UIView* view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"header_cell"];
    
    if (!view) {
        
        view = [HeaderView initializeCustomView];
        
    }
    
    HeaderView* headerView = (HeaderView*)view;
    
    
    headerView.lblTitle1.text = @"6 in 1 Bundle";
    headerView.lblTitle2.hidden = YES;
    
    if ([type isEqualToString:cell_type_details]) {
        
        return view;

    }
    else{
        return nil;

    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    NSString* type = arrCellList[section];

    if ([type isEqualToString:cell_type_details]) {
        
        return 30.0f;
        
    }
    else
    {
        return 0;
    }

}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return arrCellList.count;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString* type = arrCellList[section];
    
    if ([type isEqualToString:cell_type_title]) {
        
        return 1;

        
    }
    else if ([type isEqualToString:cell_type_details]) {
        
        return 2;

    }
    else if ([type isEqualToString:cell_type_map]) {
        return 1;

    }

    return 0;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* type = arrCellList[indexPath.section];
    
    if ([type isEqualToString:cell_type_title]) {
        
        PackageDetailsTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"package_details_cell"];
        
        cell.lblTitle.text = @"[Outdoor / Nature] 6 in 1 Sentosa & Zoo Package";
        cell.lblDesc.text = @"Travel Delight Pte Ltd";
        
        return cell;
        
    }
    else if ([type isEqualToString:cell_type_details]) {
        
        
        PackageDetailsTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"package_details_desc"];
        
        cell.lblTitle.text = @"- Adventure and experience with the sport in safari";
        
        return cell;
    }
    else if ([type isEqualToString:cell_type_map]) {
        
        PackageDetailsTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"package_details_map"];
        return cell;
    }

    
    return  nil;
}

#pragma mark - Declaration

-(RatingView*)ratingView
{
    if (!_ratingView) {
        _ratingView = [RatingView initializeCustomView];
        
        
    }
    
    return _ratingView;
}

-(QuantitySelectionViewController*)quantitySelectionViewController
{
    if (!_quantitySelectionViewController) {
        _quantitySelectionViewController = [QuantitySelectionViewController new];
    }
    
    return _quantitySelectionViewController;
}

-(PackageDetailsViewController*)packageDetailsMakePaymentViewController
{
    if (!_packageDetailsMakePaymentViewController) {
        
        _packageDetailsMakePaymentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"package_detail_controller"];
     
        _packageDetailsMakePaymentViewController.viewType = PACKAGE_VIEW_TYPE_PAYMENT;
    }
    
    return _packageDetailsMakePaymentViewController;
}

-(PromoCodeViewController*)promoCodeViewController
{
    if (!_promoCodeViewController) {
        _promoCodeViewController  = [PromoCodeViewController new];
    }
    
    return _promoCodeViewController;
}
#pragma mark - Show View

-(void)showCalenderView
{
    CalenderViewController* viewC = [CalenderViewController new];
    viewC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:viewC animated:YES];
    
    viewC.didContinueWithDateBlock = ^(NSDate* date)
    {
        
        [self showQuantityView];
    };
}


-(void)showQuantityView
{
    self.quantitySelectionViewController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    self.quantitySelectionViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    
    [self.tabBarController presentViewController:self.quantitySelectionViewController animated:YES completion:nil];
    
    self.quantitySelectionViewController.didSelectQuantityBlock = ^(int count)
    {
        [self.quantitySelectionViewController dismissViewControllerAnimated:YES completion:^{
            
            [self showPaymentPackageDetailView];
        }];
    };
    
}

-(void)showPaymentPackageDetailView
{

    _packageDetailsMakePaymentViewController = nil;
    [self.navigationController pushViewController:self.packageDetailsMakePaymentViewController animated:YES];

}


-(void)showPromoCodeView
{
    self.promoCodeViewController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    self.promoCodeViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    
    [self.tabBarController presentViewController:self.promoCodeViewController animated:YES completion:nil];
    
    __weak typeof (self)weakSelf = self;
    
    self.promoCodeViewController.didApplyPromoBlock = ^(void)
    {
        [weakSelf.promoCodeViewController dismissViewControllerAnimated:YES completion:^{
            
            
            [weakSelf.navigationController popToRootViewControllerAnimated:YES];
        }];
    };

}


#pragma mark - Navigation
//
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    // Get the new view controller using [segue destinationViewController].
//    // Pass the selected object to the new view controller.
//    
//    if ([[segue identifier] isEqualToString:@"package_details"]) {
//        
//        PackageDetailsViewController *vc = [segue destinationViewController];
//        
//        vc.viewType = PACKAGE_VIEW_TYPE_PAYMENT;
//        
//    }
//}



@end

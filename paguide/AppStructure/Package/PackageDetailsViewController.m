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
#import "AppDelegate.h"
#import "SelectPackageViewController.h"
#import "OfflineManager.h"
#import "NSString+Extra.h"
#import "MerchantProfileViewController.h"
#import "GuestModeViewController.h"
#import "UIViewController+Extension.h"


#define cell_type_title @"title"
#define cell_type_details @"details"
#define cell_type_map @"map"
#define cell_type_desc @"description"
#define cell_type_cancellation @"cancellation_policy"

#define cell_detail_packageCode @"Package Code"
#define cell_detail_mode @"Mode"
#define cell_detail_duration @"Duration"
#define cell_detail_itinerary @"Itinerary"
#define cell_detail_language @"Language"
#define cell_detail_recommended @"recommended"
#define cell_detail_include @"Include"
#define cell_detail_type @"Type"

@interface PackageDetailsViewController () <UITableViewDelegate, UITableViewDataSource>
{
    __weak IBOutlet NSLayoutConstraint *constHeight_availability;
    __weak IBOutlet NSLayoutConstraint *constHeight_makepayment;
    NSArray* arrCellList;
    NSArray* arrCellDetailsList;
    
    BOOL isPackageBookmarked;
    
    MerchantProfileModel* merchantProfileModel;

}

@property (nonatomic,assign) BOOL isCheckOutWithGuestMode;


// Data
@property (nonatomic) PackageModel* packageModel;
@property (nonatomic) NSString* packageID;
@property (nonatomic) ScheduleModel* selectedScheduleModel;
@property (nonatomic) TransactionModel* transactionModel;//for package purhcase and stripe token
@property (nonatomic) ProfileModel* guestModeModel;

//UI
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
@property(nonatomic,strong)SelectPackageViewController* selectPackageViewController;


@end

@implementation PackageDetailsViewController

#pragma mark - Setup Data for payment
-(void)setupPackageDetailPayment:(ScheduleModel*)model
{
    self.selectedScheduleModel = model;
}

#pragma mark - IBAction

- (IBAction)btnBookmarkClicked:(id)sender {
    
    
    
    if (![Utils isUserLogin]) {
        
        [MessageManager showMessage:@"Please Login first To Bookmark" Type:TSMessageNotificationTypeWarning];
        
        return;
    }
    if (isPackageBookmarked) {
        
        [OfflineManager deleteBookMarked:self.packageModel.packages_code];

        
    }
    else{
        [OfflineManager storePackageList:self.packageModel];
        
    }

    isPackageBookmarked = !isPackageBookmarked;

    [self changeItemBarBookedmarked:isPackageBookmarked];

    
}

- (IBAction)btnMakePaymentClicked:(id)sender {
    
    
    
    
    if([Utils isUserLogin])
    {
        [self showPromoCodeView];

    }
    else{
        GuestModeViewController* gVC = [GuestModeViewController instantiate];
        
        [gVC userDidSelecGuestMode:^(id object) {
            
            if ([object isKindOfClass:[ProfileModel class]]) {
                
                DataManager* manager = [DataManager Instance];
                
                self.guestModeModel = object;
                
                manager.guestModeModel = self.guestModeModel;
                
            }
            
            
            [self requestServerForGuestLogin:^{
                
                [self showPromoCodeView];
                
            }];
            
            
        } userDidLogin:^(id object) {
            
            if (![Utils isUserLogin]) {
                
                [self showPromptToLogin];
                
                return;
            }
            
        }];
        
        
        [self.navigationController pushViewController:gVC animated:YES];

    }

}

- (IBAction)btnAvailableClicked:(id)sender {

    [self showCalenderView];

   
    
//    UINavigationController* navigationController = [[UINavigationController alloc]initWithRootViewController:gVC];
//    
//    navigationController.navigationBar.barTintColor = [UIColor whiteColor];
//    navigationController.navigationBar.translucent = NO;
//
//    
//    [self presentViewController:navigationController animated:YES completion:nil];
//    
  //  [gVC setup];
    
    
//    return;
//    
//    if (![Utils isUserLogin]) {
//        
//        [self showPromptToLogin];
//        
//        return;
//    }
//
//    
//    [self showCalenderView];
//    
}


- (IBAction)btnPurchaseClicked:(id)sender {
    
    if (![Utils isUserLogin]) {
        
        [self showPromptToLogin];
        
        return;
    }
    [self showPackageSelectionViewNonSecheduled];
}

#pragma mark - Validation




#pragma mark - Setup
-(void)setupData:(PackageModel*)model
{
    self.packageModel = model;
}

-(void)setupPackageID:(NSString*)packageID
{
    self.packageID = packageID;
}


-(void)setupButton
{
    [self.btnAvailability removeTarget:nil
                       action:NULL
             forControlEvents:UIControlEventAllEvents];
    
    if (self.packageModel.isScheduled) {
        
        [self.btnAvailability setTitle:@"Check Availability" forState:UIControlStateNormal];
        
        [self.btnAvailability addTarget:self action:@selector(btnAvailableClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    else{
        [self.btnAvailability setTitle:@"Purchase" forState:UIControlStateNormal];

        [self.btnAvailability addTarget:self action:@selector(btnPurchaseClicked:) forControlEvents:UIControlEventTouchUpInside];

    }
    
}

-(void)changeItemBarBookedmarked:(BOOL)isBookmarked
{
    
    if (isBookmarked) {
        UIImage* image = [[UIImage imageNamed:@"icon_bookmark_red.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        
        UIBarButtonItem* editButton = [[UIBarButtonItem alloc]initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(btnBookmarkClicked:)];
        
        editButton.tintColor = APP_MAIN_COLOR;
        
        self.navigationItem.rightBarButtonItems = [NSArray arrayWithObject:editButton];

    }
    else{
    
        UIImage* image = [[UIImage imageNamed:@"icon_bookmark_red.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        
        UIBarButtonItem* editButton = [[UIBarButtonItem alloc]initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(btnBookmarkClicked:)];
        
        editButton.tintColor = [UIColor darkGrayColor];
        
        self.navigationItem.rightBarButtonItems = [NSArray arrayWithObject:editButton];

    }

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.guestModeModel = [[DataManager Instance]guestModeModel];
    
    [self initSelfView];
    
    
    arrCellList = @[cell_type_title,cell_type_details,cell_type_desc,cell_type_map,cell_type_cancellation];
   
    arrCellDetailsList = @[cell_detail_packageCode,
                           cell_detail_mode,
                           cell_detail_duration,
                           cell_detail_itinerary,
                           cell_detail_language,
                           cell_detail_recommended,
                           cell_detail_include,
                           cell_detail_type,
                           ];
    
    
    if (self.packageModel) {
        [self initData];

    }
    else{
        [self requestServerForPackageDetails];

    }
}

-(void)initSelfView
{
    self.title = @"Package Details";
    
    if (_viewType == PACKAGE_VIEW_TYPE_AVAILABILIY) {
        constHeight_makepayment.constant = 0;
        constHeight_availability.constant = 70;

    }
    else{
        constHeight_makepayment.constant = 70;
        constHeight_availability.constant = 0;

    }
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.ibTableView.estimatedRowHeight = 120.0f;
    
    self.ibTableView.rowHeight = UITableViewAutomaticDimension;
    
    if (_viewType == PACKAGE_VIEW_TYPE_AVAILABILIY) {

        [self.ibTableView pullToRefresh:^{
           
            
            [self requestServerForPackageDetails];

        }];
    }


    [Utils setRoundBorder:self.btnAvailability color:[UIColor clearColor] borderRadius:5.0f];
    [Utils setRoundBorder:self.btnMakePayment color:[UIColor clearColor] borderRadius:5.0f];

}

-(void)addRating
{
    
        [self.ibRatingContentView addSubview:self.ratingView];
    
        self.ratingView.frame = CGRectMake(0, 0, self.ibRatingContentView.frame.size.width, self.ibRatingContentView.frame.size.height);
    
        [self.ratingView setupRatingOutOfFive:round([self.packageModel.ratings doubleValue])];
}
-(void)initData
{
    
    // setup view for check availability
    
    [self addRating];
    
    [self setupButton];

   
    isPackageBookmarked = [OfflineManager checkIsPackageBookmarked:self.packageModel.packages_code];
    
    [self changeItemBarBookedmarked:isPackageBookmarked];
    
    if (_viewType == PACKAGE_VIEW_TYPE_AVAILABILIY) {
        
        NSString* display_price = [NSString stringWithFormat:@"%@ %@",self.packageModel.currency,self.packageModel.price];
        
        NSString* display_unit = @"per person";
        
        NSString* string1 = [NSString stringWithFormat:@"%@ %@",display_price, display_unit];
        
        NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:string1];
        
        NSRange string1_range1 = [attributeString.string rangeOfString:display_price];
        NSRange string1_range2 = [attributeString.string rangeOfString:display_unit];
        
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
        

        
        if (![Utils isArrayNull:self.packageModel.cover_img]) {
            [self.ibImgProfileView sd_setImageWithURL:[NSURL URLWithString:self.packageModel.cover_img[0]] placeholderImage:PHOTO_PLACEHOLDER];

        }
        
        [self.ibTableView reloadData];
     
        
    }
    
    // setup view for make payment

    else{
        
        NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
        f.numberStyle = NSNumberFormatterDecimalStyle;
       
        NSNumber *singlePackPrice = [f numberFromString:self.packageModel.price];
        
        int pax = [self.selectedScheduleModel.quantity intValue];
        
        NSNumber* totalPrice = [NSNumber numberWithFloat:[singlePackPrice floatValue]*pax];
        
        NSString* currency_total_price = [NSString stringWithFormat:@"%@ %@",self.packageModel.currency,[totalPrice stringValue]];
        
        NSString* stringGrandTotal = [NSString stringWithFormat:@"Total : %@",currency_total_price];
        
        NSMutableAttributedString *attributeString2 = [[NSMutableAttributedString alloc] initWithString:stringGrandTotal];
        
        NSRange string2_range1 = [attributeString2.string rangeOfString:@"Total :"];
        NSRange string2_range2 = [attributeString2.string rangeOfString:currency_total_price];
        
        
        
        [attributeString2 addAttribute:NSFontAttributeName
                                 value:[UIFont fontWithName:@"Helvetica-Bold" size:15.0]
                                 range:string2_range1];
        
        
        [attributeString2 addAttribute:NSForegroundColorAttributeName
                                 value:APP_MAIN_COLOR
                                 range:string2_range1];
        
        [attributeString2 addAttribute:NSFontAttributeName
                                 value:[UIFont fontWithName:@"Helvetica" size:15.0]
                                 range:string2_range2];
        
        
        [attributeString2 addAttribute:NSForegroundColorAttributeName
                                 value:[UIColor grayColor]
                                 range:string2_range2];
        
        self.lblGrandTotal_makepayment.attributedText = attributeString2;
        
        self.lblPrice_makepayment.text = [NSString stringWithFormat:@"%@ %@ * %@",
                                          self.packageModel.currency,
                                          singlePackPrice,
                                          [NSString stringWithFormat:@"%i",pax
                                           ]];
        
        if (![Utils isArrayNull:self.packageModel.cover_img]) {
            [self.ibImgProfileView sd_setImageWithURL:[NSURL URLWithString:self.packageModel.cover_img[0]] placeholderImage:PHOTO_PLACEHOLDER];
            
        }
        [self.ibTableView reloadData];
    }
    
    
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
        
        return 240;
        
        
    }
//    else if ([type isEqualToString:cell_type_details]) {
//        
//        return 30;
//        
//        
//    }
//    
    

    return UITableViewAutomaticDimension;
}

//
//- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    
//    
//    return nil;
//
////    NSString* type = arrCellList[section];
////    
////    
////    UIView* view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"header_cell"];
////    
////    if (!view) {
////        
////        view = [HeaderView initializeCustomView];
////        
////    }
////    
////    HeaderView* headerView = (HeaderView*)view;
////    
////    
////    headerView.lblTitle1.text = @"6 in 1 Bundle";
////    headerView.lblTitle2.hidden = YES;
////    
////    if ([type isEqualToString:cell_type_details]) {
////        
////        return view;
////
////    }
////    else{
////
////    }
//    
//}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    NSString* type = arrCellList[section];
//
//    if ([type isEqualToString:cell_type_details]) {
//        
//        return 30.0f;
//        
//    }
//    else
//    {
//        return 0;
//    }
//
//}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return arrCellList.count;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString* type = arrCellList[section];
    
    
    if (self.isMiddleOfLoadingPage) {
        
        return 0;
    }
    if ([type isEqualToString:cell_type_map]||
        [type isEqualToString:cell_type_desc] ||
        [type isEqualToString:cell_type_cancellation]||
        [type isEqualToString:cell_type_title]) {
        return 1;
        
    }

    else if ([type isEqualToString:cell_type_details]) {
        
        return arrCellDetailsList.count;

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
        
        cell.lblTitle.text = self.packageModel.name;
        cell.lblDesc.text = self.packageModel.merchant_info.username;
        
        return cell;
        
    }
    else if ([type isEqualToString:cell_type_details]) {
        
        
        PackageDetailsTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"package_details_desc"];
        
        
        [self populateCellDescription:cell IndexPath:indexPath];
        
        
        return cell;
    }
    else if ([type isEqualToString:cell_type_desc]) {
        
        PackageDetailsTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"package_details_desc2"];
        
        cell.lblTitle.text = @"Description";
      
        
        if (self.packageModel.desc.customAttributedText) {
            
            cell.lblTTDesc.attributedText = self.packageModel.desc.customAttributedText;
        }
        else{
            
            [self.packageModel.desc getAttributedText:^(NSAttributedString *attStr) {
                
                cell.lblTTDesc.attributedText = attStr;
                
                [self.ibTableView reloadData];
                
                
            }];
            
        }
        

        return cell;
    }
    
    else if ([type isEqualToString:cell_type_map]) {
        
        PackageDetailsTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"package_details_map"];
        
        NSArray* coordinate = [self.packageModel.latlng componentsSeparatedByString:@","];
        
        float latitude = [coordinate[0] floatValue];
        
        float longtitude = [coordinate[1] floatValue];
        
        CLLocation *location = [[CLLocation alloc]initWithLatitude:latitude longitude:longtitude];

        [cell setLocation:location];
        
        return cell;
    }
    
    else if ([type isEqualToString:cell_type_cancellation]) {
        
        PackageDetailsTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"package_details_desc2"];
        
        cell.lblTitle.text = @"Cancellation Policy";
        
        if (self.packageModel.cancellation_policy.customAttributedText) {
            
            cell.lblTTDesc.attributedText = self.packageModel.cancellation_policy.customAttributedText;
        }
        else{
        
            [self.packageModel.cancellation_policy getAttributedText:^(NSAttributedString *attStr) {
                
                cell.lblTTDesc.attributedText = attStr;
                
                [self.ibTableView reloadData];
                

            }];

        }
        
        return cell;
        
    }

    
    return  nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* type = arrCellList[indexPath.section];
    
    if ([type isEqualToString:cell_type_title]) {
        
        
        [self showMerchantView];
        
    }
}


-(NSMutableAttributedString*)convertAttributedStringFor:(NSString*)fullString StringToChange:(NSString*)substring
{
    
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:fullString];

    NSRange string1_range1 = [attributeString.string rangeOfString:substring];

    [attributeString addAttribute:NSFontAttributeName
                            value:[UIFont boldSystemFontOfSize:12.0f]
                            range:string1_range1];
    
    
    [attributeString addAttribute:NSForegroundColorAttributeName
                            value:[UIColor darkGrayColor]
                            range:string1_range1];
    
    return attributeString;
}


-(void)populateCellDescription:(PackageDetailsTableViewCell*)cell IndexPath:(NSIndexPath*)indexPath
{
    
    NSString* type = arrCellDetailsList[indexPath.row];
    
    if ([type isEqualToString:cell_detail_mode]) {
        

        NSString* string1 = @"Mode :";
        
        NSString* string2 = [NSString validateText:self.packageModel.mode];
        
        cell.lblTitle.attributedText = [self convertAttributedStringFor:[NSString stringWithFormat:@"%@ %@",string1,string2] StringToChange:string1];
        

    }
    else if ([type isEqualToString:cell_detail_packageCode]) {
        
        NSString* string1 = @"Package Code :";
        
        NSString* string2 = [NSString stringWithFormat:@"%@",self.packageModel.packages_code];
        
        cell.lblTitle.attributedText = [self convertAttributedStringFor:[NSString stringWithFormat:@"%@ %@",string1,string2] StringToChange:string1];
        
    }
    else if ([type isEqualToString:cell_detail_duration]) {
        
        NSString* string1 = @"Duration :";
        
        NSString* string2 = [NSString stringWithFormat:@"%@",self.packageModel.duration];
        
        cell.lblTitle.attributedText = [self convertAttributedStringFor:[NSString stringWithFormat:@"%@ %@",string1,string2] StringToChange:string1];

    }
    else if ([type isEqualToString:cell_detail_itinerary]) {
      
        NSString* string1 = @"Itinerary :";
        
        NSString* string2 = [NSString validateText:self.packageModel.itinerary];
        
        cell.lblTitle.attributedText = [self convertAttributedStringFor:[NSString stringWithFormat:@"%@ %@",string1,string2] StringToChange:string1];

    }
    else if ([type isEqualToString:cell_detail_language]) {
        
        NSString* string1 = @"Language :";
        
        NSString* string2 = [self.packageModel.language componentsJoinedByString:@","];
        
        
        cell.lblTitle.attributedText = [self convertAttributedStringFor:[NSString stringWithFormat:@"%@ %@",string1,string2] StringToChange:string1];

    }
    else if ([type isEqualToString:cell_detail_recommended]) {

        NSString* string1 = @"Recommended :";
        
        NSString* string2 = [NSString validateText:self.packageModel.recommended];
        
        cell.lblTitle.attributedText = [self convertAttributedStringFor:[NSString stringWithFormat:@"%@ %@",string1,string2] StringToChange:string1];

    }
    else if ([type isEqualToString:cell_detail_include]) {

        NSString* string1 = @"Include :";
        
        NSString* string2 = [NSString validateText:self.packageModel.include];
        
        cell.lblTitle.attributedText = [self convertAttributedStringFor:[NSString stringWithFormat:@"%@ %@",string1,string2] StringToChange:string1];
    }
    else if ([type isEqualToString:cell_detail_type]) {
        NSString* string1 = @"Type :";
        
        NSString* string2 = [NSString validateText:self.packageModel.type];
        
        cell.lblTitle.attributedText = [self convertAttributedStringFor:[NSString stringWithFormat:@"%@ %@",string1,string2] StringToChange:string1];


    }
    
}

#pragma mark - Declaration


-(TransactionModel*)transactionModel
{
    if (!_transactionModel) {
        _transactionModel = [TransactionModel new];
    }
    return _transactionModel;
}

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
    
    if (![self validateEventDate:self.packageModel.scheduled_datetime]) {
        
        [MessageManager showMessage:@"No Available Date" Type:TSMessageNotificationTypeError];
        
        return;
    }
    
    CalenderViewController* viewC = [CalenderViewController new];
    viewC.hidesBottomBarWhenPushed = YES;
    
    
    if (self.packageModel) {
        
        [viewC setupData:self.packageModel];
        
        [self.navigationController pushViewController:viewC animated:YES];

    }
    
    viewC.didContinueWithDateBlock = ^(NSString* strDate)
    {
        
       // [self showQuantityView];
        
        [self showPackageSelectionView:strDate];
    };
}


//-(void)showQuantityView
//{
//    self.quantitySelectionViewController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
//    self.quantitySelectionViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
//    
//    [self.tabBarController presentViewController:self.quantitySelectionViewController animated:YES completion:nil];
//    
//    
//    __weak typeof (self)weakSelf = self;
//    
//    self.quantitySelectionViewController.didSelectQuantityBlock = ^(int count)
//    {
//        [weakSelf.quantitySelectionViewController dismissViewControllerAnimated:YES completion:^{
//            
//            [weakSelf showPaymentPackageDetailView];
//        }];
//    };
//    
//}


-(void)showPackageSelectionView:(NSString*)selectedDate
{
    
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"PackageSelection" bundle:nil];
    UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"sb_package_selection"];
    
    
    viewController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    viewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    
    
    _selectPackageViewController = (SelectPackageViewController*)viewController;
    
    [self.selectPackageViewController setuDataWithPackage:self.packageModel SelectedDate:selectedDate];
    
    __weak typeof (self)weakSelf = self;
    
    self.selectPackageViewController.didFinishSelectScheduleBlock = ^(ScheduleModel* model)
    {
        [weakSelf.selectPackageViewController dismissViewControllerAnimated:YES completion:^{
            
            [weakSelf showPaymentPackageDetailView:model];
        }];
    };
    
    [self.tabBarController presentViewController:viewController animated:YES completion:nil];
 
}


-(void)showPackageSelectionViewNonSecheduled
{
    
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"PackageSelection" bundle:nil];
    UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"sb_package_selection"];
    
    
    viewController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    viewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    
    _selectPackageViewController = (SelectPackageViewController*)viewController;
    
    [self.selectPackageViewController setuDataWithPackage:self.packageModel];
    
    __weak typeof (self)weakSelf = self;
    
    self.selectPackageViewController.didFinishSelectScheduleBlock = ^(ScheduleModel* model)
    {
        [weakSelf.selectPackageViewController dismissViewControllerAnimated:YES completion:^{
            
            [weakSelf showPaymentPackageDetailView:model];
        }];
    };
    
    [self.tabBarController presentViewController:viewController animated:YES completion:nil];
    
    
}


-(void)showPaymentPackageDetailView:(ScheduleModel*)model
{
    _packageDetailsMakePaymentViewController = nil;
    
    [self.packageDetailsMakePaymentViewController setupPackageDetailPayment:model];
    
    [self.packageDetailsMakePaymentViewController setupData:self.packageModel];
    
    [self.navigationController pushViewController:self.packageDetailsMakePaymentViewController animated:YES];

}

-(void)showPromoCodeView
{
    self.promoCodeViewController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    self.promoCodeViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    
    [self.tabBarController presentViewController:self.promoCodeViewController animated:YES completion:nil];
    
    __weak typeof (self)weakSelf = self;
    
    StringBlock confirmPaymentBlock = ^(NSString* token)
    {
        [weakSelf.promoCodeViewController dismissViewControllerAnimated:YES completion:^{
            
            
            [weakSelf showAlert:[NSString stringWithFormat:@"Purchase price is %@ %@",weakSelf.transactionModel.currency,weakSelf.transactionModel.total_price] Message:@"" OK:^{
                
                
                [weakSelf requestForStripeToken:^{
                    
                    [weakSelf requestServerForPaymentWithToken:token Transaction:weakSelf.transactionModel];
                    
                } Failure:^{
                    
                    [MessageManager showMessage:@"Failed to request stripe token" Type:TSMessageNotificationTypeError inViewController:self];
                }];
                
            } Cancel:^{
                
            }];
            
        }];
    };
    
    self.promoCodeViewController.didApplyPromoBlock = ^(NSString* promocode)
    {
        
        [weakSelf requestServerToCheckPromoCode:promocode Completion:^{
            
            
            if (![Utils isStringNull:[Utils getToken]]) {
               
                NSString* token = [Utils getToken];
                [weakSelf requestServerToPurchasePackageWithToken:token PromoCode:promocode Success:^(NSString *str) {
                    
                    
                    confirmPaymentBlock(token);
                    
                    
                } Failure:^(NSString *str) {
                    
                    [MessageManager showMessage:str Type:TSMessageNotificationTypeError];
                    
                }];
            }
            else
            {
            
                NSString* token = weakSelf.guestModeModel.user_id;

                [weakSelf requestServerToPurchasePackageWithToken:token PromoCode:promocode Success:^(NSString *str) {
                    
                    confirmPaymentBlock(token);
                    
                    
                } Failure:^(NSString *str) {
                    
                    [MessageManager showMessage:str Type:TSMessageNotificationTypeError];
                    
                }];
            }
            
            
        }];

    };
    
    
    self.promoCodeViewController.didApplyNoPromoBlock = ^(void)
    {
        if (![Utils isStringNull:[Utils getToken]]) {
            
            NSString* token = [Utils getToken];

            [weakSelf requestServerToPurchasePackageWithToken:token PromoCode:nil Success:^(NSString *str) {
                
                confirmPaymentBlock(token);
                
                
            } Failure:^(NSString *str) {
                
                [MessageManager showMessage:str Type:TSMessageNotificationTypeError inViewController:weakSelf.promoCodeViewController];
                
            }];
        }
        else{
        
            NSString* token = weakSelf.guestModeModel.user_id;

            [weakSelf requestServerToPurchasePackageWithToken:token PromoCode:nil Success:^(NSString *str) {
                
                confirmPaymentBlock(token);
                
                
            } Failure:^(NSString *str) {
                
                [MessageManager showMessage:str Type:TSMessageNotificationTypeError];
                
            }];

        }
      

    };

}

#pragma mark - Request Server

-(void)requestServerForPackageDetails
{
    
    [LoadingManager show];

    if (self.isMiddleOfLoadingPage)
    {
        return;
    }
    
    self.isMiddleOfLoadingPage = YES;
    
    [self.ibTableView reloadData];
    
    NSDictionary* dict = @{@"packages_id" : IsNullConverstion(self.packageID)};
    
    [ConnectionManager requestServerWith:AFNETWORK_POST serverRequestType:ServerRequestTypePostPackageDetailsInfo parameter:dict appendString:nil success:^(id object) {
        
        
        self.isMiddleOfLoadingPage = NO;

        
        [self.ibTableView stopRefresh];
        
        
        [LoadingManager hide];

        NSError* error;
        
        self.packageModel = [[PackageModel alloc]initWithDictionary:object[@"data"] error:&error];
        
        [self.ibTableView reloadData];
        
        [self initData];

    } failure:^(id object) {
        
        self.isMiddleOfLoadingPage = NO;

        [self.ibTableView stopRefresh];

        [LoadingManager hide];

    }];
}

-(void)requestServerToCheckPromoCode:(NSString*)promocode Completion:(VoidBlock)completion
{
    NSDictionary* dict = @{@"token" : [Utils getToken],
                           @"promo_code" : IsNullConverstion(promocode),
                           };
    
    [ConnectionManager requestServerWith:AFNETWORK_POST serverRequestType:ServerRequestTypePostPromocodeCheck parameter:dict appendString:nil success:^(id object) {
        
     //   NSError* error;
        
    //    BaseModel* bModel = [[BaseModel alloc]initWithDictionary:object error:&error];
        
      //  [MessageManager showMessage:bModel.generalMessage Type:TSMessageNotificationTypeSuccess inViewController:self];
    
        if (completion) {
            completion();
        }
        
    } failure:^(id object) {
        
        NSError* error;
        
        BaseModel* bModel = [[BaseModel alloc]initWithDictionary:object error:&error];
        
        [MessageManager showMessage:bModel.generalMessage Type:TSMessageNotificationTypeError inViewController:self.promoCodeViewController];
    }];
}


-(void)requestServerToPurchasePackageWithToken:(NSString*)token PromoCode:(NSString*)promoCode Success:(StringBlock)success Failure:(StringBlock)failure
{
    NSDictionary* dict;

    NSString* date_language_pax_time;
    
    if (self.packageModel.isScheduled) {
        
       
        date_language_pax_time = [NSString stringWithFormat:@"%@|%@|%@|%@",
                                            self.selectedScheduleModel.scheduled_date,
                                            self.selectedScheduleModel.language,
                                            self.selectedScheduleModel.quantity,
                                            self.selectedScheduleModel.scheduled_time];
    }
    else{
        
        date_language_pax_time = [NSString stringWithFormat:@"%@|%@|%@|%@",
                                  [[self dateFormatter1] stringFromDate:self.selectedScheduleModel.selectedDate],
                                  self.selectedScheduleModel.inputLanguage,
                                  self.selectedScheduleModel.quantity,
                                  [[self timeFormatter] stringFromDate:self.selectedScheduleModel.selectedDate]
                                  ];
    }
 
    
    if ([Utils isStringNull:promoCode]) {

        dict = @{
                 @"packages_id" : IsNullConverstion(self.packageModel.packages_id),
                 @"pax" : IsNullConverstion(self.selectedScheduleModel.quantity),
                 @"scheduled_datetime" : IsNullConverstion(date_language_pax_time),
                 @"token" : IsNullConverstion(token)
                 };
    }
    else{
        dict = @{@"promo_code" : promoCode,
                 @"packages_id" : self.packageModel.packages_id,
                 @"pax" : IsNullConverstion(self.selectedScheduleModel.quantity),
                 @"scheduled_datetime" : IsNullConverstion(date_language_pax_time),
                 @"token" : IsNullConverstion(token)
                 };

    }
    
    [ConnectionManager requestServerWith:AFNETWORK_POST serverRequestType:ServerRequestTypePostPackagePurchase parameter:dict appendString:nil success:^(id object) {
        
        NSError* error;
        
        BaseModel* bModel = [[BaseModel alloc]initWithDictionary:object error:&error];
        
        TransactionModel* model = [[TransactionModel alloc]initWithDictionary:object error:&error];
        
        
        // get transaction id
        self.transactionModel.transaction_id = model.transaction_id;
        self.transactionModel.total_price = model.total_price;
        self.transactionModel.currency = model.currency;
        self.transactionModel.type = @"package";

        
        if (success) {
            success(bModel.displayMessage);
        }
        
        
    } failure:^(id object) {
        
        NSError* error;
        
        BaseModel* bModel = [[BaseModel alloc]initWithDictionary:object error:&error];
        
        if (failure) {
            failure(bModel.displayMessage);
        }
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

-(void)requestServerForPaymentWithToken:(NSString*)token Transaction:(TransactionModel*)model
{
    
    [LoadingManager show];

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
        
        
        [Utils reloadAllFrontView];
        
        [self showQuitView];
        
        
        
    } failure:^(id object) {
        
        [LoadingManager hide];

        NSError* error;
        
        BaseModel* bModel = [[BaseModel alloc]initWithDictionary:object error:&error];
        
        [MessageManager showMessage:bModel.displayMessage Type:TSMessageNotificationTypeError inViewController:self];
        
    }];
}


-(void)requestServerForGuestLogin:(VoidBlock)completion
{
    
    NSString* contactNumber = [NSString stringWithFormat:@"%@%@",self.guestModeModel.temp_prefix,self.guestModeModel.temp_mobile_number];
    
    NSDictionary* dict = @{@"guest" : @(1),
                           @"email" : IsNullConverstion(self.guestModeModel.email),
                           @"mobile_number" : IsNullConverstion(contactNumber),
                           @"username" : IsNullConverstion(self.guestModeModel.name)
                           };
    
    NSString* appendString = @"";
    
    [ConnectionManager requestServerWith:AFNETWORK_POST serverRequestType:ServerRequestTypePostGuestLogin parameter:dict appendString:appendString success:^(id object) {
        
        NSError* error;
        
        BaseModel* bModel = [[BaseModel alloc]initWithDictionary:object error:&error];
        
        NSString* userID;
        
        if (bModel.isSuccessful) {
            
          userID  = object[@"user_id"];

            self.guestModeModel.user_id = userID;
            
            if (completion) {
                completion();
            }
        }
        else{
            [MessageManager showMessage:bModel.displayMessage Type:TSMessageNotificationTypeError];

        }
        
        
    } failure:^(id object) {
        
        NSError* error;

        BaseModel* bModel = [[BaseModel alloc]initWithDictionary:object error:&error];
 
        [MessageManager showMessage:bModel.displayMessage Type:TSMessageNotificationTypeError];
    }];
}


#pragma mark - Alert View

-(IBAction)showQuitView
{
    
    
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:@"Confirm"
                                  message:@"Do you still want to stay on this page?"
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

-(BOOL)validateEventDate:(NSArray*)array
{
    
    for (int i = 0; i< array.count; i++) {
        ScheduleModel* model = array[i];
        
        NSDateFormatter* dateFormatter = [self dateFormatter1];
        
        NSDate* date = [dateFormatter dateFromString:model.scheduled_date];
        
        NSDate* dateServer = date;
        
        
        NSString* strDateToday = [[self dateFormatter1]stringFromDate:[NSDate date]];
        NSDate* dateToday = [[self dateFormatter1]dateFromString:strDateToday];
        
        
        if ([dateServer compare:dateToday] >= NSOrderedDescending) {
            NSLog(@"date1 is later than date2");
            
            return YES;
        }
    }
    
    return NO;
}


- (NSDateFormatter *)dateFormatter1 {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];

    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    [dateFormatter setDateFormat:@"dd-MM-yyyy"];
    
    
    return dateFormatter;
}

-(void)showMerchantView
{
    
    [LoadingManager show];

    [MerchantProfileViewController requestServerForMerchantID:self.packageModel.merchant_info.merchant_id Completion:^(NSDictionary *dict) {
        
        [LoadingManager hide];
        
        MerchantProfileModel* model = [[MerchantProfileModel alloc]initWithDictionary:dict[@"data"] error:nil];
        
        merchantProfileModel = model;
        
        [self performSegueWithIdentifier:@"package_details_merchant" sender:self];
        
        
    } Fail:^(NSDictionary *dict) {
        
        [LoadingManager hide];
        
        [MessageManager showMessage:@"Load Merchant data Fail" Type:TSMessageNotificationTypeError];
        
    }];
}
#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([[segue identifier] isEqualToString:@"package_details_merchant"]) {
        
        MerchantProfileViewController *vc = [segue destinationViewController];
        
        [vc setUpMerchantProfileWithRequestGuide:merchantProfileModel];
        
        
    }
}

-(IBAction)showPromptToLogin
    {
        
        
        UIAlertController * alert=   [UIAlertController
                                      alertControllerWithTitle:@"You need to login first"
                                      message:@""
                                      preferredStyle:UIAlertControllerStyleAlert];
        
        
        UIAlertAction* ok = [UIAlertAction
                             actionWithTitle:@"OK"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 
                                 
                                 [Utils showRegisterPage];
                                 
                             }];
        [alert addAction:ok]; // add action to uialertcontroller
        
        UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
        [alert addAction:cancel];
        
        
        [self presentViewController:alert animated:YES completion:nil];
        
        
    }


- (NSDateFormatter *)timeFormatter
{
    static NSDateFormatter *dateFormatter;
    if(!dateFormatter){
        dateFormatter = [NSDateFormatter new];
        dateFormatter.dateFormat = @"HHmm";
    }
    
    return dateFormatter;
}


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

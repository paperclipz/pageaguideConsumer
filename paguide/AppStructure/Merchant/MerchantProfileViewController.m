//
//  MerchantProfileViewController.m
//  paguide
//
//  Created by Evan Beh on 03/03/2017.
//  Copyright © 2017 Evan Beh. All rights reserved.
//

#import "MerchantProfileViewController.h"
#import "MerchantProfileTableViewCell.h"
#import "HeaderView.h"
#import "GalleryTableViewCell.h"
#import "MWPhotoBrowser.h"
#import "ReviewModel.h"
#import "ReviewViewController.h"
#import "RequestGuideViewController.h"

#define cell_about @"About"
#define cell_detail @"Detail"
#define cell_review @"Review"
#define cell_gallery @"Gallery"

#define cell_detail_specialty @"Specialty"
#define cell_detail_qualifications @"qualifications"
#define cell_detail_language @"Language"


@interface MerchantProfileViewController () <UITableViewDataSource, UITableViewDelegate,MWPhotoBrowserDelegate>
{
    NSArray* arrCellList;
    
    NSArray* arrCellDetailList;

    BOOL isPackageBookmarked;

    BOOL isNeedRequestGuide;
}
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constBottomHeight_tblView;
@property (weak, nonatomic) IBOutlet UILabel *lblRating;
@property (weak, nonatomic) IBOutlet UIView *ibRatingContentView;
@property (weak, nonatomic) IBOutlet UILabel *lblMerchantName;
@property (weak, nonatomic) IBOutlet UIImageView *ibMerchantCoverPhoto;

@property (weak, nonatomic) IBOutlet UILabel *lblNumberOfReviews;
@property (weak, nonatomic) IBOutlet UIImageView *ibMerchantProfileView;
@property (weak, nonatomic) IBOutlet UITableView *ibTableView;

@property (strong,nonatomic)NSArray* arrImageList;
@property (strong,nonatomic)NSMutableArray* arrMWImageList;
@property (strong,nonatomic)MerchantProfileModel* merchantProfileModel;
@property (strong,nonatomic)RatingView* ratingView;
@property (weak, nonatomic) IBOutlet UIButton *btnRequestClicked;


@end

@implementation MerchantProfileViewController

#pragma mark - IBACTION
- (IBAction)btnBookmarkClicked:(id)sender {
    
        [self requestServerForMerchantFovourite:^{
    
            [self changeItemBarBookedmarked:self.merchantProfileModel.isFavourite];
            
            if (self.didUpdateMerchantProfileBlock) {
                self.didUpdateMerchantProfileBlock(self.merchantProfileModel);
            }
        }];
}

-(void)setUpMerchantProfile:(MerchantProfileModel*)model
{
    self.merchantProfileModel = model;
    
    isNeedRequestGuide = NO;

    self.title = self.merchantProfileModel.username;

}

-(void)setUpMerchantProfileWithRequestGuide:(MerchantProfileModel*)model
{
    self.merchantProfileModel = model;

    isNeedRequestGuide = YES;
    
    self.title = self.merchantProfileModel.username;
}

- (IBAction)btnRequestClicked:(id)sender {
    
    [self performSegueWithIdentifier:@"request_guide_merchant" sender:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;

    arrCellList = @[cell_about,cell_detail,cell_review];

    arrCellDetailList = @[cell_detail_language];
    
    self.ibTableView.estimatedRowHeight = 120.0f;
    
    self.ibTableView.dataSource = self;
    
    self.ibTableView.delegate   = self;
    
    self.ibTableView.rowHeight = UITableViewAutomaticDimension;
    
    [self.ibMerchantProfileView sd_setImageWithURL:[NSURL URLWithString:self.merchantProfileModel.profile_img] placeholderImage:AVATAR_PLACEHOLDER];
    
    
    [self.ibMerchantCoverPhoto sd_setImageWithURL:[NSURL URLWithString:self.merchantProfileModel.cover_img] placeholderImage:PHOTO_PLACEHOLDER];
    
    
    self.lblRating.text = [NSString stringWithFormat:@"%@ Out Of 5",self.merchantProfileModel.overall_rating?self.merchantProfileModel.overall_rating:@"0.0"];
    
    self.lblMerchantName.text  = self.merchantProfileModel.name?self.merchantProfileModel.name:self.merchantProfileModel.username;
    
    self.lblNumberOfReviews.text = [NSString stringWithFormat:@"%@ review(s)",@(self.merchantProfileModel.reviews.count)];
    
    
    [Utils setRoundBorder: self.ibMerchantProfileView color:[UIColor clearColor] borderRadius:self.ibMerchantProfileView.frame.size.height/2];
    [self setUpRatingView];
    
    [self.ratingView setupRatingOutOfFive:round([self.merchantProfileModel.overall_rating doubleValue])];
    
  //  [self.ibTableView registerClass:[GalleryTableViewCell class] forCellReuseIdentifier:@"gallery_cell"];
    
    [self.btnRequestClicked setDefaultBorder];
    
    [self.btnRequestClicked setTitle:@"Request Guide" forState:UIControlStateNormal];
    
    
    if (isNeedRequestGuide) {
        self.constBottomHeight_tblView.constant = 70.0f;
        
    }
    else{
        self.constBottomHeight_tblView.constant = 0.0f;

    }
    
    [self changeItemBarBookedmarked:self.merchantProfileModel.isFavourite];
}


-(void)setUpRatingView
{
    if (self.ibRatingContentView) {
        [self.ibRatingContentView addSubview:self.ratingView];
        
        self.ratingView.frame = CGRectMake(0, 0, self.ibRatingContentView.frame.size.width, self.ibRatingContentView.frame.size.height);
        
        self.ibRatingContentView.backgroundColor = [UIColor clearColor];
    }
    
    [self.ratingView setupRatingOutOfFive:1];

}

-(RatingView*)ratingView
{
    if (!_ratingView) {
        _ratingView = [RatingView initializeCustomView];
        
        _ratingView.hightlightTintColor = [UIColor whiteColor];
        _ratingView.backgroundColor = [UIColor clearColor];
        
    }
    
    return _ratingView;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    NSString* type = arrCellList[section];

    
    UIView* view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"header_cell"];
    
    if (!view) {
        
        view = [HeaderView initializeCustomView];
        
    }
    
    HeaderView* headerView = (HeaderView*)view;
    
    headerView.lblTitle1.text = type;
    
    headerView.lblTitle2.text = @"More";

    headerView.lblTitle2.textColor = APP_MAIN_COLOR;

    headerView.lblTitle2.hidden = YES;

    if ([type isEqualToString:cell_review]) {
        
        
        
        if (self.merchantProfileModel.reviews.count >= 3) {
            headerView.lblTitle2.hidden = NO;

        }
        else{
            headerView.lblTitle2.hidden = YES;

        }

        
    }
    
    headerView.didSelectBlock = ^(void)
    {
      
        if ([type isEqualToString:cell_review]) {
            
            [self performSegueWithIdentifier:@"merchant_review" sender:self];
        }
    };
    
    return view;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30.0f;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    NSString* type = arrCellList[indexPath.section];
    
    if ([type isEqualToString:cell_about]) {
        
        return UITableViewAutomaticDimension;

    }else  if ([type isEqualToString:cell_review]) {
        
        return UITableViewAutomaticDimension;

    } else  if ([type isEqualToString:cell_gallery]) {
        
        return 100.0f;

    }
    else  if ([type isEqualToString:cell_detail]) {
        
        return UITableViewAutomaticDimension;
        
    }

    
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return arrCellList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString* type = arrCellList[section];
    
    if ([type isEqualToString:cell_about]) {
        
        return 1;
    }else  if ([type isEqualToString:cell_review]) {
        
        return self.merchantProfileModel.reviews.count >= 3 ? 3 : self.merchantProfileModel.reviews.count;
        
    } else  if ([type isEqualToString:cell_gallery]) {
        
        return 1;
        
    }
    else  if ([type isEqualToString:cell_detail]) {
        
        return arrCellDetailList.count;
        
    }
    

    return 0;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* type = arrCellList[indexPath.section];
    
    if ([type isEqualToString:cell_about]) {
        MerchantProfileTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"merchant_about"];
        
        cell.lblTitle1.text = self.merchantProfileModel.desc;
        
        return cell;
        
    }
    else  if ([type isEqualToString:cell_detail]) {
        
        MerchantProfileTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"merchant_detail"];
        
        NSString* detail_type = arrCellDetailList[indexPath.row];

        NSString* string1 = [NSString stringWithFormat:@"%@ : ",detail_type];
        
        NSString* string2;
        
        if ([detail_type isEqualToString:cell_detail_language]) {
            
            string2 = [self.merchantProfileModel.language componentsJoinedByString:@","];
        }
        else if ([detail_type isEqualToString:cell_detail_specialty]){
            string2 = [self.merchantProfileModel.specialty componentsJoinedByString:@","];
            
        }
        
        else if ([detail_type isEqualToString:cell_detail_qualifications])
        {
            string2 = [self.merchantProfileModel.qualifications componentsJoinedByString:@","];
            
        }
        
        if ([Utils isStringNull:string2]) {
            string2 = @"-";
        }
        
        cell.lblTitle1.attributedText = [self convertAttributedStringFor:[NSString stringWithFormat:@"%@ %@",string1,string2] StringToChange:string1];;
        
        return cell;
    }
    else  if ([type isEqualToString:cell_review]) {
        
        MerchantProfileTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"merchant_review"];
        
        
        ReviewModel* rModel = self.merchantProfileModel.reviews[indexPath.row];
        
        cell.lblDesc2.text = rModel.reviews;
        
        cell.lblDesc1.text = rModel.user_name;
        
        [cell.ratingView setupRatingOutOfFive:round([rModel.rate doubleValue])];
        
        return cell;
    }
    else  if ([type isEqualToString:cell_gallery]) {
        
        GalleryTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"merchant_gallery"];
        
        [cell setupImageList:self.arrImageList];
        
        
        cell.didSelectAtIndexBlock = ^(int index)
        {
            [self showGalleryView:index];
        };
        
        return cell;
    }
  
    return nil;
}

-(void)showGalleryView:(NSInteger)index
{
    
    
    self.arrMWImageList = [NSMutableArray new];
    
    for (int i = 0; i<self.arrImageList.count; i++) {
        
        [self.arrMWImageList addObject:[MWPhoto photoWithURL:[NSURL URLWithString:self.arrImageList[i]]]];
        
    }
    
    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    
    // Set options
    browser.displayActionButton = YES; // Show action button to allow sharing, copying, etc (defaults to YES)
    browser.displayNavArrows = NO; // Whether to display left and right nav arrows on toolbar (defaults to NO)
    browser.displaySelectionButtons = NO; // Whether selection buttons are shown on each image (defaults to NO)
    browser.zoomPhotosToFill = YES; // Images that almost fill the screen will be initially zoomed to fill (defaults to YES)
    browser.alwaysShowControls = NO; // Allows to control whether the bars and controls are always visible or whether they fade away to show the photo full (defaults to NO)
    browser.enableGrid = YES; // Whether to allow the viewing of all the photo thumbnails on a grid (defaults to YES)
    browser.startOnGrid = NO; // Whether to start on the grid of thumbnails instead of the first photo (defaults to NO)
    browser.autoPlayOnAppear = NO; // Auto-play first video
    
    // Customise selection images to change colours if required
    
    // Optionally set the current visible photo before displaying
    [browser setCurrentPhotoIndex:index];
    
    // Present
    
   // [self presentViewController:browser animated:YES completion:nil];
    
    [self.navigationController pushViewController:browser animated:YES];
    
}


- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser
{
    return self.arrMWImageList.count;
    
}
- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index
{
    return self.arrMWImageList[index];
}

-(NSMutableAttributedString*)convertAttributedStringFor:(NSString*)fullString StringToChange:(NSString*)substring
{
    
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:fullString];
    
    NSRange string1_range1 = [attributeString.string rangeOfString:substring];
    
    [attributeString addAttribute:NSFontAttributeName
                            value:[UIFont fontWithName:@"Helvetica-Bold" size:15.0]
                            range:string1_range1];
    
    
    [attributeString addAttribute:NSForegroundColorAttributeName
                            value:[UIColor darkGrayColor]
                            range:string1_range1];
    
    return attributeString;
}

#pragma mark - Bookmark

-(void)changeItemBarBookedmarked:(BOOL)isBookmarked
{
    
    if (isBookmarked) {
        UIImage* image = [[UIImage imageNamed:@"icons8-bookmark"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        
        UIBarButtonItem* editButton = [[UIBarButtonItem alloc]initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(btnBookmarkClicked:)];
        
        editButton.tintColor = APP_MAIN_COLOR;
        
        self.navigationItem.rightBarButtonItems = [NSArray arrayWithObject:editButton];
        
    }
    else{
        
        UIImage* image = [[UIImage imageNamed:@"icons8-bookmark"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        
        UIBarButtonItem* editButton = [[UIBarButtonItem alloc]initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(btnBookmarkClicked:)];
        
        editButton.tintColor = [UIColor darkGrayColor];
        
        self.navigationItem.rightBarButtonItems = [NSArray arrayWithObject:editButton];
        
    }
    
}


#pragma mark - Request Server
+(void)requestServerForMerchantID:(NSString*)merchantID Completion:(NSDictionaryBlock)completion Fail:(NSDictionaryBlock)failure
{
    
    NSString* token = [Utils getToken];
   
    NSDictionary* dict = @{@"merchant_id" : IsNullConverstion(merchantID)};
    
    NSMutableDictionary* mDict = [NSMutableDictionary new];
    
    [mDict addEntriesFromDictionary:dict];
    
    if (![Utils isStringNull:token]) {
        
        NSDictionary* dictToken = @{@"token" : IsNullConverstion(token)};
        
        [mDict addEntriesFromDictionary:dictToken];

    }
    
    [ConnectionManager requestServerWith:AFNETWORK_POST serverRequestType:ServerRequestTypePostMerchantDetails parameter:mDict appendString:nil success:^(id object) {
        
        if (completion) {
            completion(object);
        }
    } failure:^(id object) {
        
        if (failure) {
            failure(object);
        }
    }];
}

-(void)requestServerForMerchantFovourite:(VoidBlock)completion
{
    
    NSString* token = [Utils getToken];
    
    NSDictionary* dict = @{@"merchant_id" : IsNullConverstion(self.merchantProfileModel.merchant_id),
                           @"token" : IsNullConverstion(token),
                        };
    
    [ConnectionManager requestServerWith:AFNETWORK_POST serverRequestType:ServerRequestTypePostMerchantFavourite parameter:dict appendString:nil success:^(id object) {
        
        NSError* error;

        BaseModel* bModel = [[BaseModel alloc]initWithDictionary:object error:&error];
        
        if ([bModel.status_code  isEqual: @(211)]) {//fav
            
            self.merchantProfileModel.isFavourite = YES;
        }
        else if ([bModel.status_code  isEqual: @(212)]) {//un-fav
            
            self.merchantProfileModel.isFavourite = NO;
            
        }
        if (completion) {
            completion();
        }
    } failure:^(id object) {
      
        NSError* error;

        BaseModel* bModel = [[BaseModel alloc]initWithDictionary:object error:&error];

        [MessageManager showMessage:bModel.generalMessage Type:TSMessageNotificationTypeError inViewController:self];
        
    }];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([[segue identifier] isEqualToString:@"merchant_review"]) {
        
        ReviewViewController* reviewController = [segue destinationViewController];
        
        reviewController.arrReviews = self.merchantProfileModel.reviews;
        
    }    if ([[segue identifier] isEqualToString:@"request_guide_merchant"]) {

        
        RequestGuideViewController* requestGuideVC = [segue destinationViewController];
        
        requestGuideVC.title = self.merchantProfileModel.username;
        
        [requestGuideVC setupDataWithMerchantID:self.merchantProfileModel.merchant_id];
    }
    
    
}


@end

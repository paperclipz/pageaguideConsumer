//
//  TourGuideListingViewController.m
//  paguide
//
//  Created by Evan Beh on 02/05/2017.
//  Copyright © 2017 Evan Beh. All rights reserved.
//

#import "TourGuideListingViewController.h"
#import "TourGuideProfileCollectionViewCell.h"
#import "MechantListWrapperModel.h"
#import "MerchantProfileModel.h"
#import "FilterTourGuideViewController.h"
#import "MerchantProfileViewController.h"

#define PER_PAGE @"50"

@interface TourGuideListingViewController () <UICollectionViewDelegate, UICollectionViewDataSource>
{
    NSString* strFilter;

}
@property (weak, nonatomic) IBOutlet UISearchBar *ibSearchBar;
@property (weak, nonatomic) IBOutlet UICollectionView *ibCollectionView;
@property (nonatomic) PagingViewModel* vm_package_paging;
@property (nonatomic) NSMutableArray* arrMerchantList;
@property (nonatomic) MerchantProfileViewController* merchantProfileViewController;

@property  (nonatomic)UIRefreshControl* refreshControl;

@property  (nonatomic,assign)MERCHANT_LISTING_TYPE viewType;

@end

@implementation TourGuideListingViewController

- (void)refreshControl:(id)sender {
   

    [self resetAndCallMerchantListing];
}


-(void)resetAndCallMerchantListing
{
    _vm_package_paging = nil;
    
    [self.arrMerchantList removeAllObjects];
    
    self.arrMerchantList = nil;
    
    [self.ibCollectionView reloadData];
    
    
    
    if (self.viewType == MERCHANT_LISTING_TYPE_FAVOURITE) {
        [self requestServerForFavouriteMerchantListing];
    }
    else{
        [self requestServerForMerchantListing];

    }
    
}

-(void)awakeFromNib
{
    [super awakeFromNib];
    
    self.viewType = MERCHANT_LISTING_TYPE_NORMAL;

}

-(void)setupFavouriteTourGuideScreen
{
    self.viewType = MERCHANT_LISTING_TYPE_FAVOURITE;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;

    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self
                            action:@selector(refreshControl:)
                  forControlEvents:UIControlEventValueChanged];
    
    [self.ibCollectionView addSubview:self.refreshControl];
  
    self.ibCollectionView.alwaysBounceVertical = YES;

    
    if (self.viewType == MERCHANT_LISTING_TYPE_NORMAL) {
        [self requestServerForMerchantListing];

    }
    else{
        [self requestServerForFavouriteMerchantListing];

    }

        // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    // Dispose of any resources that can be recreated.
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    return self.arrMerchantList.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    TourGuideProfileCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"tour_guide_profile" forIndexPath:indexPath];
    
    MerchantProfileModel* profile = self.arrMerchantList[indexPath.row];
    
    
    cell.lblTitle.text = profile.username;
    
    cell.lblDesc.text = @"-";
    
    
    [cell.ibImageView sd_setImageWithURL:[NSURL URLWithString:profile.profile_img] placeholderImage:AVATAR_PLACEHOLDER];
    
    [cell.ratingView setupRatingOutOfFive:round([profile.overall_rating doubleValue])];
    
    
return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    MerchantProfileModel* mModel = self.arrMerchantList[indexPath.row];
    
    _merchantProfileViewController = nil;
    
    [LoadingManager show];
    
    [MerchantProfileViewController requestServerForMerchantID:mModel.merchant_id Completion:^(NSDictionary *dict) {
        
        [LoadingManager hide];

        MerchantProfileModel* model = [[MerchantProfileModel alloc]initWithDictionary:dict[@"data"] error:nil];
        
        [self.merchantProfileViewController setUpMerchantProfileWithRequestGuide:model];
        
        [self.navigationController pushViewController:self.merchantProfileViewController animated:YES];
        
    } Fail:^(NSDictionary *dict) {
        
        [LoadingManager hide];

        [MessageManager showMessage:@"Load Merchant data Fail" Type:TSMessageNotificationTypeError];

    }];
    
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout  *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
  
    CGRect frame = [Utils getWindowFrame];
    
    float padding = 10.0f;
    
    float size = (frame.size.width/3) - padding - padding;
    
    return CGSizeMake(size, 200.0f);
}


-(void)requestServerForMerchantListing
{
    
    if (self.vm_package_paging.isLoading || !self.vm_package_paging.hasNext) {
        return;
        
    }
    
    self.vm_package_paging.isLoading = YES;
    
    NSDictionary* dict = @{@"per_page" : PER_PAGE,
                           @"page" : @(self.vm_package_paging.currentPage + 1),
                           };
    
    NSMutableDictionary* mDict = [[NSMutableDictionary alloc]initWithDictionary:dict];
    
    if (![Utils isStringNull:strFilter]) {
        [mDict addEntriesFromDictionary:@{@"filter" : IsNullConverstion(strFilter)}];
    }
    
    if (self.vm_package_paging.currentPage == 0) {
        [LoadingManager show];
    }

    
    [ConnectionManager requestServerWith:AFNETWORK_POST serverRequestType:ServerRequestTypePostMerchantListing parameter:mDict appendString:nil success:^(id object) {
        
        [LoadingManager hide];
        
        self.vm_package_paging.isLoading = NO;

        MechantListWrapperModel* wModel = [[MechantListWrapperModel alloc]initWithDictionary:object error:nil];
        
        [self.vm_package_paging processPagingFrom:wModel.pageContent];

        [self.arrMerchantList addObjectsFromArray:wModel.arrMerchantList];
        
        [self.refreshControl endRefreshing];
        
        [self.ibCollectionView reloadData];
        
    } failure:^(id object) {
        
        self.vm_package_paging.isLoading = NO;

        [LoadingManager hide];
        
        [self.refreshControl endRefreshing];

    }];
}

-(void)requestServerForFavouriteMerchantListing
{
    
    if (self.vm_package_paging.isLoading || !self.vm_package_paging.hasNext) {
        return;
        
    }
    
    self.vm_package_paging.isLoading = YES;
    
    NSString* token = [Utils getToken];
    
    NSDictionary* dict = @{@"token" : IsNullConverstion(token),
                           };


    [LoadingManager show];

    
    [ConnectionManager requestServerWith:AFNETWORK_POST serverRequestType:ServerRequestTypePostMerchantFavouriteListing parameter:dict appendString:nil success:^(id object) {
        
        [LoadingManager hide];
        
        self.vm_package_paging.isLoading = NO;
        
        NSError* error;
        
        self.arrMerchantList = [MerchantProfileModel arrayOfModelsFromDictionaries:object[@"data"] error:&error];
        
        [self.refreshControl endRefreshing];
        
        [self.ibCollectionView reloadData];
        
    } failure:^(id object) {
        
        self.vm_package_paging.isLoading = NO;
        
        [LoadingManager hide];
        
        [self.refreshControl endRefreshing];
        
    }];
}

-(void)resetAndCallMerchantListingWithFilter:(NSString*)filter
{
    _vm_package_paging = nil;
    
    strFilter = filter;
    
    [self.arrMerchantList removeAllObjects];
    
    self.arrMerchantList = nil;
    
    [self.ibCollectionView reloadData];
    
    [self requestServerForMerchantListing];
    
}

#pragma mark - Declaration

-(PagingViewModel*)vm_package_paging
{
    if (!_vm_package_paging) {
        _vm_package_paging = [PagingViewModel new];
    }
    
    return _vm_package_paging;
}


-(NSMutableArray*)arrMerchantList
{
    if (!_arrMerchantList) {
        _arrMerchantList = [NSMutableArray new];
        
    }
    
    return _arrMerchantList;
}


-(MerchantProfileViewController*)merchantProfileViewController
{
    if (!_merchantProfileViewController) {
        
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        _merchantProfileViewController = [storyboard instantiateViewControllerWithIdentifier:@"sb_merchant_profile"];
        
    }
    
    return _merchantProfileViewController;
}
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([[segue identifier] isEqualToString:@"merchant_filter"]) {
        
        UINavigationController* nav = [segue destinationViewController];

        FilterTourGuideViewController* vc = nav.viewControllers[0];
        
        vc.didSubmitFilterBlock = ^(NSString* string)
        {
            [self resetAndCallMerchantListingWithFilter:string];
        };
    }
    
    
    
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView.contentOffset.y == scrollView.contentSize.height - scrollView.frame.size.height)
    {
        //LOAD MORE
        // you can also add a isLoading bool value for better dealing :D
        
            if (self.vm_package_paging.hasNext) {
                
                
                [self requestServerForMerchantListing];
            }
            
    }
}




@end

//
//  DashboardPackageViewController.m
//  paguide
//
//  Created by Evan Beh on 01/03/2017.
//  Copyright © 2017 Evan Beh. All rights reserved.
//

#import "DashboardPackageViewController.h"
#import "DashboardPackageTableViewCell.h"
#import "CalenderViewController.h"
#import "PackageDetailsViewController.h"
#import "RatingViewController.h"
#import "PackageWrapperModel.h"
#import "DashboardPackageFilterViewController.h"
#import "UpdateViewController.h"
#import "OfflineManager.h"

#import "RequestGuideViewController.h"
#import "MyRequestListingViewController.h"
#import "AppointmentListViewController.h"
#import "AppointmentPageViewController.h"
@import Intercom;

#define PER_PAGE @"10"
@interface DashboardPackageViewController () <UITableViewDelegate,UITableViewDataSource, UITabBarControllerDelegate>
{
    PackageModel* selectedPackageModel;
    
    NSString* strFilter;
}

@property (nonatomic) PagingViewModel* vm_package_paging;
@property (nonatomic) NSMutableArray<PackageModel>* arrPackageList;

@property (weak, nonatomic) IBOutlet UITableView *ibTableView;
@property (weak, nonatomic) IBOutlet UIButton *btnFilter;


@end

@implementation DashboardPackageViewController
- (IBAction)btnIntercomClicked:(id)sender {
   
     [Intercom presentConversationList];

}


-(NSDictionary*)getPacakgeJson
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"package" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    
    
    return json;
}

- (IBAction)btnFilterClicked:(id)sender {
}
- (IBAction)btnLoginClicked:(id)sender {
    
  
    [Utils showRegisterPage];
}
- (IBAction)btnTest2Clicked:(id)sender {
 
}

-(void)viewWillAppear:(BOOL)animated
{
 
 
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [Utils checkIsNeedUpateApp:^(NSString* urlString){
        
        UpdateViewController* uVC = [UpdateViewController new];
        
        uVC.updateURL = urlString;
        
        [self presentViewController:uVC animated:YES completion:^{
            
        }];
        
    } NoNeedUpdate:^{
       
        
        if (![Utils isUserLogin]) {
            
            [Utils showRegisterPage];
        }
    }];
    
   
    
    
    [self initSelfView];

    [self requestServerForPackageListing];

    
    [self.ibTableView setupFooterView];
    
    [self.ibTableView pullToRefresh:^{
        
        [self resetAndCallPackageListing];
      
    }];

    
    if (![Utils isUserLogin]) {
        
        [Intercom registerUnidentifiedUser];
    }
    else{
        
        [DataManager getUserProfile:^(ProfileModel *pModel) {
            
            [Intercom registerUserWithEmail:pModel.email];
        }];
    }
    
    
    UITableView *view = (UITableView *)self.tabBarController.moreNavigationController.topViewController.view;
    if ([[view subviews] count]) {
        for (UITableViewCell *cell in [view visibleCells]) {
            cell.textLabel.textColor = [UIColor darkGrayColor];
            
            [cell.textLabel setFont:[UIFont systemFontOfSize:15.0f]];
        }
    }
    // Do any additional setup after loading the view.
}

-(void)resetAndCallPackageListing
{
    _vm_package_paging = nil;
    
    strFilter = @"";
    
    [self.arrPackageList removeAllObjects];
    
    self.arrPackageList = nil;
    
    [self.ibTableView reloadData];

    
    [self requestServerForPackageListing];

}

-(void)resetAndCallPackageListingWithFilter:(NSString*)filter
{
    _vm_package_paging = nil;
    
    strFilter = filter;
    
    [self.arrPackageList removeAllObjects];
    
    self.arrPackageList = nil;
    
    [self.ibTableView reloadData];
    
    [self requestServerForPackageListing];
    
}

-(void)initSelfView
{
    
    [self.btnFilter setDefaultBorder];
    [Utils setRoundBorder:self.btnFilter color:[UIColor clearColor] borderRadius:self.btnFilter.frame.size.height/2];

    self.btnFilter.layer.shadowColor = [UIColor blackColor].CGColor;
    self.btnFilter.layer.shadowOpacity = 0.5;
    self.btnFilter.layer.shadowRadius = 1;
    self.btnFilter.layer.shadowOffset = CGSizeMake(5.0f, 5.0f);
    
    self.tabBarController.delegate = self;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrPackageList.count;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DashboardPackageTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"dashPackageCell"];
    
    PackageModel* model = self.arrPackageList[indexPath.row];
    
    
    [self setupPackageInCell:cell With:model];
//    
//    [cell.ibImageView sd_setImageWithURL:[NSURL URLWithString:@"http://www.mediastinger.com/wp-content/uploads/2016/02/Batman-v-Superman-Final-Trailer-hq.jpg"]];
//    
//    cell.lblTitle1.text = @"badman vs superman";
//    
//
//    NSString* string2 = @"RM 89.90 72.00 | save 13.50";
//    
//    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:string2];
//    
//    NSRange string2_range1 = [attributeString.string rangeOfString:@"RM 89.90"];
//    NSRange string2_range2 = [attributeString.string rangeOfString:@"72.00"];
//
//    
//    
//    [attributeString addAttribute:NSStrikethroughStyleAttributeName
//                            value:@2
//                            range:string2_range2];
//    
//    
//
//    [attributeString addAttribute:NSFontAttributeName
//                   value:[UIFont fontWithName:@"Helvetica-Bold" size:12.0]
//                   range:string2_range1];
//  
//    
//    [attributeString addAttribute:NSForegroundColorAttributeName
//                            value:[UIColor redColor]
//                            range:string2_range1];
//    
//
//    
//    cell.lblTitle2.attributedText = attributeString;
//    
//    cell.lblTitle3.text = @"Travel sdn Bhd";
//    
//    cell.lblTitle4.text = @"GOGO";
//    
//    cell.lblTitle5.text = @"2 slot left";
//    
    return cell;
}

-(void)setupPackageInCell:(DashboardPackageTableViewCell*)cell With:(PackageModel*)model
{
    cell.lblTitle2.text = model.name;
    
    cell.lblTitle1.text = [NSString stringWithFormat:@"%@ %@",model.currency, model.price];
    
    cell.lblTitle3.text = model.mode;

    [cell.ibImageView sd_setImageWithURL:[NSURL URLWithString:model.listing_img]];

    cell.lblTitle4.text = model.category;
    
    [cell.ratingView setupRatingOutOfFive:round([model.ratings doubleValue])];

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    selectedPackageModel = self.arrPackageList[indexPath.row];
    
    [self performSegueWithIdentifier:@"package_details" sender:self];
}

#pragma mark - Navigation



- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(nullable id)sender{
    
    if ([identifier isEqualToString:@"profile_detail"]) {
    
        if (![Utils isUserLogin]) {
            
            
            [self showPromptToLogin];
            return NO;
        }
      
    }

    return YES;

}
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([[segue identifier] isEqualToString:@"package_details"]) {
        
        PackageDetailsViewController *vc = [segue destinationViewController];
        
        vc.viewType = PACKAGE_VIEW_TYPE_AVAILABILIY;
        
        [vc setupPackageID:selectedPackageModel.packages_id];

    }else    if ([[segue identifier] isEqualToString:@"filter"]) {
        
        UINavigationController *navC = [segue destinationViewController];
        
        DashboardPackageFilterViewController* vc = navC.viewControllers[0];
        
        vc.didSubmitFilterBlock = ^(NSString* filterSTr)
        {
            [self resetAndCallPackageListingWithFilter:filterSTr];
        };
        
    }
    
    
}

#pragma mark - Declaration


-(NSMutableArray<PackageModel>*)arrPackageList{
    
    if (!_arrPackageList) {
        _arrPackageList = (NSMutableArray<PackageModel>*)[NSMutableArray new];
    }
    
    return _arrPackageList;
}

-(PagingViewModel*)vm_package_paging
{
    if (!_vm_package_paging) {
        _vm_package_paging = [PagingViewModel new];
    }
    
    return _vm_package_paging;
}


#pragma mark - Request Server

-(void)requestServerForPackageListing
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
    
    [ConnectionManager requestServerWith:AFNETWORK_POST serverRequestType:ServerRequestTypePostPackageListing parameter:mDict appendString:nil success:^(id object) {
        
        
        self.vm_package_paging.isLoading = NO;
        
        NSError* error;
        
        PackageWrapperModel* model = [[PackageWrapperModel alloc]initWithDictionary:object error:&error];
        
        [self.vm_package_paging processPagingFrom:model.pageContent];
      
        [self.ibTableView stopRefresh];
        
        [self.arrPackageList addObjectsFromArray:model.arrPackageList];
        
        [self.ibTableView reloadData];
        
        [self.ibTableView stopFooterLoadingView];
        
        [LoadingManager hide];
        
        
    } failure:^(id object) {
        
        
        self.vm_package_paging.isLoading = NO;

        [self.ibTableView stopRefresh];
        
        [self.ibTableView stopFooterLoadingView];

        [LoadingManager hide];


    }];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    [self.ibTableView scrollViewDidScroll:scrollView activated:^{
    
        if (self.vm_package_paging.hasNext) {
            
            if ([[self.ibTableView visibleCells]count]>0) {
               
                [self.ibTableView startFooterLoadingView];
            }
            
            [self requestServerForPackageListing];
        }
        
    }];
    

}// any offset changes

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

#pragma mark - UItabbarcontroller delegate

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    
    UIViewController* tempViewController;
    
    if ([viewController isKindOfClass:[UINavigationController class]]) {
        
        UINavigationController* navigationContoller = (UINavigationController*)viewController;

        tempViewController = navigationContoller.viewControllers[0];
    }
    
    else{
        tempViewController = viewController;
    }
    if ([Utils isUserLogin]) {
        
        return YES;
    }
    else
    {
        if ([tempViewController isKindOfClass:[RequestGuideViewController class]] ||
            [tempViewController isKindOfClass:[MyRequestListingViewController class]] ||
            [tempViewController isKindOfClass:[AppointmentListViewController class]] ||
            [tempViewController isKindOfClass:[AppointmentPageViewController class]]
            ) {
            
            
            [self showPromptToLogin];
            
            return NO;
            
            
        }
        else
        {
            return YES;
        }
    }
   
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{

}

@end

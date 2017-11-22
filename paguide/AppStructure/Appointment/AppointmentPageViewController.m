//
//  AppointmentPageViewController.m
//  paguide
//
//  Created by Evan Beh on 07/04/2017.
//  Copyright © 2017 Evan Beh. All rights reserved.
//

#import "AppointmentPageViewController.h"
#import "AppointmentListViewController.h"
#import "HistoryListViewController.h"
#import "MyRequestListingViewController.h"
#import "PendingPackageListViewController.h"
#import "ProfileViewController.h"

@import Intercom;

@interface AppointmentPageViewController () <MXSegmentedPagerDelegate, MXSegmentedPagerDataSource>

@property (nonatomic,strong)AppointmentListViewController* appointmentListViewController;
@property (nonatomic,strong)HistoryListViewController* historyListViewController;
@property (nonatomic,strong)MyRequestListingViewController* myRequestListingViewController;
@property (nonatomic,strong)PendingPackageListViewController* pendingPackageListViewController;
@property (nonatomic)ProfileViewController* profileViewController;


@property (nonatomic, strong)NSArray* arrViewControllers;
@end

@implementation AppointmentPageViewController

- (IBAction)btnProfileClicked:(id)sender {
    
    _profileViewController = nil;

    [self.navigationController pushViewController:self.profileViewController animated:YES];
}


- (IBAction)btnIntercomClicked:(id)sender {
    
    [Intercom presentMessageComposer];
    
}

-(void)setIsNeedReload:(BOOL)isNeedReload
{
    
    if (isNeedReload) {
      
        
        for (int i = 0; i<self.arrViewControllers.count; i++) {
            
            UIViewController* vc = self.arrViewControllers[i];
            
            
            if ([vc isKindOfClass:[BaseViewController class]]) {
                
                BaseViewController* bVC = (BaseViewController*)vc;
                
                bVC.isNeedReload = isNeedReload;
            }
            
        }
        
        
    }
        _isNeedReload = NO;

}

-(void)setIsNeedReset:(BOOL)isNeedReset
{
    
    if (isNeedReset) {
        
        
        for (int i = 0; i<self.arrViewControllers.count; i++) {
            
            UIViewController* vc = self.arrViewControllers[i];
            
            
            if ([vc isKindOfClass:[BaseViewController class]]) {
                
                BaseViewController* bVC = (BaseViewController*)vc;
                
                bVC.isNeedReload = isNeedReset;
            }
            
        }
        
        [self.segmentedPager.segmentedControl setSelectedSegmentIndex:0];
        
    }
    _isNeedReset = NO;
    
}


#pragma mark - Page Setup
-(void)setupIntercom
{
    
    UIImage* image = [UIImage imageNamed:@"icon_concierge_red.png"];
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(btnIntercomClicked:)];
    
    self.navigationItem.rightBarButtonItems = @[rightButton];
    
    
}

-(void)setupProfile
{
    
    UIImage* image = [UIImage imageNamed:@"icon_profile_red.png"];
    
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(btnProfileClicked:)];
    
    self.navigationItem.leftBarButtonItems = @[leftButton];
    
    
}
- (void)setupPageMenu
{
    
    
    for (int i = 0; i<self.arrViewControllers.count; i++) {
        
        UIViewController* vc = self.arrViewControllers[i];
        
        [self addChildViewController:vc];

    }
    
    // Segmented Control customization
    self.segmentedPager.segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    self.segmentedPager.segmentedControl.borderWidth = 0.1f;
    self.segmentedPager.segmentedControl.backgroundColor = [UIColor whiteColor];
    self.segmentedPager.segmentedControl.titleTextAttributes = @{
                                                                 NSForegroundColorAttributeName : [UIColor blackColor],
                                                                 NSFontAttributeName : [UIFont boldSystemFontOfSize:10.0f]

                                                                 };
    
    self.segmentedPager.segmentedControl.selectedTitleTextAttributes = @{NSForegroundColorAttributeName : APP_MAIN_COLOR};
    self.segmentedPager.segmentedControl.selectionStyle = HMSegmentedControlSelectionStyleFullWidthStripe;
    self.segmentedPager.segmentedControl.selectionIndicatorColor = APP_MAIN_COLOR;
    
    self.segmentedPager.segmentedControlEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
}

#pragma mark - MXSegmentedPagerDelegate

- (NSInteger)numberOfPagesInSegmentedPager:(MXSegmentedPager *)segmentedPager {
    return self.arrViewControllers.count;
}

// Asks the data source for a title realted to a particular page of the segmented pager.
- (NSString *)segmentedPager:(MXSegmentedPager *)segmentedPager titleForSectionAtIndex:(NSInteger)index {
    UIViewController* vc = self.arrViewControllers[index];
    
    return vc.title;
}

// Asks the data source for a view to insert in a particular page of the pager.
- (UIView *)segmentedPager:(MXSegmentedPager *)segmentedPager viewForPageAtIndex:(NSInteger)index {
    UIViewController* vc = self.arrViewControllers[index];
    return vc.view;
    
}

-(AppointmentListViewController*)appointmentListViewController
{
    if (!_appointmentListViewController) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        _appointmentListViewController = [storyboard instantiateViewControllerWithIdentifier:@"sb_appointmentList"];
        
        _appointmentListViewController.view.tag = 0;
        _appointmentListViewController.title = [@"Appointment" uppercaseString];

    }
    
    return _appointmentListViewController;
}

-(HistoryListViewController*)historyListViewController
{
    if (!_historyListViewController) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        _historyListViewController = [storyboard instantiateViewControllerWithIdentifier:@"sb_historyList"];
        
        _historyListViewController.view.tag = 1;
        _historyListViewController.title = [@"History" uppercaseString];
    
    }
    
    return _historyListViewController;
}

-(MyRequestListingViewController*)myRequestListingViewController
{
    if (!_myRequestListingViewController) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        _myRequestListingViewController = [storyboard instantiateViewControllerWithIdentifier:@"sb_myRequestList"];
        
        _myRequestListingViewController.view.tag = 2;
        _myRequestListingViewController.title = [@"My Request" uppercaseString];
        
    }
    
    return _myRequestListingViewController;
}

-(PendingPackageListViewController*)pendingPackageListViewController
{
    if (!_pendingPackageListViewController) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        _pendingPackageListViewController = [storyboard instantiateViewControllerWithIdentifier:@"sb_pendingPackageList"];
        
        _pendingPackageListViewController.view.tag = 3;
        _pendingPackageListViewController.title = [@"Pending Package" uppercaseString];
        
    }
    
    return _pendingPackageListViewController;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setTranslucent:NO];
    
    [self.tabBarController.tabBar setTranslucent:NO];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;

    self.automaticallyAdjustsScrollViewInsets = false;
    
    self.arrViewControllers = @[self.myRequestListingViewController,
                                self.pendingPackageListViewController,
                                self.appointmentListViewController,
                                self.historyListViewController];
    
    [self setupPageMenu];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupIntercom];
    
    
    [self setupProfile];
    // Do any additional setup after loading the view.
}


#pragma mark - Declaration

-(ProfileViewController*)profileViewController
{
    if (!_profileViewController) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        _profileViewController = [storyboard instantiateViewControllerWithIdentifier:@"sb_profile"];
        
        _profileViewController.view.tag = 99;
        _profileViewController.title = [@"Profile" uppercaseString];
        
    }
    
    return _profileViewController;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

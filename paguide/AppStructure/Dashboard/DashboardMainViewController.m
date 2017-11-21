//
//  DashboardMainViewController.m
//  paguide
//
//  Created by Evan Beh on 17/11/2017.
//  Copyright © 2017 Evan Beh. All rights reserved.
//

#import "DashboardMainViewController.h"
#import "DashboardPackageViewController.h"
#import "RequestGuideViewController.h"
#import "ProfileViewController.h"


@import Intercom;

@interface DashboardMainViewController ()<MXSegmentedPagerDelegate, MXSegmentedPagerDataSource>

@property (nonatomic)DashboardPackageViewController* dashboardPackageViewController;
@property (nonatomic)RequestGuideViewController* requestGuideViewController;
@property (nonatomic)ProfileViewController* profileViewController;

@property (nonatomic, strong)NSArray* arrViewControllers;

@end

@implementation DashboardMainViewController
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

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self.navigationController.navigationBar setTranslucent:NO];
    
    [self.tabBarController.tabBar setTranslucent:NO];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.automaticallyAdjustsScrollViewInsets = false;
    
    self.arrViewControllers = @[self.dashboardPackageViewController,self.requestGuideViewController];

      [self setupPageMenu];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    // Do any additional setup after loading the view.
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


#pragma mark - Declaration
-(DashboardPackageViewController*)dashboardPackageViewController
{
    if (!_dashboardPackageViewController) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        _dashboardPackageViewController = [storyboard instantiateViewControllerWithIdentifier:@"sb_package_list"];
        
        _dashboardPackageViewController.view.tag = 0;
        _dashboardPackageViewController.title = [@"Package" uppercaseString];
        
    }
    
    return _dashboardPackageViewController;
}

-(RequestGuideViewController*)requestGuideViewController
{
    if (!_requestGuideViewController) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        _requestGuideViewController = [storyboard instantiateViewControllerWithIdentifier:@"sb_request_guide"];
        
        _requestGuideViewController.view.tag = 2;
        _requestGuideViewController.title = [@"Request" uppercaseString];
        
    }
    
    return _requestGuideViewController;
}

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

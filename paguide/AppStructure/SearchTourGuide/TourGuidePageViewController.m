//
//  TourGuidePageViewController.m
//  paguide
//
//  Created by Evan Beh on 11/05/2017.
//  Copyright © 2017 Evan Beh. All rights reserved.
//

#import "TourGuidePageViewController.h"
#import "PackageBookmarkTableViewController.h"
#import "TourGuideListingViewController.h"

@interface TourGuidePageViewController () <UIPageViewControllerDelegate,UIPageViewControllerDataSource>
{
    NSInteger currentPage;

}
@property (nonatomic)PackageBookmarkTableViewController* packageBookmarkTableViewController;
@property (nonatomic)TourGuideListingViewController* tourGuideListingViewController;

@property (nonatomic, strong)NSArray* arrViewControllers;
@property (nonatomic,strong)UISegmentedControl* segmentedControl;

@end

@implementation TourGuidePageViewController

- (void)btnSegmentedControl:(id)sender forEvent:(UIEvent *)event
{
    
    if (self.segmentedControl.selectedSegmentIndex == 0) {
        
        [self setViewControllers:@[self.packageBookmarkTableViewController] direction:UIPageViewControllerNavigationDirectionReverse animated:YES completion:nil];
        
        
        currentPage = 0;
    }
    else if(self.segmentedControl.selectedSegmentIndex == 1)
    {
        
        [self setViewControllers:@[self.tourGuideListingViewController] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
        
        currentPage = 1;
        
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = false;

    self.arrViewControllers = @[self.packageBookmarkTableViewController,self.tourGuideListingViewController];
    
    [self setViewControllers:@[self.packageBookmarkTableViewController] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:^(BOOL finished) {
        
        
    }];
    
    self.delegate = self;
    
    self.dataSource = self;
    
    [self addSegmentedControl];

    self.view.backgroundColor = [UIColor whiteColor];

    // Do any additional setup after loading the view.
}

-(void)addSegmentedControl
{
    
    self.segmentedControl = [[UISegmentedControl alloc]initWithItems:@[@"Package",@"Tour Guide"]];
    
    [self.segmentedControl addTarget:self action:@selector(btnSegmentedControl:forEvent:) forControlEvents:UIControlEventValueChanged];
    
    self.navigationItem.titleView = self.segmentedControl;
    
    self.segmentedControl.tintColor = APP_MAIN_COLOR;
    
    self.segmentedControl.selectedSegmentIndex = 0;
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(PackageBookmarkTableViewController*)packageBookmarkTableViewController
{
    if (!_packageBookmarkTableViewController) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        _packageBookmarkTableViewController = [storyboard instantiateViewControllerWithIdentifier:@"sb_bookmark_package"];
        
        _packageBookmarkTableViewController.view.tag = 0;
        
        
    }
    
    return _packageBookmarkTableViewController;
}

-(TourGuideListingViewController*)tourGuideListingViewController
{
    if (!_tourGuideListingViewController) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        _tourGuideListingViewController = [storyboard instantiateViewControllerWithIdentifier:@"sb_tour_guide_listing"];
        
        [_tourGuideListingViewController setupFavouriteTourGuideScreen];

        _tourGuideListingViewController.view.tag = 1;
        
        
    }
    
    return _tourGuideListingViewController;
}




- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    
    NSUInteger index = [[(BaseViewController *)viewController view] tag];
    
    currentPage = index;
    
    self.segmentedControl.selectedSegmentIndex = currentPage;
    
    if (index == 0) {
        return nil;
    }
    
    index--;
    
    
    return self.arrViewControllers[index];
    
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    
    NSUInteger index = [[(BaseViewController *)viewController view] tag];
    
    
    currentPage = index;
    self.segmentedControl.selectedSegmentIndex = currentPage;
    
    index++;
    
    if (index == self.arrViewControllers.count) {
        return nil;
    }
    
    return self.arrViewControllers[index];
    
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

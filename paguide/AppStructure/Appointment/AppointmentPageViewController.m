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
@interface AppointmentPageViewController () <UIPageViewControllerDelegate,UIPageViewControllerDataSource>
{
    NSInteger currentPage;
}

@property (nonatomic,strong)AppointmentListViewController* appointmentListViewController;
@property (nonatomic,strong)HistoryListViewController* historyListViewController;
@property (nonatomic,strong)UISegmentedControl* segmentedControl;

@property (nonatomic, strong)NSArray* arrViewControllers;
@end

@implementation AppointmentPageViewController




-(void)setIsNeedReload:(BOOL)isNeedReload
{
    
    if (isNeedReload) {
        self.appointmentListViewController.isNeedReload = YES;
        self.historyListViewController.isNeedReload  = YES;
        
    }
        _isNeedReload = NO;

}
- (void)btnSegmentedControl:(id)sender forEvent:(UIEvent *)event
{

    if (self.segmentedControl.selectedSegmentIndex == 0) {
        
        [self setViewControllers:@[self.appointmentListViewController] direction:UIPageViewControllerNavigationDirectionReverse animated:YES completion:nil];
        
        
        currentPage = 0;
    }
    else if(self.segmentedControl.selectedSegmentIndex == 1)
    {
        
        [self setViewControllers:@[self.historyListViewController] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];

        currentPage = 1;

    }
}

-(AppointmentListViewController*)appointmentListViewController
{
    if (!_appointmentListViewController) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        _appointmentListViewController = [storyboard instantiateViewControllerWithIdentifier:@"sb_appointmentList"];
        
        _appointmentListViewController.view.tag = 0;
        

    }
    
    return _appointmentListViewController;
}

-(HistoryListViewController*)historyListViewController
{
    if (!_historyListViewController) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        _historyListViewController = [storyboard instantiateViewControllerWithIdentifier:@"sb_historyList"];
        
        _historyListViewController.view.tag = 1;
        
    }
    
    return _historyListViewController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = false;
    
    self.arrViewControllers = @[self.appointmentListViewController,self.historyListViewController];

    [self setViewControllers:@[self.appointmentListViewController] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:^(BOOL finished) {
        
        
    }];
        
    self.delegate = self;
    
    self.dataSource = self;

    
    [self addSegmentedControl];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    // Do any additional setup after loading the view.
}

-(void)addSegmentedControl
{
    
    self.segmentedControl = [[UISegmentedControl alloc]initWithItems:@[@"Apointment",@"History"]];
    
    [self.segmentedControl addTarget:self action:@selector(btnSegmentedControl:forEvent:) forControlEvents:UIControlEventValueChanged];
    
    self.navigationItem.titleView = self.segmentedControl;
    
    self.segmentedControl.tintColor = APP_MAIN_COLOR;
    
    self.segmentedControl.selectedSegmentIndex = 0;
    
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

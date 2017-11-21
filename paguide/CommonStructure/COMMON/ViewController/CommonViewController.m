//
//  CommonViewController.m
//  paguide
//
//  Created by Evan Beh on 27/03/2017.
//  Copyright © 2017 Evan Beh. All rights reserved.
//

#import "CommonViewController.h"
#import "AppointmentPageViewController.h"
#import "DashboardMainViewController.h"

@interface CommonViewController ()

@end

@implementation CommonViewController

-(void)resetMainPage
{
    UIViewController* viewC = self.navigationController.viewControllers[0];
    
    if ([viewC isKindOfClass:[BaseViewController class]]) {
        
        BaseViewController* bVC = (BaseViewController*)viewC;
        
        bVC.isNeedReload = YES;
    }
    else if ([viewC isKindOfClass:[AppointmentPageViewController class]])
    {
        AppointmentPageViewController* bVC = (AppointmentPageViewController*)viewC;

        bVC.isNeedReload = YES;

    }
    else if ([viewC isKindOfClass:[DashboardMainViewController class]])
    {
        DashboardMainViewController* bVC = (DashboardMainViewController*)viewC;

        bVC.isNeedReload = YES;
        
    }

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.isMiddleOfLoadingPage = NO;
    // Do any additional setup after loading the view.
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

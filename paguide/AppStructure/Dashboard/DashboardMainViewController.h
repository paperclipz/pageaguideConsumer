//
//  DashboardMainViewController.h
//  paguide
//
//  Created by Evan Beh on 17/11/2017.
//  Copyright © 2017 Evan Beh. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <MXSegmentedPager/MXSegmentedPagerController.h>

@interface DashboardMainViewController : MXSegmentedPagerController

@property (nonatomic,assign)BOOL isNeedReload;

@end

//
//  AppointmentPageViewController.h
//  paguide
//
//  Created by Evan Beh on 07/04/2017.
//  Copyright © 2017 Evan Beh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MXSegmentedPager/MXSegmentedPagerController.h>

@interface AppointmentPageViewController : MXSegmentedPagerController

@property (nonatomic,assign)BOOL isNeedReload;

@property (nonatomic,assign)BOOL isNeedReset;

@end

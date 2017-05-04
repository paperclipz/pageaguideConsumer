//
//  GeneralCalenderViewController.h
//  paguide
//
//  Created by Evan Beh on 03/05/2017.
//  Copyright © 2017 Evan Beh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GeneralCalenderViewController : UIViewController

@property (nonatomic,copy)NSDateBlock didContinueWithDateBlock;
-(void)setupDateSelected:(NSDate*)date;
+ (NSDateFormatter *)dateFormatter;

@end

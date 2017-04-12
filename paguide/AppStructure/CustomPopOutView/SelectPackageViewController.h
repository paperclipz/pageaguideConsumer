//
//  SelectPackageViewController.h
//  paguide
//
//  Created by Evan Beh on 20/03/2017.
//  Copyright © 2017 Evan Beh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomPopOutViewController.h"
#import "PackageModel.h"

@interface SelectPackageViewController : CustomPopOutViewController



-(void)setuDataWithPackage:(PackageModel*)pModel SelectedDate:(NSString*)selectedDate;

@property(nonatomic,copy)ScheduleModelBlock didFinishSelectScheduleBlock;

-(void)setuDataWithPackage:(PackageModel*)pModel;

@end

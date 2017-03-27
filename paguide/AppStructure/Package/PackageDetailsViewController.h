//
//  PackageDetailsViewController.h
//  paguide
//
//  Created by Evan Beh on 06/03/2017.
//  Copyright © 2017 Evan Beh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PackageModel.h"

typedef enum
{
    PACKAGE_VIEW_TYPE_AVAILABILIY = 1,
    PACKAGE_VIEW_TYPE_PAYMENT = 2,

    
}PACKAGE_VIEW_TYPE;

@interface PackageDetailsViewController : UIViewController

@property(nonatomic, assign)PACKAGE_VIEW_TYPE viewType;

-(void)setupData:(PackageModel*)model;

-(void)setupPackageID:(NSString*)packageID;

-(void)setupPackageDetailPayment:(ScheduleModel*)model;
@end

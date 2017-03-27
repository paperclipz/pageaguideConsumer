//
//  MyRequestDetailViewController.h
//  paguide
//
//  Created by Evan Beh on 23/03/2017.
//  Copyright © 2017 Evan Beh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppointmentModel.h"

@interface MyRequestDetailViewController : CommonViewController

-(void)setupData:(AppointmentModel*)model;

@end

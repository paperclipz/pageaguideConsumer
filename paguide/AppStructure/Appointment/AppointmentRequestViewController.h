//
//  AppointmentRequestViewController.h
//  paguide
//
//  Created by Evan Beh on 23/03/2017.
//  Copyright © 2017 Evan Beh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppointmentModel.h"

@interface AppointmentRequestViewController : UIViewController

-(void)setupData:(AppointmentModel*)model;
@property (nonatomic,assign)APPOITNMENT_VIEW_TYPE viewType;;

@end

//
//  CalenderViewController.h
//  paguide
//
//  Created by Evan Beh on 08/03/2017.
//  Copyright © 2017 Evan Beh. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PackageModel.h"


@interface CalenderViewController : UIViewController


@property (nonatomic,copy)StringBlock didContinueWithDateBlock;

-(void)setupData:(PackageModel*)packageModel;
@end

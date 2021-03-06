//
//  DashboardPackageTableViewCell.h
//  paguide
//
//  Created by Evan Beh on 01/03/2017.
//  Copyright © 2017 Evan Beh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RatingView.h"

@interface DashboardPackageTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *ibImageView;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle1;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle2;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle3;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle4;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle5;
@property (weak, nonatomic) IBOutlet RatingView *ratingView;

@end

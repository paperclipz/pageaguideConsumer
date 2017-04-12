//
//  ApptHeaderTableViewCell.h
//  paguide
//
//  Created by Evan Beh on 02/03/2017.
//  Copyright © 2017 Evan Beh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RatingView.h"

@interface ApptHeaderTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle2;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle3;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle4;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle5;
@property (strong, nonatomic) RatingView *ratingView;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle6;

@end

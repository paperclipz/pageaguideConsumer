//
//  MerchantProfileTableViewCell.h
//  paguide
//
//  Created by Evan Beh on 03/03/2017.
//  Copyright © 2017 Evan Beh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RatingView.h"

@interface MerchantProfileTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblTitle1;
@property (weak, nonatomic) IBOutlet UILabel *lblDesc2;

@property (weak, nonatomic) IBOutlet UILabel *lblDesc1;
@property (strong, nonatomic) RatingView *ratingView;
@end

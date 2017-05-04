//
//  TourGuideProfileCollectionViewCell.h
//  paguide
//
//  Created by Evan Beh on 02/05/2017.
//  Copyright © 2017 Evan Beh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RatingView.h"

@interface TourGuideProfileCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *ibImageView;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblDesc;
@property (weak, nonatomic) IBOutlet UIView *ibRatingContentView;
@property (strong, nonatomic) RatingView *ratingView;

@end

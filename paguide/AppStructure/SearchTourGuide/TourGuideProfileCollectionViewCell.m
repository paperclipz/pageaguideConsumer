//
//  TourGuideProfileCollectionViewCell.m
//  paguide
//
//  Created by Evan Beh on 02/05/2017.
//  Copyright © 2017 Evan Beh. All rights reserved.
//

#import "TourGuideProfileCollectionViewCell.h"

@implementation TourGuideProfileCollectionViewCell


-(void)awakeFromNib
{
    
    [super awakeFromNib];
    
    if (self.ibRatingContentView) {
        [self.ibRatingContentView addSubview:self.ratingView];
        
        self.ratingView.frame = CGRectMake(0, 0, self.ibRatingContentView.frame.size.width, self.ibRatingContentView.frame.size.height);
    }
    
    [self.ratingView setupRatingOutOfFive:1];
    
    [Utils setRoundBorder:self.ibImageView color:[UIColor clearColor] borderRadius:self.ibImageView.frame.size.width/2];

}

-(RatingView*)ratingView
{
    if (!_ratingView) {
        _ratingView = [RatingView initializeCustomView];
        
        
    }
    
    return _ratingView;
}
@end

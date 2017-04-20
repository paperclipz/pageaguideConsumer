//
//  DashboardPackageTableViewCell.m
//  paguide
//
//  Created by Evan Beh on 01/03/2017.
//  Copyright © 2017 Evan Beh. All rights reserved.
//

#import "DashboardPackageTableViewCell.h"

@interface DashboardPackageTableViewCell()
@property (weak, nonatomic) IBOutlet UIView *ibContentView;
@property (weak, nonatomic) IBOutlet UIView *ibRatingContentView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintWidth;

@end

@implementation DashboardPackageTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [Utils setRoundBorder:self.ibContentView color:[UIColor clearColor] borderRadius:5.0f];
    
    
    if (self.ibRatingContentView) {
        [self.ibRatingContentView addSubview:self.ratingView];
        
        self.ratingView.frame = CGRectMake(0, 0, self.ibRatingContentView.frame.size.width, self.ibRatingContentView.frame.size.height);
    }
    
    [self.ratingView setupRatingOutOfFive:1];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
    if (selected) {
        self.constraintWidth.constant = 5.0f;
    }
    else{
        self.constraintWidth.constant = 0.0f;
    }
    // Configure the view for the selected state
}

-(RatingView*)ratingView
{
    if (!_ratingView) {
        _ratingView = [RatingView initializeCustomView];
        
        
    }
    
    return _ratingView;
}
@end

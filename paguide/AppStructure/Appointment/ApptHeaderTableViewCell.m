//
//  ApptHeaderTableViewCell.m
//  paguide
//
//  Created by Evan Beh on 02/03/2017.
//  Copyright © 2017 Evan Beh. All rights reserved.
//

#import "ApptHeaderTableViewCell.h"

@interface ApptHeaderTableViewCell()

@property (weak, nonatomic) IBOutlet UIView *ratingContentView;

@end
@implementation ApptHeaderTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    
    if (self.ratingContentView) {
        [self.ratingContentView addSubview:self.ratingView];
        
        self.ratingView.frame = CGRectMake(0, 0, self.ratingContentView.frame.size.width, self.ratingContentView.frame.size.height);
    }
    
    [self.ratingView setupRatingOutOfFive:1];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setupRating
{
}

-(RatingView*)ratingView
{
    if (!_ratingView) {
        _ratingView = [RatingView initializeCustomView];
        
        
    }
    
    return _ratingView;
}
@end

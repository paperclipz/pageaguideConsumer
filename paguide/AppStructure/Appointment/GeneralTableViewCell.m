//
//  GeneralTableViewCell.m
//  paguide
//
//  Created by Evan Beh on 09/03/2017.
//  Copyright © 2017 Evan Beh. All rights reserved.
//

#import "GeneralTableViewCell.h"

@interface GeneralTableViewCell ()

@property (weak, nonatomic) IBOutlet UIView *ibRatingContentView;


@end
@implementation GeneralTableViewCell
- (IBAction)btnSelectionClicked:(id)sender {
    
    if (self.didSelectBlock) {
        self.didSelectBlock();
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    if (self.ibRatingContentView) {
        [self.ibRatingContentView addSubview:self.ratingView];
        
        self.ratingView.frame = CGRectMake(0, 0, self.ibRatingContentView.frame.size.width, self.ibRatingContentView.frame.size.height);
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

// for merchant profile
- (IBAction)btnOneClicked:(id)sender {
    
    if (self.didSelectInnerButton1Block) {
        self.didSelectInnerButton1Block();
    }
}


- (IBAction)btnTwoClicked:(id)sender {
    
    if (self.didSelectInnerButton2Block) {
        self.didSelectInnerButton2Block();
    }

}

-(RatingView*)ratingView
{
    if (!_ratingView) {
        _ratingView = [RatingView initializeCustomView];
        
        
    }
    
    return _ratingView;
}

@end

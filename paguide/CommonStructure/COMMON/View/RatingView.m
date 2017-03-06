//
//  RatingView.m
//  paguide
//
//  Created by Evan Beh on 02/03/2017.
//  Copyright © 2017 Evan Beh. All rights reserved.
//

#import "RatingView.h"

@interface RatingView()
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *ibCollectionRate;

@end
@implementation RatingView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)awakeFromNib
{
    [super awakeFromNib];
    
}

-(void)setup
{
    NSLog(@"setup rating");

}


-(void)setupRatingOutOfFive:(int)rate
{
    for (int i = 0; i<self.ibCollectionRate.count; i++) {
        
        UIImageView* imgRateView = self.ibCollectionRate[i];

        imgRateView.tintColor = [UIColor lightGrayColor];

        if (i< rate) {
            
            imgRateView.tintColor = [UIColor redColor];
        }
        
    }
}
@end

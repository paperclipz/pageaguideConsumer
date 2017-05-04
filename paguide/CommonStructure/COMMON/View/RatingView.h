//
//  RatingView.h
//  paguide
//
//  Created by Evan Beh on 02/03/2017.
//  Copyright © 2017 Evan Beh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonView.h"


//width for this view is 100
@interface RatingView : CommonView

-(void)setupRatingOutOfFive:(int)rate;
@property(nonatomic,strong)UIColor* hightlightTintColor;

@end

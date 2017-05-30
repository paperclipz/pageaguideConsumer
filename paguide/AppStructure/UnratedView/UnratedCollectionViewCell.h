//
//  UnratedCollectionViewCell.h
//  paguide
//
//  Created by Evan Beh on 30/05/2017.
//  Copyright © 2017 Evan Beh. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CommonCollectionViewCell.h"

@interface UnratedCollectionViewCell : CommonCollectionViewCell

@property (weak, nonatomic) IBOutlet UITextField *txtRating;
@property (nonatomic,assign) int rating;
@property(nonatomic,copy)VoidBlock didFinishRateBlock;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle1;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle2;
@property(nonatomic,copy)StringBlock didUpdateStringBlock;


@property(nonatomic,copy)IntBlock didRateClicked;
-(void)setRatingInView:(int)rating;

@end

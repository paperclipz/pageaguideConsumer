//
//  RatingViewController.h
//  paguide
//
//  Created by Evan Beh on 09/03/2017.
//  Copyright © 2017 Evan Beh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomPopOutViewController.h"

@interface RatingViewController : CustomPopOutViewController

@property (weak, nonatomic) IBOutlet UITextField *txtRating;
@property (nonatomic,assign) int rating;

@property(nonatomic,copy)VoidBlock didFinishRateBlock;
@end

//
//  ReviewViewController.h
//  paguide
//
//  Created by Evan Beh on 03/03/2017.
//  Copyright © 2017 Evan Beh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReviewModel.h"

@protocol ReviewModel;

@interface ReviewViewController : UIViewController
@property(nonatomic,strong)NSArray<ReviewModel>* arrReviews;
@end

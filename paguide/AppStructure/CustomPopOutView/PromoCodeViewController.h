//
//  PromoCodeViewController.h
//  paguide
//
//  Created by Evan Beh on 09/03/2017.
//  Copyright © 2017 Evan Beh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PromoCodeViewController : UIViewController


@property(nonatomic,copy)StringBlock didApplyPromoBlock;
@property(nonatomic,copy)VoidBlock didApplyNoPromoBlock;

@end

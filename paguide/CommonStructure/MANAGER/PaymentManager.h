//
//  PaymentManager.h
//  paguide
//
//  Created by Evan Beh on 21/03/2017.
//  Copyright © 2017 Evan Beh. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "STPPaymentContext.h"


@interface PaymentManager : STPPaymentContext
@property(nonatomic,strong)STPPaymentContext* paymentContext;

+ (id)Instance;
-(void)setupCardPayment:(UIViewController*)vc Success:(STPTokenBlock)success Failure:(STPErrorBlock)failure PresentIn:(UIViewController*)pViewController;

@end

//
//  PaymentManager.m
//  paguide
//
//  Created by Evan Beh on 21/03/2017.
//  Copyright © 2017 Evan Beh. All rights reserved.
//

#import "PaymentManager.h"
#import "Stripe.h"
#import "AppDelegate.h"
#import "MyAPIClient.h"


@interface PaymentManager()<STPPaymentContextDelegate,STPAddCardViewControllerDelegate>


@property(nonatomic,strong)UIViewController* viewController;
@property (nonatomic,copy)STPTokenBlock didGetTokenBlock;
@property (nonatomic,copy)STPErrorBlock errorBlock;
@property(nonatomic,strong)STPAddCardViewController* addCardViewController;


@end
@implementation PaymentManager

+ (id)Instance {
    
    static PaymentManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}


- (instancetype)init {
    
    self = [super init];
    if (self) {
        
        UIViewController *rootController =(UIViewController*)[[(AppDelegate*)
                                                               [[UIApplication sharedApplication]delegate] window] rootViewController];
        

        // Here, MyAPIAdapter is your class that implements STPBackendAPIAdapter (see above)
        id<STPBackendAPIAdapter> apiAdapter = [MyAPIClient sharedClient];
        self.paymentContext.hostViewController = rootController.tabBarController;
        self.paymentContext = [[STPPaymentContext alloc] initWithAPIAdapter:apiAdapter];
        self.paymentContext.delegate = self;
        self.paymentContext.paymentAmount = 5000; // This in cents, i.e. $50 USD
        
        
   
    }
    return self;
}

//-(UIViewController*)viewController
//{
//    
//    UIViewController *rootController =(UIViewController*)[[(AppDelegate*)
//                                                           [[UIApplication sharedApplication]delegate] window] rootViewController];
//    
//    return rootController;
//    
//
//}

- (void)paymentContext:(STPPaymentContext *)paymentContext didFailToLoadWithError:(NSError *)error
{

}

/**
 *  This is called every time the contents of the payment context change. When this is called, you should update your app's UI to reflect the current state of the payment context. For example, if you have a checkout page with a "selected payment method" row, you should update its payment method with `paymentContext.selectedPaymentMethod.label`. If that checkout page has a "buy" button, you should enable/disable it depending on the result of `[paymentContext isReadyForPayment]`.
 *
 *  @param paymentContext the payment context that changed
 */
- (void)paymentContextDidChange:(STPPaymentContext *)paymentContext {
   
   
}

/**
 *  Inside this method, you should make a call to your backend API to make a charge with that Customer + source, and invoke the `completion` block when that is done.
 *
 *  @param paymentContext The context that succeeded
 *  @param paymentResult  Information associated with the payment that you can pass to your server. You should go to your backend API with this payment result and make a charge to complete the payment, passing `paymentResult.source.stripeID` as the `source` parameter to the create charge method and your customer's ID as the `customer` parameter (see stripe.com/docs/api#charge_create for more info). Once that's done call the `completion` block with any error that occurred (or none, if the charge succeeded). @see STPPaymentResult.h
 *  @param completion     Call this block when you're done creating a charge (or subscription, etc) on your backend. If it succeeded, call `completion(nil)`. If it failed with an error, call `completion(error)`.
 *
 *  @note If you are on Swift 3, you must declare the completion block as `@escaping` or Xcode will give you a protocol conformance error. https://bugs.swift.org/browse/SR-2597
 */
- (void)paymentContext:(STPPaymentContext *)paymentContext
didCreatePaymentResult:(STPPaymentResult *)paymentResult
            completion:(STPErrorBlock)completion
{

}

/**
 *  This is invoked by an `STPPaymentContext` when it is finished. This will be called after the payment is done and all necessary UI has been dismissed. You should inspect the returned `status` and behave appropriately. For example: if it's `STPPaymentStatusSuccess`, show the user a receipt. If it's `STPPaymentStatusError`, inform the user of the error. If it's `STPPaymentStatusUserCanceled`, do nothing.
 *
 *  @param paymentContext The payment context that finished
 *  @param status         The status of the payment - `STPPaymentStatusSuccess` if it succeeded, `STPPaymentStatusError` if it failed with an error (in which case the `error` parameter will be non-nil), `STPPaymentStatusUserCanceled` if the user canceled the payment.
 *  @param error          An error that occurred, if any.
 */
- (void)paymentContext:(STPPaymentContext *)paymentContext
   didFinishWithStatus:(STPPaymentStatus)status
                 error:(nullable NSError *)error
{

}


-(void)setupCardPayment:(UIViewController*)vc Success:(STPTokenBlock)success Failure:(STPErrorBlock)failure PresentIn:(UIViewController*)pViewController
{
    _didGetTokenBlock = success;
    _errorBlock = failure;
    
    self.viewController = vc;

//    STPTheme* theme = [[STPTheme alloc]init];
//    theme.secondaryForegroundColor = APP_MAIN_COLOR;
//    
    _addCardViewController = [[STPAddCardViewController alloc] init];
    _addCardViewController.delegate = self;

    // STPAddCardViewController must be shown inside a UINavigationController.
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:self.addCardViewController];
    [pViewController presentViewController:navigationController animated:YES completion:nil];
}

#pragma mark STPAddCardViewControllerDelegate

- (void)addCardViewControllerDidCancel:(STPAddCardViewController *)addCardViewController {
    [self.viewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)addCardViewController:(STPAddCardViewController *)addCardViewController
               didCreateToken:(STPToken *)token
                   completion:(STPErrorBlock)completion {
    
    
    [self.addCardViewController dismissViewControllerAnimated:YES completion:^{
        
        if (!token) {
            if (self.errorBlock) {
                self.errorBlock(nil);
            }
        }
        else{
            if (self.didGetTokenBlock) {
                self.didGetTokenBlock(token);
            }
        }

    }];
    
    NSLog(@"token: %@",token);
    
    
    //    [self submitTokenToBackend:token completion:^(NSError *error) {
//        if (error) {
//            completion(error);
//        } else {
//            [self dismissViewControllerAnimated:YES completion:^{
//                [self showReceiptPage];
//            }];
//        }
//    }];
}


@end

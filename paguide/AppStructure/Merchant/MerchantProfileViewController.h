//
//  MerchantProfileViewController.h
//  paguide
//
//  Created by Evan Beh on 03/03/2017.
//  Copyright © 2017 Evan Beh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MerchantProfileModel.h"

@interface MerchantProfileViewController : UIViewController

-(void)setUpMerchantProfile:(MerchantProfileModel*)model;
+(void)requestServerForMerchantID:(NSString*)merchantID Completion:(NSDictionaryBlock)completion Fail:(NSDictionaryBlock)failure;
//call this before setup merchant if the merchant data is not retreive

-(void)setUpMerchantProfileWithRequestGuide:(MerchantProfileModel*)model;

@property (nonatomic,copy)MerchantProfileBlock didUpdateMerchantProfileBlock;
@end

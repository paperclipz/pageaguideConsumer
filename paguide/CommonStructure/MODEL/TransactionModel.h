//
//  TransactionModel.h
//  paguide
//
//  Created by Evan Beh on 21/03/2017.
//  Copyright © 2017 Evan Beh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TransactionModel : JSONModel

@property (nonatomic,strong)NSString* transaction_id;
@property (nonatomic,strong)NSString* stripetoken;
@property (nonatomic,strong)NSString* type;//"request" , "package"

@property (nonatomic,strong)NSString* currency;
@property (nonatomic,strong)NSString* total_price;

@end

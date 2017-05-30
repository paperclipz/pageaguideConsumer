//
//  AppointmentModel.h
//  paguide
//
//  Created by Evan Beh on 20/03/2017.
//  Copyright © 2017 Evan Beh. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "PackageModel.h"
#import "RequestModel.h"
#import "ProfileModel.h"

@protocol MerchantProfileModel;
@protocol PackageModel;

@interface AppointmentModel : JSONModel

//package usage

@property (nonatomic,strong)NSString* appointment_id;
@property (nonatomic,strong)NSString* appointment_code;
@property (nonatomic,strong)NSString* type;
@property (nonatomic,strong)NSString* currency;
@property (nonatomic,strong)NSString* price;
@property (nonatomic,strong)NSString* transaction_date;
@property (nonatomic,strong)MerchantProfileModel* merchant_info_model;
@property (nonatomic,strong)NSMutableArray<MerchantProfileModel>* arr_Merchant_info;

@property (nonatomic,strong)RequestModel* request_info;
@property (nonatomic,strong)PackageModel* package_info_model;
@property (nonatomic,strong)NSString* verify_time;

@property (nonatomic,strong)NSString* promo_code;
@property (nonatomic,strong)NSString* title;

//request usage and merchant bid
@property (nonatomic,strong)ProfileModel* consumer_info;

@property (nonatomic,strong)NSString* status;

@property (nonatomic,strong)NSString* request_id;

@property (nonatomic,strong)NSString* created_at;

@property (nonatomic,strong)NSString* updated_at;

@property (nonatomic,strong)NSString* request_code;

@property (nonatomic,strong)NSString* offer_details;

@property (nonatomic,strong)NSString* offer_id;

@property (nonatomic,strong)NSString* complete_time;

@property (nonatomic,strong)NSString* cancellation_policy;

@property (nonatomic,strong)NSString* appointment_startdate;






@end

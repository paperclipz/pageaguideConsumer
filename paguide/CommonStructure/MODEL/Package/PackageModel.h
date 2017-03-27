//
//  PackageModel.h
//  paguide
//
//  Created by Evan Beh on 15/03/2017.
//  Copyright © 2017 Evan Beh. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "MerchantProfileModel.h"
@protocol ScheduleModel;


@interface PackageModel : JSONModel

@property (nonatomic,strong)NSString* name;
@property (nonatomic,strong)NSString* category;
@property (nonatomic,strong)NSString* latlng;
@property (nonatomic,strong)NSString* desc;
@property (nonatomic,strong)NSString* listing_img;
@property (nonatomic,strong)NSArray* cover_img;
@property (nonatomic,strong)NSString* itinerary;
@property (nonatomic,strong)NSArray* language;
@property (nonatomic,strong)NSString* mode;
@property (nonatomic,strong)NSNumber* duration;
@property (nonatomic,strong)NSString* recommended;
@property (nonatomic,strong)NSString* currency;
@property (nonatomic,strong)NSString* price;
@property (nonatomic,strong)NSString* include;
@property (nonatomic,strong)NSString* scheduled;

@property (nonatomic,strong)NSString* cancellation_policy;
@property (nonatomic,strong)NSString* status;
@property (nonatomic,strong)NSString* type;
@property (nonatomic,strong)NSNumber* total_booked;
@property (nonatomic,strong)NSString* created_at;
@property (nonatomic,strong)NSString* updated_at;
@property (nonatomic,strong)NSString* packages_id;

//@property (nonatomic,strong)NSArray<ScheduleModel,Ignore>* arrScheduled_datetime;
//@property (nonatomic,strong)ScheduleModel<Ignore>* scheduledDateTime;
@property (nonatomic, strong) NSArray< ScheduleModel> *scheduled_datetime;
@property (nonatomic, strong) NSString* package_datetime;

@property (nonatomic,strong)MerchantProfileModel* merchant_info;
@property (nonatomic,strong)NSNumber* pax;

@property (nonatomic, strong) NSString* package_date;
@property (nonatomic, strong) NSString* package_time;




@end

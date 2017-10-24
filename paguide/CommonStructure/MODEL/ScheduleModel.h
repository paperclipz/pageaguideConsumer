//
//  ScheduleModel.h
//  paguide
//
//  Created by Evan Beh on 15/03/2017.
//  Copyright © 2017 Evan Beh. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface ScheduleModel : JSONModel

@property (nonatomic,strong)NSString* language;

@property (nonatomic,strong)NSString* scheduled_date;
@property (nonatomic,strong)NSString* scheduled_time;
@property (nonatomic,strong)NSNumber* max_slot;
@property (nonatomic,strong)NSString* status;
@property (nonatomic,strong)NSString* created_at;
@property (nonatomic,strong)NSString* updated_at;
@property (nonatomic,strong)NSNumber* min_slot;


@property (nonatomic,strong)NSNumber* quantity;//viewmodel

@property (nonatomic,strong)NSDate* selectedDate;
@property (nonatomic,strong)NSString* inputLanguage;
@end

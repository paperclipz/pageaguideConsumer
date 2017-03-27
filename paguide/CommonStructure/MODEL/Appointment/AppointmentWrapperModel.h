//
//  AppointmentWrapperModel.h
//  paguide
//
//  Created by Evan Beh on 20/03/2017.
//  Copyright © 2017 Evan Beh. All rights reserved.
//

#import "BaseModel.h"
#import "PaginationModel.h"

@protocol AppointmentModel;


@interface AppointmentWrapperModel : BaseModel

@property(nonatomic,strong)PaginationModel* pageContent;
@property(nonatomic,strong)NSArray<AppointmentModel>* arrAppointmentList;


@end

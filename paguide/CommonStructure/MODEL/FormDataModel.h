//
//  FormDataModel.h
//  paguide
//
//  Created by Evan Beh on 20/03/2017.
//  Copyright © 2017 Evan Beh. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "KeyValueModel.h"

@protocol KeyValueModel;

@interface FormDataModel : JSONModel

@property(nonatomic,strong)NSString* title;
@property(nonatomic,strong)NSString* parameter;
@property(nonatomic,strong)NSString* type;
@property(nonatomic,strong)NSString* placeholder;
@property(nonatomic,strong)NSString* required;
@property(nonatomic,strong)NSString* created_at;
@property(nonatomic,strong)NSString* updated_at;


@property(nonatomic,strong)NSMutableArray* arrOptionsList;

@property(nonatomic,strong)KeyValueModel* viewModel;//for viewmodelValue


@end

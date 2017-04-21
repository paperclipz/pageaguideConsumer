//
//  RequestModel.h
//  paguide
//
//  Created by Evan Beh on 20/03/2017.
//  Copyright © 2017 Evan Beh. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@protocol FormDataModel;

@interface RequestModel : JSONModel


    
    
@property(nonatomic,strong)NSString* title;
@property(nonatomic,strong)NSString* language;
@property(nonatomic,strong)NSString* date;
@property(nonatomic,strong)NSNumber* period;
@property(nonatomic,strong)NSArray* times;
@property(nonatomic,strong)NSArray* qualifications;
@property(nonatomic,strong)NSNumber* pax;
@property(nonatomic,strong)NSString* created_by;
@property(nonatomic,strong)NSString* created_at;
@property(nonatomic,strong)NSString* updated_at;
@property(nonatomic,strong)NSArray* specialty;
@property (nonatomic,strong)NSArray* arrRequest_field;



@end

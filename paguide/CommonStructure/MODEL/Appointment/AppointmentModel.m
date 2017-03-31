//
//  AppointmentModel.m
//  paguide
//
//  Created by Evan Beh on 20/03/2017.
//  Copyright © 2017 Evan Beh. All rights reserved.
//

#import "AppointmentModel.h"


@interface AppointmentModel()
@property (nonatomic,strong)NSDictionary* merchant_info;

@property (nonatomic,strong)NSDictionary* package_info;

@end
@implementation AppointmentModel

+(BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}

-(PackageModel*)package_info_model
{
    if (!_package_info_model) {
        
        NSError* error;
        _package_info_model = [[PackageModel alloc]initWithDictionary:_package_info error:&error];
    }
    
    return _package_info_model;
}


//
//+(JSONKeyMapper*)keyMapperz
//{
//    return [[JSONKeyMapper alloc]initWithDictionary:@{
//                                                      @"package_info.description": @"package_info.desc",
//                                                      }];
//}
//


-(MerchantProfileModel*)merchant_info_model
{
    if (!_merchant_info_model) {
        
        
        NSError* error;
        
        _merchant_info_model = [[MerchantProfileModel alloc]initWithDictionary:_merchant_info error:&error];
    }
    
    if (!_merchant_info_model && _merchant_info) {
        
        
        if (![Utils isArrayNull:self.arr_Merchant_info]) {
            
            
            _merchant_info_model = self.arr_Merchant_info[0];
        }


    }
    
    return _merchant_info_model;
}

-(NSMutableArray<MerchantProfileModel>*)arr_Merchant_info
{
    if (!_arr_Merchant_info) {
        
        NSError* error;

        _arr_Merchant_info = (NSMutableArray<MerchantProfileModel>*)[MerchantProfileModel arrayOfModelsFromDictionaries:_merchant_info error:&error];
    }
    
    return _arr_Merchant_info;
}


@end

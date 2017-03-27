//
//  ProfileModel.m
//  paguide
//
//  Created by Evan Beh on 15/03/2017.
//  Copyright © 2017 Evan Beh. All rights reserved.
//

#import "ProfileModel.h"

@implementation ProfileModel
+(BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}


-(NSString*)temp_prefix
{
    
    if ([Utils isStringNull:_temp_prefix]) {
        return @"Prefix";
    }

    return _temp_prefix;
}

-(NSString*)temp_mobile_number
{
    
    if ([Utils isStringNull:_temp_mobile_number]) {
        return @"Country";
    }
    
    return _temp_mobile_number;
}

-(void)processPrefix:(VoidBlock)completion
{
    [[DataManager Instance]getCountryList:^(NSArray *array) {
       
        NSArray* arrayCountryList = array;
        
        NSString* prefix = @"";
        
        
        for (int i = 0; i<arrayCountryList.count; i++) {
            
            CountryModel* model  = arrayCountryList[i];
            
            if ([self.mobile_number containsString:model.c_prefix]) {
                
                if (model.c_prefix.length > prefix.length) {
                    prefix = model.c_prefix;
                    
                    _temp_prefix = prefix;
                    
                    NSArray* arrayStrings = [self.mobile_number componentsSeparatedByString:model.c_prefix];
                    
                    NSString* purePhoneNumber = arrayStrings[1];
                    
                    _temp_mobile_number = purePhoneNumber;
                }
               
            }
        }
        
        if (completion) {
            completion();
        }
        
    }];
    
}

@end

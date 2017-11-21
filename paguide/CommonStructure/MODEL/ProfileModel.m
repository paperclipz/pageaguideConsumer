//
//  ProfileModel.m
//  paguide
//
//  Created by Evan Beh on 15/03/2017.
//  Copyright © 2017 Evan Beh. All rights reserved.
//

#import "ProfileModel.h"


@interface ProfileModel()

@property (nonatomic,strong)NSString* push_notif;
@property (nonatomic,strong)NSString* sms_notif;
@end

@implementation ProfileModel
+(BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}

-(BOOL)getNotif_on
{
    if (![Utils isStringNull:_push_notif])
    {
        if ([_push_notif isEqualToString:@"Y"]) {
            
            
            return YES;
        }
        else{
            return NO;
        }
    }
    
    return NO;
}

-(BOOL)getSMS_on
{
    if (![Utils isStringNull:_sms_notif])
    {
        if ([_sms_notif isEqualToString:@"Y"]) {
            
            
            return YES;
        }
        else{
            return NO;
        }
    }
    
    return NO;
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
        return @"Mobile Number";
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

- (void)encodeWithCoder:(NSCoder *)encoder {
    //Encode properties, other class variables, etc
    
    for (NSString *key in [self codableProperties])
    {
        
        [encoder encodeObject:[self valueForKey:key] forKey:key];
        
    }
    
    
}

- (id)initWithCoder:(NSCoder *)decoder {
    if((self = [super init])) {
        //decode properties, other class vars
        
        
        for (NSString *key in [self codableProperties])
        {
            [self setValue:[decoder decodeObjectForKey:key] forKey:key];
            
        }
    }
    
    return self;
}


@end

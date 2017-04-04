//
//  DataManager.m
//  SeetiesIOS
//
//  Created by Evan Beh on 8/6/15.
//  Copyright (c) 2015 Stylar Network. All rights reserved.
//

#import "DataManager.h"
#import "CountryModel.h"

#define KEY_LOGIN_INFO @"key_login_info"

@protocol CountryModel
@end

@interface DataManager()

@property(nonatomic,strong)NSArray* arrCountryList;


@end
@implementation DataManager

+ (id)Instance {
    
    static DataManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (id)init {
    if (self = [super init]) {
        
    }
    return self;
}

-(void)getCountryList:(NSArrayBlock)completionBlock
{

    if (![Utils isArrayNull:self.arrCountryList]) {
        
        if (completionBlock) {
            completionBlock(self.arrCountryList);
            
            return;
        }
    }
    
    [LoadingManager show];
    
    [ConnectionManager requestServerWith:AFNETWORK_POST serverRequestType:ServerRequestTypePostUserCountry_Listing parameter:nil appendString:nil success:^(id object) {
        
        NSDictionary* dict = [[NSDictionary alloc]initWithDictionary:object];
        
        NSMutableArray* array  = [CountryModel arrayOfModelsFromDictionaries:dict[@"data"] error:nil];
        
        self.arrCountryList = (NSArray<CountryModel>*)array;
        
        
        
        [LoadingManager hide];
        
        
        if (completionBlock) {
            completionBlock(self.arrCountryList);
        }
        
    } failure:^(id object) {
        
        [LoadingManager hide];
        
        
        
    }];

}

+(void)setLoginModel:(LoginViewModel*)model
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults removeObjectForKey:KEY_LOGIN_INFO];
    
    if (model) {
        
        NSData *encodedObject = [NSKeyedArchiver archivedDataWithRootObject:model];
        [defaults setObject:encodedObject forKey:KEY_LOGIN_INFO];
        [defaults synchronize];
        
    }    
}

+(LoginViewModel*)getLoginModel
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSData * data = [defaults objectForKey:KEY_LOGIN_INFO];
    
    LoginViewModel* model = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    return model;
    
}

+(void)requestServerForRegisterDevice
{
    NSString* token  = [Utils getToken];
    
    NSString* device_serial = [Utils getUniqueDeviceIdentifier];
    
    NSString* firebaseToken = [[FIRInstanceID instanceID] token];
    
    NSDictionary* dict = @{@"device_serial" : IsNullConverstion(device_serial),
                           @"device_id" : IsNullConverstion(firebaseToken),
                           @"device_os" : @"ios",
                           @"token" : IsNullConverstion(token)};
    
    [ConnectionManager requestServerWith:AFNETWORK_POST serverRequestType:ServerRequestTypePostUserRegisterdevice parameter:dict appendString:nil success:^(id object) {
        
        
    } failure:^(id object) {
        
    }];
}


@end

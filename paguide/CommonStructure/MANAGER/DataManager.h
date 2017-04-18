//
//  DataManager.h
//  SeetiesIOS
//
//  Created by Evan Beh on 8/6/15.
//  Copyright (c) 2015 Stylar Network. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LoginViewModel.h"


@interface DataManager : NSObject
+ (id)Instance;

-(void)getCountryList:(NSArrayBlock)completionBlock;
+(void)setLoginModel:(LoginViewModel*)model;
+(LoginViewModel*)getLoginModel;
+(void)requestServerForRegisterDevice;



+(void)saveDefaultPrefix:(CountryModel*)model;
+(CountryModel*)getDefaultPrefix;

+(CountryModel*)getDefaultCountry;
+(void)saveDefaultCountry:(CountryModel*)model;
@end

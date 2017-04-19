//
//  DataManager.h
//  SeetiesIOS
//
//  Created by Evan Beh on 8/6/15.
//  Copyright (c) 2015 Stylar Network. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LoginViewModel.h"
#import "ProfileModel.h"

typedef void(^ProfileModelBlock) (ProfileModel* pModel);


@interface DataManager : NSObject
+ (id)Instance;

-(void)getCountryList:(NSArrayBlock)completionBlock;
+(void)requestServerForRegisterDevice;


+(void)saveDefaultPrefix:(CountryModel*)model;
+(CountryModel*)getDefaultPrefix;

+(CountryModel*)getDefaultCountry;
+(void)saveDefaultCountry:(CountryModel*)model;

+(void)setLoginModel:(LoginViewModel*)model;//for register information to be pass around
+(LoginViewModel*)getLoginModel;

+(void)getUserProfile:(ProfileModelBlock)completion;
+(void)reloadUserProfile:(ProfileModelBlock)completion;
+(void)setUserProfile:(ProfileModel*)model;

@end

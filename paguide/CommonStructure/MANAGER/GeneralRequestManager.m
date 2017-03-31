//
//  GeneralRequestManager.m
//  paguide
//
//  Created by Evan Beh on 28/03/2017.
//  Copyright © 2017 Evan Beh. All rights reserved.
//

#import "GeneralRequestManager.h"
#define KEY_USER_INFO @"user_info"

@implementation GeneralRequestManager

+ (id)Instance {
    static GeneralRequestManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc]init];
        
    });
    return instance;
}

-(id)init
{
    self = [super init];

    
    return self;
}

+(void)setuserProfile:(ProfileModel*)model
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults removeObjectForKey:KEY_USER_INFO];
    
    if (model) {
        
        NSData *encodedObject = [NSKeyedArchiver archivedDataWithRootObject:model];
        [defaults setObject:encodedObject forKey:KEY_USER_INFO];
        [defaults synchronize];
        
    }
    
    
}

+(ProfileModel*)getUserProfile
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSData * data = [defaults objectForKey:KEY_USER_INFO];
    
    ProfileModel* model = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    return model;
    
}

+(void)reloadProfileData:(ProfileModelBlock)completion
{
    GeneralRequestManager* manager = [GeneralRequestManager Instance];
    
    [manager requestServerForUserProfile:^(ProfileModel *pModel) {
        
        
        if (completion) {
            completion(pModel);
            
            
        }
    } Failure:^{
        
    }];

}



+(void)getProfileData:(BOOL)isNeedReload CompleteWithData:(ProfileModelBlock)completion
{
    
    GeneralRequestManager* manager = [GeneralRequestManager Instance];
    if (isNeedReload) {
        
        [manager requestServerForUserProfile:^(ProfileModel *pModel) {
            
            if (completion) {
                completion(pModel);
            }
            
        } Failure:^{
            
            
            
        }];
    }
    else{
    
        
        ProfileModel* model = [GeneralRequestManager getUserProfile];
        
        if (!model) {
            
            [manager requestServerForUserProfile:^(ProfileModel *pModel) {
                
                if (completion) {
                    completion(pModel);
                }
                
            } Failure:^{
                
                
                
            }];

        }
        else{
            if (completion) {
                completion(model);
            }

        }
        
    }
}



-(void)requestServerForUserProfile:(ProfileModelBlock)finisLoadBlock Failure:(VoidBlock)failure
{
    
    NSString* token = [Utils getToken];
    
    NSDictionary* dict = @{@"token" : IsNullConverstion(token)};
    
    
    [LoadingManager show];
    [ConnectionManager requestServerWith:AFNETWORK_POST serverRequestType:ServerRequestTypePostUserProfile parameter:dict appendString:nil success:^(id object) {
        
        [LoadingManager hide];

        NSError* error;
        
        ProfileModel* pModel = [[ProfileModel alloc]initWithDictionary:object[@"data"] error:&error];
        
        
        [pModel processPrefix:^{
            
            [GeneralRequestManager setuserProfile:pModel];

            if (finisLoadBlock) {
                finisLoadBlock(pModel);
            }
        }];
        
        
        
    } failure:^(id object) {
        
        [LoadingManager hide];

        if (failure) {
            failure();
        }
      
    }];
}
@end

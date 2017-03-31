//
//  GeneralRequestManager.h
//  paguide
//
//  Created by Evan Beh on 28/03/2017.
//  Copyright © 2017 Evan Beh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ProfileModel.h"

typedef void(^ProfileModelBlock) (ProfileModel* pModel);

@interface GeneralRequestManager : NSObject

+ (id)Instance;
+(void)getProfileData:(BOOL)isNeedReload CompleteWithData:(ProfileModelBlock)completion;
+(void)reloadProfileData:(ProfileModelBlock)completion;
+(void)setuserProfile:(ProfileModel*)model;

@end

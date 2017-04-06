//
//  OfflineManager.h
//  paguide
//
//  Created by Evan Beh on 03/04/2017.
//  Copyright © 2017 Evan Beh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PackageModel.h"

@interface OfflineManager : NSObject


+ (id)Instance;
+(void)storePackageList:(PackageModel*)pModel;
+(NSArray*)getPackageList;
+(void)deleteBookMarked:(NSString*)packageCode;
+(BOOL)checkIsPackageBookmarked:(NSString*)packageCode;



@end

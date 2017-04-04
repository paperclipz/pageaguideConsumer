//
//  OfflineManager.m
//  paguide
//
//  Created by Evan Beh on 03/04/2017.
//  Copyright © 2017 Evan Beh. All rights reserved.
//

#import "OfflineManager.h"
#import "PackageModel.h"

#define KEY_OFFLINE_PACKAGE @"key_offline_package_v1"
@implementation OfflineManager

+ (id)Instance {
    static OfflineManager *instance = nil;
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

+(void)storePackageList:(PackageModel*)pModel
{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if (pModel) {
        
        NSDictionary* dict = @{pModel.packages_code : [pModel toJSONData]};
        
        NSData * data = [defaults objectForKey:KEY_OFFLINE_PACKAGE];
        
        NSDictionary* dictTemp = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        
        NSMutableDictionary* dictStored = [dictTemp mutableCopy];
        
        if (dictStored) {
            
            [dictStored addEntriesFromDictionary:dict];
        }
        else{
            dictStored = [[NSMutableDictionary alloc]initWithDictionary:dict];
        }
        
        NSData *encodedObject = [NSKeyedArchiver archivedDataWithRootObject:dictStored];
        
        [defaults setObject:encodedObject forKey:KEY_OFFLINE_PACKAGE];
        [defaults synchronize];
        
    }

}

+(NSArray*)getPackageList
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSData * data = [defaults objectForKey:KEY_OFFLINE_PACKAGE];
    
    NSDictionary* dict = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    
    NSMutableArray* arrayList = [NSMutableArray new];
    
    
    NSArray* arrAllKeys = [dict allKeys];
    
    for (int i = 0; i<arrAllKeys.count; i++) {
        
        NSError* error;
        
        NSData* data = dict[arrAllKeys[i]];
        
        PackageModel* model = [[PackageModel alloc]initWithData:data error:&error];
                            
        [arrayList addObject:model];
    }
    
    return arrayList;
    
}

+(BOOL)checkIsPackageBookmarked:(NSString*)packageCode
{
    BOOL isBookmarked = NO;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSData * data = [defaults objectForKey:KEY_OFFLINE_PACKAGE];
    
    NSDictionary* dict = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    
    NSDictionary* dictPackage = [dict objectForKey:packageCode];
    
    if (dictPackage) {
        isBookmarked = YES;
    }
    else{
        isBookmarked = NO;
        
    }
    
    return isBookmarked;
    
}

+(void)deleteBookMarked:(NSString*)packageCode
{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSData * data = [defaults objectForKey:KEY_OFFLINE_PACKAGE];
    
    NSDictionary* dict = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    NSMutableDictionary* dictTemp = [dict mutableCopy];
    
    [dictTemp removeObjectForKey:packageCode];
    
    NSData *encodedObject = [NSKeyedArchiver archivedDataWithRootObject:dictTemp];

    
    [defaults setObject:encodedObject forKey:KEY_OFFLINE_PACKAGE];
    
    [defaults synchronize];

  
}


@end

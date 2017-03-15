//
//  DataManager.m
//  SeetiesIOS
//
//  Created by Evan Beh on 8/6/15.
//  Copyright (c) 2015 Stylar Network. All rights reserved.
//

#import "DataManager.h"
#import "CountryModel.h"


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


@end

//
//  PackageModel.m
//  paguide
//
//  Created by Evan Beh on 15/03/2017.
//  Copyright © 2017 Evan Beh. All rights reserved.
//

#import "PackageModel.h"
#import "ScheduleModel.h"

@interface PackageModel()

@end
@implementation PackageModel

+(BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc]initWithDictionary:@{
                                                                @"description": @"desc",
                                                                }];
}


//-(NSArray<ScheduleModel>*)arrScheduled_datetime
//{
//    NSError* error;
//    
//    return  (NSArray<ScheduleModel>*)[ScheduleModel arrayOfModelsFromDictionaries:_scheduled_datetime error:&error];
//}
//
//-(ScheduleModel*)scheduledDateTime
//{
//    NSError* error;
//    
//    if (!_scheduledDateTime) {
//        
//        _scheduledDateTime = [[ScheduleModel alloc]initWithDictionary:_scheduled_datetime error:&error];;
//    }
//    
//    return _scheduledDateTime;
//
//}
//

-(NSString*)package_date
{
    
    NSArray* array = [self.package_datetime componentsSeparatedByString:@"|"];
    
    NSString* date = array[0];
    
    if (![Utils isStringNull:date]) {
        
        _package_date = date;
    }
    
    return _package_date;
}

-(NSString*)package_time
{
    
    NSArray* array = [self.package_datetime componentsSeparatedByString:@"|"];
    
    NSString* time = array[3];
    
    if (![Utils isStringNull:time]) {
        
        _package_time = time;
    }
    
    return _package_time;
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

//-(id)initWithPackageRMLModel:(PackageRMLModel*)model
//{
//    
//        self = [super init];
//        if(!self) return nil;
//        
//        for (NSString *key in [model codableProperties])
//        {
//            for (NSString *innerKey in [self codableProperties])
//            {
//                
//                if ([key isEqualToString:innerKey]) {
//                    
//                    
//                    id key_value = [model valueForKey:key];
//                    
//                    if (key_value) {
//                        
//                        [self setValue:[model valueForKey:key] forKey:innerKey];
//
//                    }
//                    
//                }
//                
//            }
//            
//            
//        }
//        
//        
//        
//        
//        return self;
//
//}

@end

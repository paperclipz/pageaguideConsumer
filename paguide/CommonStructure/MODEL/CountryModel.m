//
//  CountryModel.m
//  paguide
//
//  Created by Evan Beh on 13/03/2017.
//  Copyright © 2017 Evan Beh. All rights reserved.
//

#import "CountryModel.h"

@implementation CountryModel

+(BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
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

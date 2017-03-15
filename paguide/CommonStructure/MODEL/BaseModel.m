//
//  BaseModel.m
//  paguide
//
//  Created by Evan Beh on 13/03/2017.
//  Copyright © 2017 Evan Beh. All rights reserved.
//

#import "BaseModel.h"

@interface BaseModel()

@property (nonatomic,strong)NSDictionary<Optional>* message;

@end
@implementation BaseModel


+(BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}

-(BOOL)isSuccessful
{
    if ([_status isEqualToString:server_fail]) {
        
        
        _isSuccessful = false;
        
    }
    else{
    
        _isSuccessful = YES;

    }
    
    return _isSuccessful;
    
}


-(NSString*)displayMessage
{
    
    _displayMessage = @"";

    if ([_message isKindOfClass:[NSDictionary class]]) {
        
        NSArray* key = [_message allKeys];
        
        
        if (![Utils isArrayNull:key]) {
            
            id messages = _message[key[0]];

            
            if ([messages isKindOfClass:[NSString class]]) {
                _displayMessage = messages;

            }
            else if([messages isKindOfClass:[NSArray class]])
            {
                
                if (![Utils isArrayNull:messages]) {
                    
                    _displayMessage = messages[0];
                }
            }
           
        }
        
        
        
    }
    else if ([_message isKindOfClass:[NSString class]]) {
        NSLog(@"this is a nsstring");

        _displayMessage = (NSString*)_message;

    }
    
    return _displayMessage;
}

@end

//
//  NSArray+value.m
//  Beep
//
//  Created by Evan Beh on 16/11/2016.
//  Copyright © 2016 Paperclipz. All rights reserved.
//

#import "NSArray+value.h"

@implementation NSArray(value)

-(NSString*)getKeyForValue:(NSString*)value
{
    for(NSDictionary* dict in self)
    {
        NSString* tempKey = [dict allKeys][0];
        
        NSString* str = [dict valueForKey:tempKey];
        
        if ([str isEqualToString:value]) {
            return tempKey;
        }
    }
    
    return @"";
}

@end


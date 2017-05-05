//
//  NSDate+Extra.m
//  Beep
//
//  Created by Evan Beh on 05/10/2016.
//  Copyright © 2016 Paperclipz. All rights reserved.
//

#import "NSDate+Extra.h"

@implementation NSDate(Extra)

//date to long
//long to nsstring
//self.lblDate.text     = @"6 Sept 2016 11.30 PM";

-(NSString*)toString
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd/MM/yyyy"];
    
    dateFormat.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    
    
    NSString *theDate = [dateFormat stringFromDate:self];
    
    return theDate;
}

-(NSString*)toServerString
{
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd/MM/yyyy HH:mm:ss"];
    
    dateFormat.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    
    NSString *theDate = [dateFormat stringFromDate:self];
    
    return theDate;

}
-(NSString*)toLocalTime
{
    NSTimeZone *timeZone = [NSTimeZone localTimeZone];
    
    NSDateFormatter* df_local = [[NSDateFormatter alloc] init];
    [df_local setTimeZone:timeZone];
    [df_local setDateFormat:@"dd MMM yyyy h:mm a"];

    NSString* ts_utc_string = [df_local stringFromDate:self];
    
    return ts_utc_string;
}

@end

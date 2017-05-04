//
//  ConnectionHelper.m
//  Beep
//
//  Created by Page Advisor on 07/09/2016.
//  Copyright © 2016 Paperclipz. All rights reserved.
//

#import "ConnectionHelper.h"
#import "CountryModel.h"

@implementation ConnectionHelper

-(NSString*)getLocalData:(ServerRequestType)type
{
 
    id result;
    
    switch (type) {
        case ServerRequestTypePostUserRegister:
        {
            NSString *filePath = [[NSBundle mainBundle] pathForResource:@"newsfeed" ofType:@"json"];
            NSData* data = [NSData dataWithContentsOfFile:filePath];
            __autoreleasing NSError* error = nil;
            result = [NSJSONSerialization JSONObjectWithData:data
                                                     options:kNilOptions error:&error];
        }
            break;
            
        default:
            break;
    }
    
    
    return result;
}


-(BOOL)validateBeforeRequest:(ServerRequestType)type
{
    BOOL flag = false;
    
    switch (type) {
        case ServerRequestTypePostUserRegister:
            break;
            
        default:
            break;
    }
    
    return flag;
}


-(void)storeServerData:(id)obj requestType:(ServerRequestType)type
{
    
   // NSError* dictError;
    
    //make checking for status fail or success here
    switch (type) {
       
            
        case ServerRequestTypePostUserRegister:
            break;
            
            
        case ServerRequestTypePostUserCountry_Listing:
       

            
        default:
            
           // NSLog(@"the return result is :%@",obj);
            break;
    }
}


@end

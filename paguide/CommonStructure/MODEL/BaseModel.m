//
//  BaseModel.m
//  paguide
//
//  Created by Evan Beh on 13/03/2017.
//  Copyright © 2017 Evan Beh. All rights reserved.
//

#import "BaseModel.h"

@interface BaseModel()

@property (nonatomic,strong)NSDictionary<Ignore>* message;

@end
@implementation BaseModel


-(instancetype)initWithDictionary:(NSDictionary *)dict error:(NSError *__autoreleasing *)err
{
   
    self = [super initWithDictionary:dict error:err];
    
    if (self) {
        
        NSDictionary* tempDict = dict[@"message"];
        if (tempDict) {
            _message = tempDict;
        }
        
    }
    
    return self;
    
}


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


#pragma mark - Status Code

-(NSString*)generalMessage
{
    NSString* message = @"";
    
    
    if (![Utils isStringNull:self.displayMessage]) {
        
        
        return self.displayMessage;
        
    }
    else{
    
        
        switch ([self.status_code integerValue]) {
                
            case 401:
                message = @"permission denied , missing services token";
                break;
                
            case 100:
                message = @"registration success";
                break;
            case 101:
                message = @"user registration missing field  / invalid / duplicate";
                break;
              
            case 200:
                message = @"login successful";
                break;
            case 201:
                message = @"login missing field/ invalid info";
                break;
            case 202:
                message = @"invalid fb id";
                break;
            case 204:
                message = @"wrong email or password";
                break;
            case 205:
                message = @"pending verification otp";
                break;
            case 206:
                message = @"inactive user / blocked/ contact support";
                break;
            case 207:
                message = @"Invalid token";
                break;
            case 208:
                message = @"fb user trying to change password";
                break;
            case 209:
                message = @"update invalid";
                break;
            case 210:
                message = @"Profile update success";
                break;
       
            
            
            case 300:
                message = @"verification success";
                break;
            case 301:
                message = @"verified missing field/ invalid info";
                break;
            case 302:
                message = @"wrong otp";
                break;
            case 303:
                message = @"resend otp success";
                break;
            case 304:
                message = @"otp sent over max tried - 5 times";
                break;
            case 305:
                message = @"forgot password success sent";
                break;
                
                
                
            case 402:
                message = @"register device success";
                break;
            case 403:
                message = @"register device missing field / invalid";
                break;
                
                
                
            case 500:
                message = @"merchant registration success";
                break;
            case 501:
                message = @"merchant registration missing field  / invalid / duplicate";
                break;
            case 502:
                message = @"login successful";
                break;
            case 503:
                message = @"login missing field/ invalid info";
                break;
            case 504:
                message = @"wrong email or password";
                break;
            case 505:
                message = @"inactive merchant / blocked/ contact support";
                break;
            case 506:
                message = @"permission denied, not a merchant,just member (for app)";
                break;
            case 507:
                message = @"invalid token";
                break;
            case 509:
                message = @"update invalid";
                break;
            case 510:
                message = @"Profile update success";
                break;
            case 511:
                message = @"Membership create transaction success";
                break;
                
                
                
            case 600:
                message = @"add packages success";
                break;
            case 601:
                message = @"add packages missing field";
                break;
            case 602:
                message = @"invalid packages field / invalid info";
                break;
                
                
                
            case 700:
                message = @"create request / booking success";
                break;
            case 701:
                message = @"create request field / invalid info";
                break;
            case 702:
                message = @"promocode invalid";
                break;
            case 703:
                message = @"valid promocode";
                break;
            case 704:
                message = @"invalid scheduletime";
                break;
            case 705:
                message = @"number of pax exceed balance slot";
                break;
            case 706:
                message = @"";
                break;
             
                
                
                
            case 800:
                message = @"bid success";
                break;
            case 801:
                message = @"bid information invalid";
                break;
            case 802:
            message = @"already bid on same request";
                break;
                
                
                
                
            case 900:
                message = @"success payment";
                break;
            case 901:
                message = @"charge info invalid";
                break;
            case 902:
                message = @"stripe error";
                break;
            case 903:
                message = @"invalid verification code";
                break;
            case 904:
                message = @"verification code success";
                break;
            case 905:
                message = @"complete and rate success";
                break;
            default:
                message = @"";
                break;
        }
        
        
        return message;
    }
    
  
}
@end

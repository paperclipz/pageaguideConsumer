//
//  LoginViewModel.m
//  paguide
//
//  Created by Evan Beh on 14/03/2017.
//  Copyright © 2017 Evan Beh. All rights reserved.
//

#import "LoginViewModel.h"

@implementation LoginViewModel


-(NSString*)description
{
    
    NSString* desc;
    
    switch (_type) {
        case REGISTER_CELL_TYPE_email_address:
            desc = @"Email Address";

            break;
        case REGISTER_CELL_TYPE_name:
            desc = @"Name";

            break;
        case REGISTER_CELL_TYPE_country:
            desc = @"Country";

            break;
        case REGISTER_CELL_TYPE_phone_number:
            desc = @"Phone Number";

            break;
        case REGISTER_CELL_TYPE_TNC:
            desc = @"Term And Condition";

            break;
        case REGISTER_CELL_TYPE_Password:
            desc = @"Password";

            break;
        case REGISTER_CELL_TYPE_RE_Password:
            
            desc = @"Retype Password";

            break;

            
        default:
            
            desc = @"";
            break;
    }

    
    return desc;
}

-(NSString*)countryName
{
    if ([Utils isStringNull:_countryName]) {
        return @"Country";
    }
    else{
        return _countryName;
    }
}

-(NSString*)prefix
{
    if ([Utils isStringNull:_prefix]) {
        return @"Prefix";
    }
    else{
        return _prefix;
    }
}
@end


@implementation  LoginViewModel(checking)


-(BOOL)isCountryNull
{
    if ([Utils isStringNull:self.countryName] || [self.countryName  isEqualToString:@"Country"]) {
        
        return YES;
    }else{
        return NO;
    }
}

-(BOOL)isPrefixNull
{
    if ([Utils isStringNull:self.prefix] || [self.prefix  isEqualToString:@"Prefix"]) {
        
        return YES;
    }else{
        return NO;
    }
}
@end

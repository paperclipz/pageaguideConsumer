//
//  LoginViewModel.h
//  paguide
//
//  Created by Evan Beh on 14/03/2017.
//  Copyright © 2017 Evan Beh. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface LoginViewModel : NSObject

@property (nonatomic, assign)REGISTER_CELL_TYPE type;

@property (nonatomic, strong)NSString* emailAddress;
@property (nonatomic, strong)NSString* name;
@property (nonatomic, strong)NSString* password;
@property (nonatomic, strong)NSString* retypepassword;
@property (nonatomic, strong)NSString* countryName;
@property (nonatomic, strong)NSString* phoneNumber;
@property (nonatomic, strong)NSString* prefix;


@property (nonatomic, strong)NSString* fbid;
@property (nonatomic, strong)NSString* fbToken;

@property (nonatomic, strong)NSString* fullContactNumber;

@end


@interface LoginViewModel(checking)

-(BOOL)isPrefixNull;
-(BOOL)isCountryNull;


@end

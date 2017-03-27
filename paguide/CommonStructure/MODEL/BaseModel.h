//
//  BaseModel.h
//  paguide
//
//  Created by Evan Beh on 13/03/2017.
//  Copyright © 2017 Evan Beh. All rights reserved.
//

#import <JSONModel/JSONModel.h>


#define server_fail @"failed"
@interface BaseModel: JSONModel


@property (nonatomic,strong)NSString* displayMessage;

@property (nonatomic,assign)BOOL isSuccessful;

@property (nonatomic,strong)NSString* status;

@property (nonatomic,strong)NSNumber* status_code;

@property (nonatomic,strong)NSString* token;

#pragma mark - Status Code

@property (nonatomic,strong)NSString* generalMessage;


@end


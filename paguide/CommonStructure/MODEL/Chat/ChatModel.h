//
//  ChatModel.h
//  paguide
//
//  Created by Evan Beh on 29/09/2017.
//  Copyright © 2017 Evan Beh. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "DateModel.h"

@interface ChatModel : JSONModel


@property (nonatomic,strong)NSString* created_at;
@property (nonatomic,strong)NSString* user_id;
@property (nonatomic,strong)NSString* user_type;
@property (nonatomic,strong)NSString* user_name;
@property (nonatomic,strong)NSString* comment;
@property (nonatomic,strong)NSString* cID;

@end

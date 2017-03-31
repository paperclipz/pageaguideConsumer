//
//  AppModel.h
//  paguide
//
//  Created by Evan Beh on 28/03/2017.
//  Copyright © 2017 Evan Beh. All rights reserved.
//

#import "BaseModel.h"

@interface AppModel : BaseModel

@property (nonatomic,strong)NSString* ios_consumer_version;

@property (nonatomic,strong)NSString* ios_consumer_url;

@end

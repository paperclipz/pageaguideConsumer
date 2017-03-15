//
//  GVUserDefaults+Extra.h
//  paguide
//
//  Created by Evan Beh on 14/03/2017.
//  Copyright © 2017 Evan Beh. All rights reserved.
//

#import <GVUserDefaults/GVUserDefaults.h>

@interface GVUserDefaults (User)

@property (nonatomic, weak) NSString *userName;
@property (nonatomic, weak) NSNumber *userId;
@property (nonatomic, weak) NSString *token;
@end

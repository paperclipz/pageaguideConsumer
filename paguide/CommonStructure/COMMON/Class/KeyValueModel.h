//
//  KeyValueModel.h
//  paguide
//
//  Created by Evan Beh on 01/03/2017.
//  Copyright © 2017 Evan Beh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KeyValueModel : NSObject

@property (strong, nonatomic) NSString* key;
@property (strong, nonatomic) NSString* value;

@property (assign, nonatomic) BOOL isSelected;
@property (strong, nonatomic) NSDate* choosenDate;

@end

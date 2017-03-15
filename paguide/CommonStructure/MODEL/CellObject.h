//
//  CellObject.h
//  paguide
//
//  Created by Evan Beh on 13/03/2017.
//  Copyright © 2017 Evan Beh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CellObject : NSObject

@property (nonatomic, strong)NSString* placeHolder;
@property (nonatomic, assign)REGISTER_CELL_TYPE type;
@property (nonatomic, strong)NSString* value;
@property (nonatomic, strong)NSString* value2;

@end

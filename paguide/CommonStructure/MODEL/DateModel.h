//
//  DateModel.h
//  paguide
//
//  Created by Evan Beh on 29/09/2017.
//  Copyright © 2017 Evan Beh. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface DateModel : JSONModel

@property (nonatomic,strong)NSString* date;
@property (nonatomic,assign)NSNumber* timezone_type;
@property (nonatomic,strong)NSString* timezone;

@end

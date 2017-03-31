//
//  ReviewModel.h
//  paguide
//
//  Created by Evan Beh on 29/03/2017.
//  Copyright © 2017 Evan Beh. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface ReviewModel : JSONModel
@property (nonatomic,strong)NSString* user_name;
@property (nonatomic,strong)NSNumber* rate;
@property (nonatomic,strong)NSString* reviews;

@end

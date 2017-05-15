//
//  MerchantProfileModel.m
//  paguide
//
//  Created by Evan Beh on 15/03/2017.
//  Copyright © 2017 Evan Beh. All rights reserved.
//

#import "MerchantProfileModel.h"

@interface MerchantProfileModel()

@property (nonatomic, strong)NSString* favourite;

@end

@implementation MerchantProfileModel

+(BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}


+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc]initWithDictionary:@{
                                                      @"description": @"desc",
                                                      }];
}


-(BOOL)isFavourite
{
    if ([self.favourite isEqualToString:@"Y"]) {
        
        return YES;
    }
    else{
        return NO;

    }
}

-(void)setIsFavourite:(BOOL)isFavourite
{

    if (isFavourite) {
        _favourite = @"Y";
    }
    else
    {
        _favourite = @"N";

    }
}

@end

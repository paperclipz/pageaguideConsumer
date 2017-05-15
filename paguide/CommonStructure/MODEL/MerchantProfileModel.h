//
//  MerchantProfileModel.h
//  paguide
//
//  Created by Evan Beh on 15/03/2017.
//  Copyright © 2017 Evan Beh. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@protocol ReviewModel;
@interface MerchantProfileModel : JSONModel

@property (nonatomic, strong)NSString* merchant_id;
@property (nonatomic, strong)NSString* username;
@property (nonatomic, strong)NSString* gender;
@property (nonatomic, strong)NSString* profile_img;
@property (nonatomic, strong)NSString* cover_img;
@property (nonatomic, strong)NSString* badge_no;
@property (nonatomic, strong)NSString* badge_year;
@property (nonatomic, strong)NSString* desc;
@property (nonatomic, strong)NSNumber* overall_rating;
@property (nonatomic, strong)NSArray* language;
@property (nonatomic, strong)NSArray* specialty;
@property (nonatomic, strong)NSArray* qualifications;


@property (nonatomic, strong)NSString* name;
@property (nonatomic, strong)NSString* salutation;
@property (nonatomic, strong)NSString* email;
@property (nonatomic, strong)NSString* country;
@property (nonatomic, strong)NSString* mobile_number;
@property (nonatomic, strong)NSString* offer_currency;
@property (nonatomic, strong)NSString* offer_price;
@property (nonatomic, strong)NSString* offer_details;
@property (nonatomic, strong)NSArray<ReviewModel>* reviews;
@property (nonatomic, assign)BOOL isFavourite;


@property (nonatomic,assign)BOOL isSelect;
@property (nonatomic,assign)BOOL isExpand;

@end

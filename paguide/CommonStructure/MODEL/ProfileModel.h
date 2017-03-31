//
//  ProfileModel.h
//  paguide
//
//  Created by Evan Beh on 15/03/2017.
//  Copyright © 2017 Evan Beh. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface ProfileModel : JSONModel

@property (nonatomic,strong)NSString* username;
@property (nonatomic,strong)NSString* email;
@property (nonatomic,strong)NSString* gender;
@property (nonatomic,strong)NSString* profile_img;
@property (nonatomic,strong)NSString* fbid;
@property (nonatomic,strong)NSString* mobile_number;
@property (nonatomic,strong)NSString* country;
@property (nonatomic,strong)NSString* status;
@property (nonatomic,strong)NSString* token;
@property (nonatomic,strong)UIImage* uploadImage;
@property (nonatomic,strong)NSString* name;
// as view model
@property (nonatomic,strong)NSString* temp_prefix;
@property (nonatomic,strong)NSString* temp_mobile_number;
-(void)processPrefix:(VoidBlock)completion;


-(BOOL)getNotif_on;
-(BOOL)getSMS_on;

@end

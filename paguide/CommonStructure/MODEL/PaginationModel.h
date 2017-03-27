//
//  PaginationModel.h
//  paguide
//
//  Created by Evan Beh on 15/03/2017.
//  Copyright © 2017 Evan Beh. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface PaginationModel : JSONModel

@property (nonatomic,strong)NSNumber* total;
@property (nonatomic,strong)NSString* per_page;
@property (nonatomic,strong)NSNumber* current_page;
@property (nonatomic,strong)NSNumber* last_page;
@property (nonatomic,strong)NSString* next_page_url;
@property (nonatomic,strong)NSString* prev_page_url;
@property (nonatomic,strong)NSNumber* from;
@property (nonatomic,strong)NSNumber* to;

@end

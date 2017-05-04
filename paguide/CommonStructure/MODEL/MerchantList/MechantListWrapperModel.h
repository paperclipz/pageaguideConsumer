//
//  MechantListWrapperModel.h
//  paguide
//
//  Created by Evan Beh on 02/05/2017.
//  Copyright © 2017 Evan Beh. All rights reserved.
//

#import "BaseModel.h"

@protocol MerchantProfileModel;

@interface MechantListWrapperModel : BaseModel

@property(nonatomic,strong)PaginationModel* pageContent;
@property(nonatomic,strong)NSArray<MerchantProfileModel>* arrMerchantList;


@end

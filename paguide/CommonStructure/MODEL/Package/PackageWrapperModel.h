//
//  PackageWrapperModel.h
//  paguide
//
//  Created by Evan Beh on 15/03/2017.
//  Copyright © 2017 Evan Beh. All rights reserved.
//

#import "BaseModel.h"
#import "PaginationModel.h"
#import "PackageModel.h"


@protocol PackageModel;

@interface PackageWrapperModel : BaseModel

@property(nonatomic,strong)PaginationModel* pageContent;
@property(nonatomic,strong)NSArray<PackageModel>* arrPackageList;

@end

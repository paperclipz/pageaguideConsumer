//
//  PagingViewModel.h
//  paguide
//
//  Created by Evan Beh on 15/03/2017.
//  Copyright © 2017 Evan Beh. All rights reserved.
//

#import "BaseModel.h"
#import "PaginationModel.h"

@interface PagingViewModel : NSObject


@property (nonatomic,assign) BOOL isLoading;
@property (nonatomic,assign)int currentPage;
@property (nonatomic,assign) BOOL hasNext;

-(void)processPagingFrom:(PaginationModel*)model;

@end

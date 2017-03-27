//
//  PagingViewModel.m
//  paguide
//
//  Created by Evan Beh on 15/03/2017.
//  Copyright © 2017 Evan Beh. All rights reserved.
//

#import "PagingViewModel.h"

@implementation PagingViewModel


- (id) init
{
    if (self = [super init])
    {
        _isLoading = NO;
        _currentPage = 0;
        _hasNext = YES;
    }
    
    return self;
}

-(void)processPagingFrom:(PaginationModel*)model
{
    if (model.current_page < model.last_page) {
        
        self.hasNext = YES;
    }
    else{
        self.hasNext = NO;

    }
    
    self.currentPage = [model.current_page integerValue];
}
@end

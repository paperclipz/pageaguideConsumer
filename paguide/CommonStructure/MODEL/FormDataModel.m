//
//  FormDataModel.m
//  paguide
//
//  Created by Evan Beh on 20/03/2017.
//  Copyright © 2017 Evan Beh. All rights reserved.
//

#import "FormDataModel.h"

@interface FormDataModel()


@end
@implementation FormDataModel


-(id)copyWithZone:(NSZone *)zone
{
    id copy = [[[self class] alloc] init];
    for (NSString *key in [self codableProperties])
    {
        [copy setValue:[self valueForKey:key] forKey:key];
    }
    
    return copy;
    
}

+(BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}


-(NSMutableArray*)arrOptionsList
{
    
    if ([Utils isArrayNull:_arrOptionsList]) {
    
        NSMutableArray* array = [NSMutableArray new];

        if (![Utils isArrayNull:_answer_list]) {
            
            for (int i = 0; i<_answer_list.count; i++) {
                
                
                KeyValueModel* model = [KeyValueModel new];
                
                model.key = _answer_list[i];
                
                model.isSelected = NO;
                
                [array addObject:model];
                
            }
        }
        
        _arrOptionsList = array;
    }
    
    return _arrOptionsList;
}

-(KeyValueModel*)viewModel
{
    if (!_viewModel) {
        _viewModel = [KeyValueModel new];
    }
    
    return _viewModel;
}


-(BOOL)isRequired
{
    if ([self.required isEqualToString:@"yes"]) {
        return YES;
    }
    else{
        return NO;
        
    }
}

@end

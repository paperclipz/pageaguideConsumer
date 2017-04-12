//
//  RequestModel.m
//  paguide
//
//  Created by Evan Beh on 20/03/2017.
//  Copyright © 2017 Evan Beh. All rights reserved.
//

#import "RequestModel.h"
#import "FormDataModel.h"

@interface RequestModel()
@property(nonatomic,strong)NSDictionary<NSString*,NSArray*>* request_field;

@end

@implementation RequestModel

+(BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}

-(NSArray*)arrRequest_field
{
    if (!_arrRequest_field) {
        
        
        @try {
            NSArray* array;

            if ([_request_field isKindOfClass:[NSArray class]]) {
                
                array = (NSArray*)_request_field;

            }
            
            NSMutableArray* arrayForm = [NSMutableArray new];
            
            for (int i = 0; array.count; i++) {
                
                FormDataModel* model = [FormDataModel new];
                
                NSDictionary* dict = array[i];
                
                model.title = dict[@"title"];

                model.parameter = dict[@"parameter"];

                
                if ([dict[@"value"] isKindOfClass:[NSArray class]]) {
                    
                    NSArray* arrTemp = (NSArray*)dict[@"value"];
                    
                    
                    model.value = [arrTemp componentsJoinedByString:@", "];
                }
                
                else if([dict[@"value"] isKindOfClass:[NSString class]])
                {
                    model.value = dict[@"value"];

                }

                [arrayForm addObject:model];
                
                _arrRequest_field = arrayForm;
            }

        } @catch (NSException *exception) {
            
            
        } @finally {
        }
        
    }
    
    return _arrRequest_field;
}
@end

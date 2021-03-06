//
//  NSString+Extra.m
//  paguide
//
//  Created by Evan Beh on 04/04/2017.
//  Copyright © 2017 Evan Beh. All rights reserved.
//

#import "NSString+Extra.h"
#import <objc/runtime.h>


static const NSString *KEY_ATTRIBUTED_TEXT = @"KEY_ATTRIBUTED_TEXT";

@implementation NSString (AttributedText)

- (NSAttributedString *)customAttributedText
{
    return objc_getAssociatedObject(self, &KEY_ATTRIBUTED_TEXT);
}

- (void)setCustomAttributedText:(NSAttributedString *)customAttributedText
{

    
    objc_setAssociatedObject(self, &KEY_ATTRIBUTED_TEXT, customAttributedText, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
}

-(NSAttributedString*)getAttributedText
{
    
    if (self.customAttributedText) {
        
        return self.customAttributedText;
    }
    else{
        NSAttributedString* string = [[NSAttributedString alloc] initWithData:[self dataUsingEncoding:NSUTF8StringEncoding]
                                                                      options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
                                                                                NSCharacterEncodingDocumentAttribute: @(NSUTF8StringEncoding)}
                                                           documentAttributes:nil error:nil];
        
        self.customAttributedText = string;
        
        return string;
    }

}

-(void)getAttributedText:(NSAttributedSringBlock)completion
{
    if (self.customAttributedText) {
        
        if (completion) {
            completion(self.customAttributedText);
        }
    }
    else{
    
        
        dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            NSAttributedString* string = [[NSAttributedString alloc] initWithData:[self dataUsingEncoding:NSUTF8StringEncoding]
                                                                          options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
                                                                                    NSCharacterEncodingDocumentAttribute: @(NSUTF8StringEncoding)}
                                                               documentAttributes:nil error:nil];
            
            dispatch_async( dispatch_get_main_queue(), ^{
              
                self.customAttributedText = string;
                
                if (completion) {
                    completion(self.customAttributedText);
                }

            });
        });
        
    }
}

-(NSString*)validateText{
   
    if ([Utils isStringNull:self]) {
        
        
        return @"-";
    }
    else
    {
        return self;
    }
}
@end

@implementation NSString (Date)

-(NSString*)getFormattedDateFrom:(NSString*)fromType ToType:(NSString*)toType
{
    NSString *dateString = self;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:fromType];
    NSDate *dateFromString = [[NSDate alloc] init];
    dateFromString = [dateFormatter dateFromString:dateString];
    
    
    NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc] init];
    [dateFormatter2 setDateFormat:toType];
    NSString* strDateDisplay = [dateFormatter2 stringFromDate:dateFromString];
    

    
    return strDateDisplay;


}

+(NSString*)validateText:(NSString*)string{
    
    if ([Utils isStringNull:string]) {
        
        
        return @"-";
    }
    else
    {
        return string;
    }
}

@end

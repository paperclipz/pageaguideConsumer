//
//  NSString+Extra.h
//  paguide
//
//  Created by Evan Beh on 04/04/2017.
//  Copyright © 2017 Evan Beh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (AttributedText)

@property (nonatomic,strong)NSAttributedString* customAttributedText;

-(NSAttributedString*)getAttributedText;

-(void)getAttributedText:(NSAttributedSringBlock)completion;

@end

@interface NSString (Date)

-(NSString*)getFormattedDateFrom:(NSString*)fromType ToType:(NSString*)toType;

+(NSString*)validateText:(NSString*)string;


@end

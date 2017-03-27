//
//  UILabel+Extra.m
//  paguide
//
//  Created by Evan Beh on 24/03/2017.
//  Copyright © 2017 Evan Beh. All rights reserved.
//

#import "UILabel+Extra.h"

@implementation UILabel (Extra)

-(void)setCustomText:(NSString *)text
{
    if ([Utils isStringNull:text]) {
        
        self.text = @"-";
    }
    else
    {
        self.text = text;
    }
}
@end

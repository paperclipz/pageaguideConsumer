//
//  UIButton+System.m
//  paguide
//
//  Created by Evan Beh on 09/03/2017.
//  Copyright © 2017 Evan Beh. All rights reserved.
//

#import "UIButton+System.h"
#define BORDER_WIDTH 1.0f

@implementation UIButton (Design)


-(void)setDefaultBorder
{
    
    [[self layer] setBorderWidth:BORDER_WIDTH];
    [[self layer] setBorderColor:[UIColor clearColor].CGColor];
    [[self layer] setCornerRadius:5.0f];
    [[self layer] setMasksToBounds:YES];
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.backgroundColor = APP_MAIN_COLOR;
}


-(void)setInvertedBorder
{
    
    [[self layer] setBorderWidth:BORDER_WIDTH];
    [[self layer] setBorderColor:APP_MAIN_COLOR.CGColor];
    [[self layer] setCornerRadius:5.0f];
    [[self layer] setMasksToBounds:YES];
    [self setTitleColor:APP_MAIN_COLOR forState:UIControlStateNormal];
    self.backgroundColor = [UIColor whiteColor];

}


@end

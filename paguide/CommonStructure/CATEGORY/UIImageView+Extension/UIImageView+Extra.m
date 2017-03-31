//
//  UIImageView+Extra.m
//  paguide
//
//  Created by Evan Beh on 27/03/2017.
//  Copyright © 2017 Evan Beh. All rights reserved.
//

#import "UIImageView+Extra.h"

@implementation UIImageView(Extra)




- (void)setImageRenderingMode:(UIImageRenderingMode)renderMode
{
    NSAssert(self.image, @"Image must be set before setting rendering mode");
    self.image = [self.image imageWithRenderingMode:renderMode];
}

@end

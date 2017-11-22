//
//  MyCustomNavigationBar .m
//  paguide
//
//  Created by Evan Beh on 21/11/2017.
//  Copyright © 2017 Evan Beh. All rights reserved.
//

#import "MyCustomNavigationBar.h"

@implementation MyCustomNavigationBar

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    [self setupBackground];
}

- (void)setupBackground {
    self.backgroundColor = [UIColor clearColor];
    self.tintColor = [UIColor clearColor];
    
    // make navigation bar overlap the content
    self.translucent = YES;
    self.opaque = NO;
    
    // remove the default background image by replacing it with a clear image
    [self setBackgroundImage:[self.class maskedImage] forBarMetrics:UIBarMetricsDefault];
    
    // remove defualt bottom shadow
    [self setShadowImage: [UIImage new]];
}

+ (UIImage *)maskedImage {
    //const float colorMask[6] = {222, 255, 222, 255, 222, 255};
    UIImage *img = [UIImage imageNamed:@"nav-white-pixel-bg.jpg"];
    return [UIImage imageWithCGImage: CGImageCreateWithMaskingColors(img.CGImage,nil)];
}



@end

//
//  UIButton+System.h
//  paguide
//
//  Created by Evan Beh on 09/03/2017.
//  Copyright © 2017 Evan Beh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Foundation/Foundation.h>

@interface UIButton (Design)

-(void)setInvertedBorder;
-(void)setDefaultBorder;

@end


@interface UIButton (Rendering)

- (void)setImageRenderingMode:(UIImageRenderingMode)renderMode;

@end

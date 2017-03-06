//
//  TTTAttributedLabel+Block.m
//  paguide
//
//  Created by Evan Beh on 01/03/2017.
//  Copyright © 2017 Evan Beh. All rights reserved.
//

#import "TTTAttributedLabel+Block.h"
#import <objc/runtime.h>



static const NSString *SELECTION_BLOCK = @"selection_block";

@implementation TTTAttributedLabel (Block)

- (void)callBlock:(id)sender {
    StringBlock block = (StringBlock)objc_getAssociatedObject(self, &SELECTION_BLOCK);
    if (block) block(sender);
}

-(void)setup:(StringBlock)stringBlock
{
    objc_setAssociatedObject(self, &SELECTION_BLOCK, stringBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);

    NSString* term = @"By Using I had read the Terms of Service and the Privacy Policy";
    
    self.text = term;
    
    NSRange termofuse = [term rangeOfString:@"Terms of Service"];
    NSURL *url = [NSURL URLWithString:TERM_OF_USE];
    [self addLinkToURL:url withRange:termofuse];
    
    self.delegate = self;
}

- (void)attributedLabel:(__unused TTTAttributedLabel *)label
   didSelectLinkWithURL:(NSURL *)url
{
    
    if ([url.absoluteString isEqualToString:PRIVACY_POLICY]) {
        
        [self callBlock:PRIVACY_POLICY];
    }
            
    else if ([url.absoluteString isEqualToString:TERM_OF_USE])
    {
        [self callBlock:TERM_OF_USE];
    }
}


@end

//
//  TTTAttributedLabel+Block.h
//  paguide
//
//  Created by Evan Beh on 01/03/2017.
//  Copyright © 2017 Evan Beh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TTTAttributedLabel.h"

#define TERM_OF_USE @"TermsofService"
#define PRIVACY_POLICY @"PrivacyPolicy"

@interface TTTAttributedLabel(Block) <TTTAttributedLabelDelegate>

-(void)setup:(StringBlock)stringBlock;

@end

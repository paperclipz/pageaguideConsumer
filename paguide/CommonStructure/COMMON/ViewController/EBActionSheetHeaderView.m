//
//  EBActionSheetHeaderView.m
//  paguide
//
//  Created by Evan Beh on 03/04/2017.
//  Copyright © 2017 Evan Beh. All rights reserved.
//

#import "EBActionSheetHeaderView.h"

@implementation EBActionSheetHeaderView

- (IBAction)btnCloseClicked:(id)sender {
    
    if (self.didCloseBlock) {
        self.didCloseBlock();
    }
}


-(void)awakeFromNib{
    
    [super awakeFromNib];
    
    [self.btnClose setImage:[self.btnClose.imageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];

}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

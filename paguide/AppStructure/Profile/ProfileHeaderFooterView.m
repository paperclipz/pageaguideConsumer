//
//  ProfileHeaderFooterView.m
//  paguide
//
//  Created by Evan Beh on 01/03/2017.
//  Copyright © 2017 Evan Beh. All rights reserved.
//

#import "ProfileHeaderFooterView.h"

@interface ProfileHeaderFooterView()


@property (copy, nonatomic)IntBlock didSelectAtIndexBlock;
@end

@implementation ProfileHeaderFooterView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (IBAction)didSelectSegmentedControl:(UISegmentedControl *)sender {
//    if (sender.selectedSegmentIndex == 0) {
//        
//    
//    }
    
    if (self.didSelectAtIndexBlock ) {
        self.didSelectAtIndexBlock((int)sender.selectedSegmentIndex);
    }
}


-(void)setupSegmentedControlAtIndex:(IntBlock)indexPathBlock
{
    self.didSelectAtIndexBlock = indexPathBlock;
}


@end

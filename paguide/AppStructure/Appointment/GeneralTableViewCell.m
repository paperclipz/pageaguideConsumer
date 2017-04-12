//
//  GeneralTableViewCell.m
//  paguide
//
//  Created by Evan Beh on 09/03/2017.
//  Copyright © 2017 Evan Beh. All rights reserved.
//

#import "GeneralTableViewCell.h"

@implementation GeneralTableViewCell
- (IBAction)btnSelectionClicked:(id)sender {
    
    if (self.didSelectBlock) {
        self.didSelectBlock();
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)btnOneClicked:(id)sender {
    
    if (self.didSelectInnerButton1Block) {
        self.didSelectInnerButton1Block();
    }
}

@end

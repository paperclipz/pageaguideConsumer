//
//  FilterCategoryTableViewCell.m
//  paguide
//
//  Created by Evan Beh on 06/03/2017.
//  Copyright © 2017 Evan Beh. All rights reserved.
//

#import "FilterCategoryTableViewCell.h"

@implementation FilterCategoryTableViewCell
- (IBAction)ibSwitchClicked:(id)sender {
    
    if (self.didChangewitchBlock) {
        self.didChangewitchBlock();
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

//- (void)textFieldDidEndEditing:(UITextField *)textField
//{
//    
//    
//    
//  
//}
@end

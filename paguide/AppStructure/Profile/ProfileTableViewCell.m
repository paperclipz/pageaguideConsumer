//
//  ProfileTableViewCell.m
//  paguide
//
//  Created by Evan Beh on 06/03/2017.
//  Copyright © 2017 Evan Beh. All rights reserved.
//

#import "ProfileTableViewCell.h"

@interface ProfileTableViewCell() <UITextFieldDelegate>

@end
@implementation ProfileTableViewCell
- (IBAction)btnOneClicked:(id)sender {
    
    if (self.didSelectBlock) {
        self.didSelectBlock();
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.txtDefault.delegate = self;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
    
    if (self.didUpdateStringBlock) {
        self.didUpdateStringBlock(textField.text);
    }
}

@end


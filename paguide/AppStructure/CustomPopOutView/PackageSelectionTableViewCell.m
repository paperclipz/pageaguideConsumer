//
//  PackageSelectionTableViewCell.m
//  paguide
//
//  Created by Evan Beh on 20/03/2017.
//  Copyright © 2017 Evan Beh. All rights reserved.
//

#import "PackageSelectionTableViewCell.h"

@interface PackageSelectionTableViewCell()

@property(nonatomic,strong)NSNumber* selectedNumber;

@end
@implementation PackageSelectionTableViewCell

- (IBAction)btnMinusClicked:(id)sender {
    
    if ([self.selectedNumber integerValue] > 0) {
        
        self.selectedNumber = [NSNumber numberWithInteger:[self.selectedNumber integerValue] -1];
    }
    
    self.lblTitle.text = [self.selectedNumber stringValue];
    
    if (self.didUpdateQuantitytBlock)
    {
        self.didUpdateQuantitytBlock([self.selectedNumber intValue]);
    }

}
- (IBAction)btnPlusClicked:(id)sender {
    
    if ([self.selectedNumber integerValue] < [self.maxNumber integerValue]) {
        
        self.selectedNumber = [NSNumber numberWithInteger:[self.selectedNumber integerValue] +1];
    }
    
    self.lblTitle.text = [self.selectedNumber stringValue];

    if (self.didUpdateQuantitytBlock)
    {
        self.didUpdateQuantitytBlock([self.selectedNumber intValue]);
    }
}
- (IBAction)btnOneClicked:(id)sender {
    
    if (self.didSelectBlock) {
        self.didSelectBlock();
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.selectedNumber = @(0);
    
    self.maxNumber = @(0);
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

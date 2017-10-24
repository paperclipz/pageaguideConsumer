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
@property (nonatomic,strong)NSNumber* maxNumber;
@property (nonatomic,strong)NSNumber* minNumber;

@end
@implementation PackageSelectionTableViewCell

-(void)setupCellMinumber:(NSNumber*)minNumber MaxNumber:(NSNumber*)maxNumber SelectedNumber:(NSNumber*)selectedNumber
{
    _minNumber = minNumber;
    _maxNumber = maxNumber;
    _selectedNumber = selectedNumber;
}

- (IBAction)btnMinusClicked:(id)sender {
    
    if ([self.selectedNumber integerValue] > [self.minNumber integerValue]) {
        
        self.selectedNumber = [NSNumber numberWithInteger:[self.selectedNumber integerValue] -1];
    }
    else{
        self.selectedNumber = self.minNumber;
    }
    
    self.lblTitle.text = [NSString stringWithFormat:@"%@ pax",[self.selectedNumber stringValue]];
    
    if (self.didUpdateQuantitytBlock)
    {
        self.didUpdateQuantitytBlock([self.selectedNumber intValue]);
    }

}
- (IBAction)btnPlusClicked:(id)sender {
    
    if ([self.selectedNumber integerValue] < [self.maxNumber integerValue]) {
        
        self.selectedNumber = [NSNumber numberWithInteger:[self.selectedNumber integerValue] +1];
    }
    
    self.lblTitle.text = [NSString stringWithFormat:@"%@ pax",[self.selectedNumber stringValue]];

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


-(NSNumber*)maxNumber
{
    if (!_maxNumber) {
        _maxNumber = @(99);
    }
    
    return _maxNumber;
}


-(NSNumber*)minNumber
{
    if (!_minNumber) {
        _minNumber = @(0);
    }
    
    return _minNumber;
}

-(NSNumber*)selectedNumber
{
    if (!_selectedNumber) {
        
        
        _selectedNumber = self.minNumber;
    }
    
    return _selectedNumber;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

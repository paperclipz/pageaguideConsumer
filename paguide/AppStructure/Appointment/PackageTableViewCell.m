//
//  PackageTableViewCell.m
//  paguide
//
//  Created by Evan Beh on 03/03/2017.
//  Copyright © 2017 Evan Beh. All rights reserved.
//

#import "PackageTableViewCell.h"

@implementation PackageTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [Utils setRoundBorder:self.lblPackage color:APP_MAIN_COLOR borderRadius:5.0f];
    
    [Utils setRoundBorder:self.ibBorderView color:[UIColor clearColor] borderRadius:5.0f];
    
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

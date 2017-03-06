//
//  DashboardPackageTableViewCell.m
//  paguide
//
//  Created by Evan Beh on 01/03/2017.
//  Copyright © 2017 Evan Beh. All rights reserved.
//

#import "DashboardPackageTableViewCell.h"

@interface DashboardPackageTableViewCell()
@property (weak, nonatomic) IBOutlet UIView *ibContentView;

@end

@implementation DashboardPackageTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [Utils setRoundBorder:self.ibContentView color:[UIColor clearColor] borderRadius:5.0f];
    
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

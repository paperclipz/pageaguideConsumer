//
//  ChattingTableViewCell.m
//  paguide
//
//  Created by Evan Beh on 26/09/2017.
//  Copyright © 2017 Evan Beh. All rights reserved.
//

#import "ChattingTableViewCell.h"


@interface ChattingTableViewCell()
@property (weak, nonatomic) IBOutlet UIView *ibBorderView;

@end

@implementation ChattingTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [Utils setRoundBorder:self.ibBorderView color:[UIColor clearColor] borderRadius:10.0f];

    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setCellType:(BOOL)isOwn
{
    if (isOwn) {
        self.ibBorderView.backgroundColor = [UIColor colorWithRed:218.0/255.0 green:243.0f/255.0f blue:255.0f/255.0f alpha:1];
        self.lblMessage.textAlignment = NSTextAlignmentRight;
        self.lblUserName.textAlignment = NSTextAlignmentRight;
        self.lblMessage.textColor = [UIColor blackColor];
        
    }
    else{
        self.ibBorderView.backgroundColor = [UIColor whiteColor];
        self.lblMessage.textAlignment = NSTextAlignmentLeft;
        self.lblUserName.textAlignment = NSTextAlignmentLeft;
        self.lblMessage.textColor = [UIColor blackColor];
        
        
    }
}

@end

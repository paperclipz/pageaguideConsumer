//
//  RequestGuideTableViewCell.m
//  paguide
//
//  Created by Evan Beh on 20/03/2017.
//  Copyright © 2017 Evan Beh. All rights reserved.
//

#import "RequestGuideTableViewCell.h"

@interface RequestGuideTableViewCell() <UITextFieldDelegate>

@property(nonatomic,strong)KeyValueModel* model;

@end
@implementation RequestGuideTableViewCell

-(void)setupformData:(KeyValueModel*)data
{
    self.model = data;
    
    
    if (self.model.isSelected) {
        
        [self.btnSelection setImage:[UIImage imageNamed:@"icon_check_red.png"] forState:UIControlStateNormal];

    }
    else{
        [self.btnSelection setImage:[UIImage imageNamed:@"icon_uncheck_red.png"] forState:UIControlStateNormal];

    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.txtField.delegate = self;
    // Initialization code

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{

    
    NSString * finalString = [textField.text stringByReplacingCharactersInRange:range withString:string];

    if (self.didUpdateStringBlock)
    {
        self.didUpdateStringBlock(finalString);
    }
    
    return YES;
}

@end

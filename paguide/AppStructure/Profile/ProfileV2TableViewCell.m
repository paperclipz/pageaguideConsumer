//
//  ProfileV2TableViewCell.m
//  paguide
//
//  Created by Evan Beh on 23/11/2017.
//  Copyright © 2017 Evan Beh. All rights reserved.
//

#import "ProfileV2TableViewCell.h"

@implementation ProfileV2TableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    //edit mode
    if (self.tag == 1001) {
        [self addPaddingToView];
        
        // layer for trangle
        float cellHeight = self.ibBorderView2.frame.size.height;
        float cellWidth = self.ibBorderView2.frame.size.width;
        UIBezierPath *path = [UIBezierPath new];
        [path moveToPoint:(CGPoint){0,self.ibBorderView2.frame.origin.y+(cellHeight/2)}];
        [path addLineToPoint:(CGPoint){0,cellHeight}];
        [path addLineToPoint:(CGPoint){cellWidth,cellHeight}];
        [path addLineToPoint:(CGPoint){cellWidth, self.ibBorderView2.frame.origin.y+(cellHeight/2)}];
        [path addLineToPoint:(CGPoint){0,(self.ibBorderView2.frame.origin.y+cellHeight/2)}];
        CAShapeLayer *mask = [CAShapeLayer new];
        mask.frame = self.ibBorderView2.bounds;
        mask.path = path.CGPath;
        self.ibBorderView2.layer.mask = mask;
        // layer for trangle
        
     
    }
    
    else{
      
        // layer for trangle
        float cellHeight = self.ibBorderView2.frame.size.height;
        float cellWidth = self.ibBorderView2.frame.size.width;
        UIBezierPath *path = [UIBezierPath new];
        [path moveToPoint:(CGPoint){0,self.ibBorderView2.frame.origin.y+(cellHeight/2) +100}];
        [path addLineToPoint:(CGPoint){0,cellHeight}];
        [path addLineToPoint:(CGPoint){cellWidth,cellHeight}];
        [path addLineToPoint:(CGPoint){cellWidth, 0}];
        [path addLineToPoint:(CGPoint){0,self.ibBorderView2.frame.origin.y+cellHeight/2}];
        CAShapeLayer *mask = [CAShapeLayer new];
        mask.frame = self.ibBorderView2.bounds;
        mask.path = path.CGPath;
        self.ibBorderView2.layer.mask = mask;
        // layer for trangle
    }
    self.ibBorderView.backgroundColor = [UIColor clearColor];
    
    
    
    self.ibBorderView2.backgroundColor = [UIColor whiteColor];
    
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void)addPaddingToView
{
    [self addPaddingToView:self.ibButtonAction1];
    [self addPaddingToView:self.ibButtonAction2];
    
    [self addPaddingToView:self.txtField2];
    [self addPaddingToView:self.txtField];
    [self addPaddingToView:self.ibButtonAction3];
    
    
}

-(void)addPaddingToView:(UIView*)view
{
    UIView* tempView = [[UIView alloc]initWithFrame:CGRectMake(view.frame.origin.x, view.frame.size.height + view.frame.origin.y + 5, view.frame.size.width, 1)];
    
    tempView.backgroundColor = APP_MAIN_COLOR;
    
    [self.ibBorderView4 addSubview:tempView];
    
    
}
@end

//
//  UnratedCollectionViewCell.m
//  paguide
//
//  Created by Evan Beh on 30/05/2017.
//  Copyright © 2017 Evan Beh. All rights reserved.
//

#import "UnratedCollectionViewCell.h"

@interface UnratedCollectionViewCell() <UITextFieldDelegate>
{
    int tempRating;

}

@property (weak, nonatomic) IBOutlet UIButton *btnSubmit;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *arrCollectionRatingButton;

@end
@implementation UnratedCollectionViewCell

- (IBAction)btnSubmitClicked:(id)sender {
    
    
    [self.txtRating endEditing:YES];

    if(self.didFinishRateBlock) {
        self.didFinishRateBlock();
    }
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    tempRating  = 0;
    
    self.txtRating.delegate = self;
    
    [self.btnSubmit setDefaultBorder];
    
    
    for (int i = 0; i< _arrCollectionRatingButton.count;i++)
    {
        UIButton* btn = _arrCollectionRatingButton[i];
        
        btn.tag = i;
        
        [btn addTarget:self action:@selector(btnRateClicked:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    
    UIButton* button = _arrCollectionRatingButton[0];
    
    [self btnRateClicked:button];


}



-(IBAction)btnRateClicked:(id)sender
{
    UIButton* btn = (UIButton*)sender;
    
    tempRating = (int)btn.tag;
    
    for (int i = 0; i<_arrCollectionRatingButton.count; i++) {
        
        UIButton* tempButton = _arrCollectionRatingButton[i];
        
        if (tempButton.tag<=btn.tag) {
            
            [self setButtonSelected:YES Button:tempButton];
        }
        else{
            [self setButtonSelected:NO Button:tempButton];
            
        }
    }
    
    if (self.didRateClicked) {
        self.didRateClicked(self.rating);
    }
}


-(void)setRatingInView:(int)rating
{
    tempRating = rating-=1;
    
    for (int i = 0; i<_arrCollectionRatingButton.count; i++) {
        
        UIButton* tempButton = _arrCollectionRatingButton[i];
        
        if (tempButton.tag<= tempRating) {
            
            [self setButtonSelected:YES Button:tempButton];
        }
        else{
            [self setButtonSelected:NO Button:tempButton];
            
        }
    }
    

}

-(void)setButtonSelected:(BOOL)isSelected Button:(UIButton*)button
{
    
    if (isSelected) {
        [button setImage:[UIImage imageNamed:@"icon_star_full_red.png"] forState:UIControlStateNormal];
        
    }
    else
    {
        [button setImage:[UIImage imageNamed:@"icon_star_outline_red.png"] forState:UIControlStateNormal];
        
    }
}

-(int)rating
{
    return tempRating + 1;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
 
    if (self.didUpdateStringBlock) {
        self.didUpdateStringBlock(textField.text);
    }
}
@end

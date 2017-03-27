//
//  RatingViewController.m
//  paguide
//
//  Created by Evan Beh on 09/03/2017.
//  Copyright © 2017 Evan Beh. All rights reserved.
//

#import "RatingViewController.h"
#import "UIButton+System.h"
@interface RatingViewController ()
{
    int tempRating;
}
@property (weak, nonatomic) IBOutlet UIButton *btnSubmit;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *arrCollectionRatingButton;

@end

@implementation RatingViewController
- (IBAction)btnSubmitClicked:(id)sender {
    
    if (self.didFinishRateBlock) {
        self.didFinishRateBlock();
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    tempRating  = 0;
    
    [self.btnSubmit setDefaultBorder];
    
    
    for (int i = 0; i< _arrCollectionRatingButton.count;i++)
    {
        UIButton* btn = _arrCollectionRatingButton[i];
        
        btn.tag = i;
        
        [btn addTarget:self action:@selector(btnRateClicked:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    
    UIButton* button = _arrCollectionRatingButton[0];
    
    [self btnRateClicked:button];

    
    // Do any additional setup after loading the view from its nib.
}


-(IBAction)btnRateClicked:(id)sender
{
    UIButton* btn = (UIButton*)sender;
    
    tempRating = btn.tag;
    
    for (int i = 0; i<_arrCollectionRatingButton.count; i++) {
        
        UIButton* tempButton = _arrCollectionRatingButton[i];
        
        if (tempButton.tag<=btn.tag) {
            
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(int)rating
{
    return tempRating + 1;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

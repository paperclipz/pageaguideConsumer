//
//  GeneralTableViewCell.h
//  paguide
//
//  Created by Evan Beh on 09/03/2017.
//  Copyright © 2017 Evan Beh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RatingView.h"

@interface GeneralTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *ibBorderView;
@property (weak, nonatomic) IBOutlet UILabel *lblHeader;

@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblDescription;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle2;
@property (weak, nonatomic) IBOutlet UILabel *lblDescription2;
@property (weak, nonatomic) IBOutlet UIButton *btnSelection;
@property (weak, nonatomic) IBOutlet RatingView *ratingView;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle3;
@property (weak, nonatomic) IBOutlet UITextField *txtField;
@property (weak, nonatomic) IBOutlet UITextField *txtField2;
@property (weak, nonatomic) IBOutlet UITextField *txtField3;
@property (weak, nonatomic) IBOutlet UIButton *ibButton1;
@property (weak, nonatomic) IBOutlet UIButton *ibButton2;

@property (weak, nonatomic) IBOutlet UIButton *btnSend;
@property (weak, nonatomic) IBOutlet UIImageView *ibImageView;

@property(nonatomic,copy)VoidBlock didSelectBlock;

@property(nonatomic,copy)VoidBlock didSelectInnerButton1Block;

@property(nonatomic,copy)VoidBlock didSelectInnerButton2Block;

@property (nonatomic, copy)VoidBlock didSelectOnChatBlock;

@end

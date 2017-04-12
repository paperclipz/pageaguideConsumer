//
//  GeneralTableViewCell.h
//  paguide
//
//  Created by Evan Beh on 09/03/2017.
//  Copyright © 2017 Evan Beh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GeneralTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblDescription;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle2;
@property (weak, nonatomic) IBOutlet UILabel *lblDescription2;
@property (weak, nonatomic) IBOutlet UIButton *btnSelection;


@property(nonatomic,copy)VoidBlock didSelectBlock;

@property(nonatomic,copy)VoidBlock didSelectInnerButton1Block;

@end

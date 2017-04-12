//
//  FilterCategoryTableViewCell.h
//  paguide
//
//  Created by Evan Beh on 06/03/2017.
//  Copyright © 2017 Evan Beh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UITextField+Blocks.h"

@interface FilterCategoryTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UISwitch *ibSwitch;

@property (weak, nonatomic) IBOutlet UITextField *txtField;

@property(nonatomic,copy)VoidBlock didChangewitchBlock;


@end

//
//  ProfileTableViewCell.h
//  paguide
//
//  Created by Evan Beh on 06/03/2017.
//  Copyright © 2017 Evan Beh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfileTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblDesc;

@property (weak, nonatomic) IBOutlet UITextField *txtDefault;
@property (weak, nonatomic) IBOutlet UIButton *btnOne;

@property (nonatomic, copy)StringBlock didUpdateStringBlock;

@property (nonatomic, copy)VoidBlock didSelectBlock;

@end

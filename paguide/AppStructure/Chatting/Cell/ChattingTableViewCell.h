//
//  ChattingTableViewCell.h
//  paguide
//
//  Created by Evan Beh on 26/09/2017.
//  Copyright © 2017 Evan Beh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChattingTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lblMessage;
@property (weak, nonatomic) IBOutlet UILabel *lblUserName;

-(void)setCellType:(BOOL)isOwn;
@end

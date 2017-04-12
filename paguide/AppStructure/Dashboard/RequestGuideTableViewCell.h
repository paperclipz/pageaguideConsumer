//
//  RequestGuideTableViewCell.h
//  paguide
//
//  Created by Evan Beh on 20/03/2017.
//  Copyright © 2017 Evan Beh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FormDataModel.h"

@interface RequestGuideTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblDesc;
@property (weak, nonatomic) IBOutlet UIButton *btnSelection;
@property (weak, nonatomic) IBOutlet UITextField *txtField;

-(void)setupformData:(KeyValueModel*)data;

@property(nonatomic,copy)StringBlock didUpdateStringBlock;
@end

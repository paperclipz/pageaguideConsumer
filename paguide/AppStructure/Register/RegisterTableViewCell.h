//
//  RegisterTableViewCell.h
//  paguide
//
//  Created by Evan Beh on 27/02/2017.
//  Copyright © 2017 Evan Beh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTTAttributedLabel.h"


@protocol KeyValueModel;

@interface RegisterTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UITextField *txtDefault;
@property (weak, nonatomic) IBOutlet TTTAttributedLabel *lblCustomText;
-(void)setup:(NSString*)main KeyValue:(NSArray<KeyValueModel>*)array DidClickBlock:(StringBlock)completionStrBlock;
@property (weak, nonatomic) IBOutlet UILabel *lblCustomTitle;
@property (weak, nonatomic) IBOutlet UIButton *btnPrefix;
@property (weak, nonatomic) IBOutlet UIButton *btnCountry;

@property (nonatomic, copy)VoidBlock didSelectBlock;
@end

//
//  RegisterTableViewCell.h
//  paguide
//
//  Created by Evan Beh on 27/02/2017.
//  Copyright © 2017 Evan Beh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTTAttributedLabel.h"
#import "LoginViewModel.h"


typedef void(^LoginViewModelBlock) (LoginViewModel* model);

@protocol KeyValueModel;

@interface RegisterTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UITextField *txtDefault;
@property (weak, nonatomic) IBOutlet TTTAttributedLabel *lblCustomText;
-(void)setup:(NSString*)main KeyValue:(NSArray<KeyValueModel>*)array DidClickBlock:(StringBlock)completionStrBlock;//for attributed string
@property (weak, nonatomic) IBOutlet UILabel *lblCustomTitle;
@property (weak, nonatomic) IBOutlet UIButton *btnPrefix;
@property (weak, nonatomic) IBOutlet UIButton *btnCountry;

@property (nonatomic, copy)VoidBlock didSelectBlock;

@property(nonatomic,strong)LoginViewModel* loginViewModel;

@property (nonatomic, copy)LoginViewModelBlock didUpdateModelBlock;

@end

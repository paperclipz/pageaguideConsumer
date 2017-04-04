//
//  EBActionSheetHeaderView.h
//  paguide
//
//  Created by Evan Beh on 03/04/2017.
//  Copyright © 2017 Evan Beh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonView.h"

@interface EBActionSheetHeaderView : CommonView
@property (weak, nonatomic) IBOutlet UIButton *btnClose;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;

@property(nonatomic,copy)VoidBlock didCloseBlock;
@end

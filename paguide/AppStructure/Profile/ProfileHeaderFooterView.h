//
//  ProfileHeaderFooterView.h
//  paguide
//
//  Created by Evan Beh on 01/03/2017.
//  Copyright © 2017 Evan Beh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonView.h"

@interface ProfileHeaderFooterView : CommonView
@property (weak, nonatomic) IBOutlet UISegmentedControl *ibSegmentedControl;

-(void)setupSegmentedControlAtIndex:(IntBlock)indexPathBlock;
@end

//
//  EmptyStateView.h
//  paguide
//
//  Created by Evan Beh on 04/04/2017.
//  Copyright © 2017 Evan Beh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonView.h"

@interface EmptyStateView : CommonView
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblDesc;

@end

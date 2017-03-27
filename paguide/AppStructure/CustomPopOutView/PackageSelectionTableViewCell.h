//
//  PackageSelectionTableViewCell.h
//  paguide
//
//  Created by Evan Beh on 20/03/2017.
//  Copyright © 2017 Evan Beh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PackageSelectionTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *btnOne;

@property (weak, nonatomic) IBOutlet UILabel *lblTitle;

@property (nonatomic,copy)VoidBlock didSelectBlock;
@property (nonatomic,copy)IntBlock didUpdateQuantitytBlock;

@property (nonatomic,strong)NSNumber* maxNumber;
@end

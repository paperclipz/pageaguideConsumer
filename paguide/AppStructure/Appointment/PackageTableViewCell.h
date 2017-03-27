//
//  PackageTableViewCell.h
//  paguide
//
//  Created by Evan Beh on 03/03/2017.
//  Copyright © 2017 Evan Beh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PackageTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblTitle1;

@property (weak, nonatomic) IBOutlet UILabel *lblTitle2;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle3;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle4;

@property (weak, nonatomic) IBOutlet UILabel *lblPackage;
@end

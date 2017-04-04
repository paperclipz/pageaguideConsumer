//
//  EBActionSheetViewController.h
//  paguide
//
//  Created by Evan Beh on 28/02/2017.
//  Copyright © 2017 Evan Beh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EBActionSheetViewController : UIViewController


@property (nonatomic,strong)NSArray* arrItemList;

@property(nonatomic,copy)IndexPathBlock didSelectAtIndexBlock;

-(void)setInitial:(NSIndexPath*)indexPath;
@end

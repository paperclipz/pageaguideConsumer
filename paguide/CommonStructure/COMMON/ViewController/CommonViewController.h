//
//  CommonViewController.h
//  paguide
//
//  Created by Evan Beh on 27/03/2017.
//  Copyright © 2017 Evan Beh. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CommonViewController : UIViewController

@property (nonatomic, assign) BOOL isMiddleOfLoadingPage;

-(void)resetMainPage;
@end

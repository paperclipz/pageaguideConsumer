//
//  UINavigationController+Extension.m
//  paguide
//
//  Created by Evan Beh on 02/11/2017.
//  Copyright © 2017 Evan Beh. All rights reserved.
//

#import "UINavigationController+Extension.h"

@implementation UINavigationController (App)


-(void)setCustomAppNavigation
{
    self.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
    [self.navigationBar setTintColor:[UIColor whiteColor]];
    
    self.navigationBar.barTintColor = APP_MAIN_COLOR;
    
    [self.navigationBar setTranslucent:NO];
    
}
@end

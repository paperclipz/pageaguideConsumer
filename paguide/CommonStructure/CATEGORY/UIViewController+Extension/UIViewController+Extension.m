//
//  UIViewController+Extension.m
//  Seeties
//
//  Created by Lai on 12/05/2016.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import "UIViewController+Extension.h"

#import "RegisterViewController.h"

@implementation UIViewController (Extension)

- (UIViewController *)topVisibleViewController
{
    if ([self isKindOfClass:[UITabBarController class]])
    {
        UITabBarController *tabBarController = (UITabBarController *)self;
        return [tabBarController.selectedViewController topVisibleViewController];
    }
//    else if ([self isKindOfClass:[UINavigationController class]])
//    {
//        UINavigationController *navigationController = (UINavigationController *)self;
//        return [navigationController.visibleViewController topVisibleViewController];
//    }
//    else if (self.presentedViewController)
//    {
//        return [self.presentedViewController topVisibleViewController];
//    }
    else if (self.childViewControllers.count > 0)
    {
        return [self.childViewControllers.lastObject topVisibleViewController];
    }
    else if ([self isKindOfClass:[RegisterViewController class]]) {
        return self.parentViewController;// return parent view controller means dont want this to be top view controller
    }
//    else if ([self isKindOfClass:[PromoPopOutViewController class]]) {
//        return self.parentViewController;
//    }
    
    return self;
}


- (UIViewController *)topVisibleViewControllerForDeepLink
{
    if (self.presentedViewController)
    {
        return [self.presentedViewController topVisibleViewControllerForDeepLink];
    }
    else if (self.childViewControllers.count > 0)
    {
        return [self.childViewControllers.lastObject topVisibleViewControllerForDeepLink];
    }
    else if ([self isKindOfClass:[RegisterViewController class]]) {
        return self;
    }
    //    else if ([self isKindOfClass:[PromoPopOutViewController class]]) {
    //        return self.parentViewController;
    //    }
    
    return self;
}
@end

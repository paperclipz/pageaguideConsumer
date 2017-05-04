//
//  RequestGuideViewController.h
//  paguide
//
//  Created by Evan Beh on 01/03/2017.
//  Copyright © 2017 Evan Beh. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum
{
    RG_VIEW_TYPE_requestGuide = 1,
    RG_VIEW_TYPE_withMerchant = 2,
    
}RG_VIEW_TYPE;


//@import WWCalendarTimeSelector;

@interface RequestGuideViewController : UIViewController

@property(nonatomic, assign)RG_VIEW_TYPE viewType;

-(void)setupDataWithMerchantID:(NSString*)merchantID;

@end

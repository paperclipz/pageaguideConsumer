//
//  TourGuideListingViewController.h
//  paguide
//
//  Created by Evan Beh on 02/05/2017.
//  Copyright © 2017 Evan Beh. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef enum
{
    MERCHANT_LISTING_TYPE_FAVOURITE = 1,
    MERCHANT_LISTING_TYPE_NORMAL = 0,

    
}MERCHANT_LISTING_TYPE;


@interface TourGuideListingViewController : UIViewController
-(void)setupFavouriteTourGuideScreen;

@end

//
//  CoreBlock.h
//  Beep
//
//  Created by Page Advisor on 07/09/2016.
//  Copyright © 2016 Paperclipz. All rights reserved.
//

//#import <CoreLocation/CoreLocation.h>
//#import <GooglePlaces/GooglePlaces.h>

//@class ProfileModel;

#import "CountryModel.h"

typedef void(^BoolBlock) (BOOL isCollected);
typedef void(^VoidBlock) (void);
typedef void (^IDBlock)(id object);
typedef void (^IntBlock)(int count);
typedef void (^IndexPathBlock)(NSIndexPath* indexPath);
typedef void(^StringBlock) (NSString* str);
typedef void (^NSDateBlock)(NSDate* date);
typedef void(^NSArrayBlock) (NSArray* array);


typedef void (^IDBlock)(id object);
typedef void (^IErrorBlock)(id object);
//typedef void(^CLLocationCoordinate2DBlock) (CLLocationCoordinate2D coordinate);



//typedef void (^ProfileModelBlock)(ProfileModel* model);
//typedef void(^CLLocationBlock) (CLLocation* location);
//typedef void(^GMSPlaceBlock) (GMSPlace* location);

typedef void(^CountryModelBlock) (CountryModel* model);

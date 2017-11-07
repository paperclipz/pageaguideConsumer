//
//  AppConstant.h
//  Beep
//
//  Created by Page Advisor on 07/09/2016.
//  Copyright © 2016 Paperclipz. All rights reserved.
//

#import <Foundation/Foundation.h>


// ======================== General Declaration ======================== //
#define intercom_key @"ios_sdk-1eb6d861cfa6e01d9a894110a348906601d33fe7"
#define intercom_appID @"zex5tsam"
#define SERVICE_TOKEN @"iw-V8JRku6nEmUnz7GJOpsJ_0-D7z0resdYmnJQirsU"

#if IS_DEV
// ======================== DEV Declaration ======================== //


#define SERVER_PATH_LIVE @"devpage.pageadvisor.com"
#define STRIPE_KEY @"pk_test_useqkPsXfsDnNPCl6F4VIgMO"


#else
// ======================== LIVE Declaration ======================== //

#define SERVER_PATH_LIVE @"api.pageaguide.co"
#define STRIPE_KEY @"pk_live_IOkEGSzykdC7NpYukrik4Oh7"


#endif



@interface AppConstant : NSObject

#define SUCCESSFUL @"00"

#define APP_MAIN_COLOR [UIColor colorWithRed:209.0/255.0f green:18.0f/255.0f blue:18.0f/255.0f alpha:1]

#define PHOTO_PLACEHOLDER [UIImage imageNamed:@"placeholder_photo.png"]

#define AVATAR_PLACEHOLDER [UIImage imageNamed:@"placeholder_profile.png"]

//#define APP_Version @"1.0.2"

#define IS_SIMULATOR NO
#pragma mark - App Definition
#define T_N_C @"By registring I had agree with the Terms of Service and Privacy Policy."//



//==================== NOTIFICATION CENTER ====================//
#define NOTIF_CENTER_LOGIN @"notf_center_login"
@end

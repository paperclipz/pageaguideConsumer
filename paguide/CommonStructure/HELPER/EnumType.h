//
//  EnumType.h
//  Beep
//
//  Created by Page Advisor on 07/09/2016.
//  Copyright © 2016 Paperclipz. All rights reserved.
//

typedef enum
{
    AFNETWORK_GET = 1,
    AFNETWORK_POST = 2,
    AFNETWORK_DELETE = 3,
    AFNETWORK_PUT = 4,
    AFNETWORK_CUSTOM_GET = 5,
    AFNETWORK_CUSTOM_POST = 6,
    
}AFNETWORK_TYPE;

typedef enum
{
    //  ==========  [ access ]  ==========  //
    ServerRequestTypePostUserRegister,
    ServerRequestTypePostUserLogin,
    ServerRequestTypePostUserResendOTP,
    ServerRequestTypePostUserVerifyOTP,
    ServerRequestTypePostUserCountry_Listing,
    ServerRequestTypePostUserForgotPassword,
    ServerRequestTypePostUserProfile,
    ServerRequestTypePostUserUpdateProfile,
    ServerRequestTypePostGuestLogin,
    //  ==========  [ access ]  ==========  //
    
    ServerRequestTypePostPackagesCategoryList,
    ServerRequestTypePostPackageListing,
    ServerRequestTypePostPackageDetailsInfo,
    ServerRequestTypePostUserRequestFormFormat,
    //  ==========  [ package ]  ==========  //

    
    //  ==========  [ appointment ]  ==========  //
    ServerRequestTypePostAppointmentListing,
    ServerRequestTypePostPendingAppointmentListing,
    ServerRequestTypePostAppointmentComplete,
    ServerRequestTypePostAppointmentValidatecode,
    ServerRequestTypePostAppointmentCheckComplete,

    //  ==========  [ appointment ]  ==========  //
    ServerRequestTypePostHistoryListing,
    ServerRequestTypePostPromocodeCheck,
    ServerRequestTypePostPackagePurchase,
    
    //  ==========  [ Request ]  ==========  //

    ServerRequestTypePostRequestConsumerlisting,
    
    //  ==========  [ Request ]  ==========  //
    ServerRequestTypePostPaymentStripeCharge,
    ServerRequestTypePostRequestBiddinglist,
    ServerRequestTypePostRequestBidselection,
    ServerRequestTypePostRequestCreate,
    ServerRequestTypePostRequestCancel,
    
    ServerRequestTypePostHomeVersion,
    ServerRequestTypePostUserRegisterdevice,
    
    ServerRequestTypePostRequestComment,
    //  ==========  [ Merchant List ]  ==========  //

    ServerRequestTypePostMerchantCategorylist,
    ServerRequestTypePostMerchantListing,
    ServerRequestTypePostMerchantDetails,
    ServerRequestTypePostMerchantFavouriteListing,
    ServerRequestTypePostMerchantFavourite,
    //  ==========  [ Merchant List ]  ==========  //
}ServerRequestType;

typedef enum
{
    REGISTER_CELL_TYPE_email_address = 1,
    REGISTER_CELL_TYPE_name = 2,
    REGISTER_CELL_TYPE_country = 3,
    REGISTER_CELL_TYPE_phone_number = 4,
    REGISTER_CELL_TYPE_TNC = 5,
    REGISTER_CELL_TYPE_Password = 6,
    REGISTER_CELL_TYPE_RE_Password = 7,
}REGISTER_CELL_TYPE;

typedef enum
{
    APPOITNMENT_VIEW_TYPE_VERIFY = 1,
    APPOITNMENT_VIEW_TYPE_COMPLETE = 2,
    APPOITNMENT_VIEW_TYPE_HISTORY = 3,
    APPOITNMENT_VIEW_TYPE_PENDING = 4,

}APPOITNMENT_VIEW_TYPE;



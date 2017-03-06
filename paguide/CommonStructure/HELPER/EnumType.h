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
    ServerRequestTypePostAccessLogin,
    ServerRequestTypePostAccessRegistration,
    ServerRequestTypePostAccessVerification,
    ServerRequestTypePostAccessPasswordRenewal,
    ServerRequestTypePostAccessReset,
    ServerRequestTypePostAccessPasswordVerifications,
    ServerRequestTypePostAccessUsernamesAvailability,
    //  ==========  [ access ]  ==========  //
    //  ==================================  //
    
    //  ==========  [ Customers ]  ==========  //
    ServerRequestTypeGetCustomer,
    ServerRequestTypePostCustomerCompletions,
    ServerRequestTypePostCustomerJwt,
    ServerRequestTypePostCustomerLogouts,
    ServerRequestTypePostCustomerPasswords,
    ServerRequestTypePostCustomerPicture,
    ServerRequestTypePostCustomerTutorial,
    ServerRequestTypePostCustomerRevision,
    ServerRequestTypePostCustomerPostsInfosHelpersStatus,
    ServerRequestTypePostCustomerPostsHelpsHelpersStatus,
    ServerRequestTypePostCustomerPostsFBConnects,
    ServerRequestTypeGetCustomerPreference,
    ServerRequestTypePostCustomerPreference,
    ServerRequestTypePostCustomerPurchase,
    //  ==========  [ Customers ]  ==========  //
    //  =====================================  //
    
    
    //  ==========  [ Owner Get Info ]  ==========  //
    ServerRequestTypePostInfo,
    ServerRequestTypePostInfoCloses,
    ServerRequestTypePostInfoHelpersCreateChat,
    ServerRequestTypePostInfohelpersHigh5s,
    ServerRequestTypePostCustomerInfoHelpersSpams,
    ServerRequestTypePostInfoHelpersStatus,
    ServerRequestTypePostInfoHelpersCancellations,
    ServerRequestTypePostInfoHelpersChat,
    //  ==========  [ Owner Get Info  ]  ==========  //
    //  =====================================  //
    
    
    //  ==========  [ Owner Get Help ]  ==========  //
    ServerRequestTypePostHelp,
    ServerRequestTypePostHelpCloses,
    ServerRequestTypePostHelpThanks,
    ServerRequestTypePostHelpHelpersChat,
    ServerRequestTypePostCustomerHelpHelpersSpams,
    ServerRequestTypePostHelpHelpersStatus,
    ServerRequestTypePostHelpHelpersCreateChat,
    ServerRequestTypePostHelpHelpersCancellations,
    //  ==========  [ Owner Get Help  ]  ==========  //
    //  ===========================================  //
    
    
    //  ==========  [ Beep Resources ]  ==========  //

    ServerRequestTypeGetBeepOwnRequestor,
    ServerRequestTypeGetBeepOthersRequestor,
    
    //  ==========  [ Beep Resources ]  ==========  //
    //  ==========================================  //

    

    //  ==========  [ Notification ]  ==========  //
    
    ServerRequestTypeGetCustomerNotifications,
    ServerRequestTypePostCustomerNotificationsReads,
    
    //  ==========  [ Notification ]  ==========  //
    //  ========================================  //
    
    
    
    //  ==========  [ GetInfoResources ]  ==========  //
    
    ServerRequestTypePostInfosHelpersReplies,
    ServerRequestTypePostInfosHelpersSpams,
    ServerRequestTypeGetInfosReplies,
    ServerRequestTypeGetInfosRequestors,
    //  ==========  [ GetInfoResources ]  ==========  //
    //  ========================================  //
    
    //  ==========  [ GetHelpResources ]  ==========  //

    ServerRequestTypeGetHelpsRequestors,
    ServerRequestTypePostHelpsHelpersOffers,
    ServerRequestTypePostHelpHelpersSpams,
    //  ==========  [ GetHelpResources ]  ==========  //

    ServerRequestTypeGetPostHelpersChat,
    
    //  ==========  [ GET StoreResource  ]  ==========  //
    
    ServerRequestTypeGetStoreCredits,
    ServerRequestTypeGetCreditConsumptions,

    
    //  ==========  [ GET StoreResource  ]  ==========  //

    

    //  ==========  [ GET ChatResources  ]  ==========  //
    
    ServerRequestTypePostChatResponderStatus
    //  ==========  [ GET ChatResources  ]  ==========  //
    


}ServerRequestType;


typedef enum
{
    REGISTER_CELL_TYPE_email_address = 1,
    REGISTER_CELL_TYPE_name = 2,
    REGISTER_CELL_TYPE_country = 3,
    REGISTER_CELL_TYPE_phone_number = 4,
    REGISTER_CELL_TYPE_TNC = 5,
    
}REGISTER_CELL_TYPE;



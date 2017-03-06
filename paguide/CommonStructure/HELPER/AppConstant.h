//
//  AppConstant.h
//  Beep
//
//  Created by Page Advisor on 07/09/2016.
//  Copyright © 2016 Paperclipz. All rights reserved.
//

#import <Foundation/Foundation.h>

#define APP_MAIN_COLOR [UIColor colorWithRed:43.0/255.0f green:57.0/255.0f blue:144.0/255.0f alpha:1]

@interface AppConstant : NSObject

#define SUCCESSFUL @"00"

#define ERROR  @"99"
#define SESSION_EXPIRED @"SESS_EXPIRED"

/* Shared modules */
#define USER_NOT_FOUND @"BB000_001"

/* Resource URI for BB001 - AccessResource */
/* /usernames/availability */
#define USERNAME_NA @"BB001_001"

/* /verifications, /passwords/verifications */
#define VERIFICATION_NOT_FOUND @"BB001_002"
#define VERIFICATION_REUSED @"BB001_003"
#define VERIFICATION_EXCEEDED_ATTEMPT @"BB001_004"
#define VERIFICATION_EXCEEDED_TIMEFRAME @"BB001_005"
#define INVALID_VERIFICATION_PIN @"BB001_006"

/* /passwords/resets */
#define USER_INCOMPLETE_REGISTRATION @"BB001_014"

/* /logins */
#define USER_DISABLED @"BB001_007"
#define USER_LOCKED @"BB001_008"

/* /passwords/renewals */
#define RESET_NOT_FOUND @"BB001_009"
#define RESET_NOT_VERIFIED @"BB001_010"
#define RESET_REUSED @"BB001_011"

/* /registrations */
#define ALREADY_REGISTERED @"BB001_012"
#define INVALID_REFRESH_TOKEN @"BB001_013"

/* Resource URI for BB003 - OwnerGetInfoResource & GetInfoResource */
#define GETINFO_NOT_FOUND @"BB003_001"
#define GETINFO_CLOSE_PERMISSION_DENIED @"BB003_002"
#define GETINFO_NOT_VALID @"BB003_003"
#define GETINFO_ALREADY_REPLIED @"BB003_004"
#define GETINFO_OWNER_REPLY_DENIED @"BB003_005"
#define GETINFO_OWNER_HIGH5_DENIED @"BB003_006"
#define GETINFO_NONOWNER_HIGH5_DENIED @"BB003_007"
#define GETINFO_NONRESPONDER_HIGH5_DENIED @"BB003_008"
#define GETINFO_ALREADY_CLOSED @"BB003_009"
#define GETINFO_OWNER_MARK_DENIED @"BB003_010"
#define GETINFO_NONOWNER_MARK_DENIED @"BB003_011"
#define GETINFO_NONRESPONDER_MARK_DENIED @"BB003_012"
#define GETINFO_OWNER_REPLYSPAM_DENIED @"BB003_013"
#define GETINFO_NONOWNER_REPLYSPAM_DENIED @"BB003_014"
#define GETINFO_NONRESPONDER_REPLYSPAM_DENIED @"BB003_015"
#define GETINFO_OWNER_SPAM_DENIED @"BB003_016"
#define GETINFO_HELPER_SPAM_ALREADY_REPORTED @"BB003_017"
#define GETINFO_NONOWNER_CREATECHAT_DENIED @"BB003_018"
#define GETINFO_OWNER_CREATECHAT_INVALID_TARGET @"BB003_019"
#define GETINFO_CLOSECHAT_INVALID_TARGET @"BB003_020"
#define GETINFO_STATUS_NOT_SUPPORTED @"BB003_021"
#define GETINFO_CLOSECHAT_INVALID_PERMISSION_USER @"BB003_022"
#define GETINFO_CLOSECHAT_INVALID_PERMISSION_POST @"BB003_023"
#define GETINFO_CLOSECHAT_INVALID_PERMISSION @"BB003_024"
#define GETINFO_CHAT_DENIED @"BB003_025"
#define GETINFO_UNAUTHORIZED_ACCESS @"BB003_026"
#define GETINFO_CHAT_INVALID_TARGET @"BB003_027"
#define GETINFO_DISABLED @"BB003_028"
#define GETINFO_OWNER_CHOOSE_DENIED @"BB003_029"
#define GETINFO_NONOWNER_CHOOSE_DENIED @"BB003_030"
#define GETINFO_NONRESPONDER_CHOOSE_DENIED @"BB003_031"

/* Resource URI for BB004 - OwnerGetHelpResource & GetHelpResource */
#define GETHELP_UNSUPPORTED_CATEGORY @"BB004_001"
#define GETHELP_NOT_FOUND @"BB004_002"
#define GETHELP_NOT_VALID @"BB004_003"
#define GETHELP_DISABLED @"BB004_004"
#define GETHELP_CLOSE_PERMISSION_DENIED @"BB004_005"
#define GETHELP_ALREADY_CLOSED @"BB004_006"
#define GETHELP_OWNER_OFFER_DENIED @"BB004_007"
#define GETHELP_ALREADY_OFFERED @"BB004_008"
#define GETHELP_OWNER_CHOOSE_DENIED @"BB004_009"
#define GETHELP_NONOWNER_CHOOSE_DENIED @"BB004_010"
#define GETHELP_NONRESPONDER_CHOOSE_DENIED @"BB004_011"
#define GETHELP_UNSUPPORTED_ACTION @"BB004_012"
#define GETHELP_OWNER_THANK_DENIED @"BB004_013"
#define GETHELP_NONOWNER_THANK_DENIED @"BB004_014"
#define GETHELP_NONOWNER_CREATECHAT_DENIED @"BB004_015"
#define GETHELP_OWNER_CREATECHAT_INVALID_TARGET @"BB004_016"
#define GETHELP_CHAT_DENIED @"BB004_017"
#define GETHELP_UNAUTHORIZED_ACCESS @"BB004_018"
#define GETHELP_CHAT_INVALID_TARGET @"BB004_019"
#define GETHELP_STATUS_NOT_SUPPORTED @"BB004_020"
#define GETHELP_CLOSECHAT_INVALID_TARGET @"BB004_021"
#define GETHELP_CLOSECHAT_INVALID_PERMISSION @"BB004_022"
#define GETHELP_CLOSECHAT_INVALID_PERMISSION_USER @"BB004_023"
#define GETHELP_CLOSECHAT_INVALID_PERMISSION_POST @"BB004_024"

/* Resource URI for BB005 - ChatResource */
#define CHAT_INVALID_TARGET @"BB005_001"
#define CHAT_DENIED @"BB005_002"
#define POST_ALREADY_CLOSED @"BB005_003"
#define POST_DISABLED @"BB005_004"
#define CHAT_STATUS_NOT_SUPPORTED @"BB005_005"
#define CHAT_CLOSE_INVALID_TARGET @"BB005_006"
#define CHAT_CLOSE_INVALID_PERMISSION @"BB005_007"
#define CHAT_ALREADY_CLOSED @"BB005_008"




#define CAT_TYPE_RIDE @"RIDE"
#define CAT_TYPE_STAY @"STAY"
#define CAT_TYPE_TOUR @"TOUR"
#define CAT_TYPE_BUY @"BUY"
#define CAT_TYPE_DELIVER @"DELIVER"
#define CAT_TYPE_MOVE @"MOVE"
#define CAT_TYPE_INFO @"INFO"


#define NOTF_OFFER_HELP @"OFFER_HELP"
#define NOTF_CANCEL_HELP @"CANCEL_HELP"
#define NOTF_OFFER_INFO @"OFFER_INFO"
#define NOTF_CANCEL_INFO @"CANCEL_INFO"
#define NOTF_HIGH5 @"HIGH5"
#define NOTF_THANK @"THANK"
#define NOTF_CREATE_CHAT @"CREATE_CHAT"
#define NOTF_CHAT @"CHAT"
#define NOTF_ACCEPT_INFO @"ACCEPT_INFO"
#define NOTF_CHOOSE_HELP @"CHOOSE_HELP"


#define ACTION_DETAIL @"DETAIL"
#define ACTION_CHAT @"CHAT"

#pragma mark - App Definition
#define T_N_C @"By registring I had agree with the Terms of Service and Privacy Policy."//

@end


#import <Foundation/Foundation.h>

#import <TSMessages/TSMessageView.h>

@interface MessageManager : NSObject

+(void)showMessage:(NSString *)message Type:(TSMessageNotificationType)type;

+(void)showMessage:(NSString *)message Type:(TSMessageNotificationType)type inViewController:(UIViewController*)vc;

@end

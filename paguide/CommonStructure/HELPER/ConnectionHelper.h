//
//  ConnectionHelper.h
//  Beep
//
//  Created by Page Advisor on 07/09/2016.
//  Copyright © 2016 Paperclipz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EnumType.h"

@interface ConnectionHelper : NSObject

- (NSString *)getLocalData:(ServerRequestType)type;

- (BOOL)validateBeforeRequest:(ServerRequestType)type;

- (void)storeServerData:(id)obj requestType:(ServerRequestType)type;

@end
//
//  NSDate+Extra.h
//  Beep
//
//  Created by Evan Beh on 05/10/2016.
//  Copyright © 2016 Paperclipz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate(Extra)

-(NSString*)toString;

-(NSString*)toLocalTime;

-(NSString*)toServerString;

@end

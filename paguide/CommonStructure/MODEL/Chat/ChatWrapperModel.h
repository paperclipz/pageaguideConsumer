//
//  ChatWrapperModel.h
//  paguide
//
//  Created by Evan Beh on 29/09/2017.
//  Copyright © 2017 Evan Beh. All rights reserved.
//

#import <JSONModel/JSONModel.h>

#import "ChatModel.h"

@protocol ChatModel;
@interface ChatWrapperModel : PaginationModel

@property(nonatomic,strong)NSArray<ChatModel>* arrChatList;
@end

//
//  UITableView+Extra.h
//  Beep
//
//  Created by Evan Beh on 29/09/2016.
//  Copyright © 2016 Paperclipz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FooterView.h"

@interface UITableView(refresh)

-(void)pullToRefresh:(VoidBlock)refresh;

-(void)stopRefresh;

@property(nonatomic)UIRefreshControl* refreshControl;
@end


@interface UITableView(Footer)

@property (nonatomic)FooterView* footerView;
-(void)startFooterLoadingView;
-(void)stopFooterLoadingView;
-(void)setupFooterView;


-(void)scrollViewDidScroll:(UIScrollView *)scrollView activated:(VoidBlock)activate;
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView activated:(VoidBlock)activate;

@end



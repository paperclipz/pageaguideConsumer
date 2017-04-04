//
//  UITableView+Extra.m
//  Beep
//
//  Created by Evan Beh on 29/09/2016.
//  Copyright © 2016 Paperclipz. All rights reserved.
//

#import "UITableView+Extra.h"
#import <objc/runtime.h>

static const NSString *REFRESH_CONTROL = @"refreshControl";

static const NSString *REFRESH_BLOCK = @"refreshblock";

@implementation UITableView(refresh)


- (void)callBlock:(id)sender {
    VoidBlock block = (VoidBlock)objc_getAssociatedObject(self, &REFRESH_BLOCK);
    if (block) block();
}

-(void)stopRefresh
{
    [self.refreshControl endRefreshing];
    
}


-(void)pullToRefresh:(VoidBlock)refresh
{
    objc_setAssociatedObject(self, &REFRESH_BLOCK, refresh, OBJC_ASSOCIATION_COPY_NONATOMIC);

    
    if (!self.refreshControl) {
       
        self.refreshControl = [[UIRefreshControl alloc] init];
        [self.refreshControl addTarget:self
                                action:@selector(callBlock:)
                      forControlEvents:UIControlEventValueChanged];
        
        [self addSubview:self.refreshControl];
    }
    

}

- (UIRefreshControl *)refreshControl
{
    return objc_getAssociatedObject(self, &REFRESH_CONTROL);
}

- (void)setRefreshControl:(UIRefreshControl *)refreshControl
{
    
    objc_setAssociatedObject(self, &REFRESH_CONTROL, refreshControl, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
}

@end
static const NSString *FOOTER_KEY = @"footer_key";
static const NSString *INDICATOR_KEY = @"indicator_key";

@implementation UITableView(footer)

-(void)setupFooterView
{
    self.footerView = [FooterView initializeCustomView];
    
        if (self.footerView.ibCustomActivityIndicator) {
            self.footerView.ibCustomActivityIndicator.hidesWhenStopped = YES;
            
        }
        self.tableFooterView = self.footerView;
}


- (FooterView *)footerView;
{
    return objc_getAssociatedObject(self, &FOOTER_KEY);
}

- (void)setFooterView:(FooterView *)footerView
{
//    if (self.ibCustomActivityIndicator.superview) {
//        [self.ibCustomActivityIndicator removeFromSuperview];
//    }
    objc_setAssociatedObject(self, &FOOTER_KEY, footerView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
}


-(void)startFooterLoadingView
{
    
    @try {
        self.tableFooterView = self.footerView;
        
        [self.footerView.ibCustomActivityIndicator startAnimating];
        
    }
    @catch (NSException *exception) {
    }
    
}
-(void)stopFooterLoadingView
{
    @try {
        [self.footerView.ibCustomActivityIndicator stopAnimating];
        self.tableFooterView = nil;
    }
    @catch (NSException *exception) {
    }
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView activated:(VoidBlock)activate{
    
    CGFloat currentOffset = self.contentOffset.y;
    CGFloat maximumOffset = self.contentSize.height - self.frame.size.height;
    
    
    // Change 10.0 to adjust the distance from bottom
    if (maximumOffset - currentOffset <= 50) {
       
        if (activate) {
            activate();
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView activated:(VoidBlock)activate{
    
    // UITableView only moves in one direction, y axis
    CGFloat currentOffset = scrollView.contentOffset.y;
    CGFloat maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height;
    
    //NSInteger result = maximumOffset - currentOffset;
    
    // Change 10.0 to adjust the distance from bottom
    
    
    NSLog(@"offset !--! == %f",maximumOffset - currentOffset);
    
    if (maximumOffset - currentOffset <= 100.0) {

        if (activate) {
            activate();
        }
    }
}

@end

static const NSString *KEY_EMPTY_STATE_VIEW = @"empty_state_view";

@implementation UITableView(EmptyState)

- (EmptyStateView *)customEmptyStateView;
{
    return objc_getAssociatedObject(self, &KEY_EMPTY_STATE_VIEW);
}

- (void)setCustomEmptyStateView:(EmptyStateView *)customEmptyStateView
{
    
    objc_setAssociatedObject(self, &KEY_EMPTY_STATE_VIEW, customEmptyStateView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
}

-(void)setupCustomEmptyView
{
    self.customEmptyStateView = [EmptyStateView initializeCustomView];
    self.customEmptyStateView.lblDesc.text = (@"There's no data available");
    self.customEmptyStateView.lblTitle.text = (@"");
  //  self.backgroundView = self.customEmptyStateView;
    
}

//-(void)showLoading
//{
//    [self.customEmptyStateView showLoading];
//}

-(void)showEmptyState
{

    self.backgroundView = self.customEmptyStateView;

}

-(void)hideAll
{
    
    self.backgroundView = nil;
    
}

-(void)customTableViewReloadData
{
    if ([self.dataSource tableView:self numberOfRowsInSection:0]>0) {
        
        [self hideAll];
    }
    else{
        [self showEmptyState];
    }
}
@end


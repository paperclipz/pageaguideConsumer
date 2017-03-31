//
//  WebViewController.m
//  paguide
//
//  Created by Evan Beh on 27/03/2017.
//  Copyright © 2017 Evan Beh. All rights reserved.
//

#import "WebViewController.h"
#import "UIImageView+Extra.h"
@interface WebViewController ()<UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *ibImgClose;
@property (weak, nonatomic) IBOutlet UIWebView *ibWebView;
@end

@implementation WebViewController

- (IBAction)btnCloseClicked:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    NSURL* url = [NSURL URLWithString:_webViewURL];
    
    NSURLRequest* request = [[NSMutableURLRequest alloc]initWithURL:url];
    
    [self.ibWebView loadRequest:request];
    
    
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

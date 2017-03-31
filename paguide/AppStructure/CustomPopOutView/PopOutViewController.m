//
//  PopOutViewController.m
//  paguide
//
//  Created by Evan Beh on 29/03/2017.
//  Copyright © 2017 Evan Beh. All rights reserved.
//

#import "PopOutViewController.h"

@interface PopOutViewController ()

@end

@implementation PopOutViewController




- (instancetype)init
{
    if (self = [super init]) {
        self.title = @"Apple";
        self.contentSizeInPopup = CGSizeMake(300, 400);
        self.landscapeContentSizeInPopup = CGSizeMake(400, 200);
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;

    // Do any additional setup after loading the view.
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

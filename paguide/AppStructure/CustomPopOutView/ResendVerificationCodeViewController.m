//
//  ResendVerificationCodeViewController.m
//  paguide
//
//  Created by Evan Beh on 29/03/2017.
//  Copyright © 2017 Evan Beh. All rights reserved.
//

#import "ResendVerificationCodeViewController.h"

@interface ResendVerificationCodeViewController ()
@property (weak, nonatomic) IBOutlet UIButton *btnResend;

@end

@implementation ResendVerificationCodeViewController


- (IBAction)btnResendClicked:(id)sender {
    
    
    if (self.didSelectResendBlock)
    {
        self.didSelectResendBlock();
    }
        
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;

    [self.btnResend setDefaultBorder];
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

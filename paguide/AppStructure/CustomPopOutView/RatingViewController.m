//
//  RatingViewController.m
//  paguide
//
//  Created by Evan Beh on 09/03/2017.
//  Copyright © 2017 Evan Beh. All rights reserved.
//

#import "RatingViewController.h"
#import "UIButton+System.h"
@interface RatingViewController ()
@property (weak, nonatomic) IBOutlet UIButton *btnSubmit;

@end

@implementation RatingViewController
- (IBAction)btnSubmitClicked:(id)sender {
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.btnSubmit setDefaultBorder];
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

//
//  ViewController.m
//  paguide
//
//  Created by Evan Beh on 24/02/2017.
//  Copyright © 2017 Evan Beh. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIView *ibContainerView1;

@end

@implementation ViewController
- (IBAction)btnProfileClicked:(id)sender {
}

- (IBAction)btnTestClicked:(id)sender {
    
    [Utils showRegisterPage];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end

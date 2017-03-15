//
//  QuantitySelectionViewController.m
//  paguide
//
//  Created by Evan Beh on 09/03/2017.
//  Copyright © 2017 Evan Beh. All rights reserved.
//

#import "QuantitySelectionViewController.h"

@interface QuantitySelectionViewController ()
@property (weak, nonatomic) IBOutlet UIButton *btnDone;
@property (weak, nonatomic) IBOutlet UITextField *txtQuantity;

@end

@implementation QuantitySelectionViewController

- (IBAction)btnDoneClicked:(id)sender {
    
    if (self.didSelectQuantityBlock) {
        self.didSelectQuantityBlock([self.txtQuantity.text intValue]);
    }
}

- (IBAction)btnBackClicked:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [Utils setRoundBorder:self.btnDone color:[UIColor clearColor] borderRadius:5.0f];
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

//
//  PromoCodeViewController.m
//  paguide
//
//  Created by Evan Beh on 09/03/2017.
//  Copyright © 2017 Evan Beh. All rights reserved.
//

#import "PromoCodeViewController.h"
#import "UIButton+System.h"

@interface PromoCodeViewController ()
@property (weak, nonatomic) IBOutlet UIButton *btnContinue;
@property (weak, nonatomic) IBOutlet UITextField *txtPromoCode;
@property (weak, nonatomic) IBOutlet UIButton *btnCancel;

@end

@implementation PromoCodeViewController
- (IBAction)btnNoPromoClicked:(id)sender {
    
    if (self.didApplyNoPromoBlock) {
        self.didApplyNoPromoBlock();
    }

}
- (IBAction)btnContinueClicked:(id)sender {
    
    if ([Utils isStringNull:self.txtPromoCode.text]) {
        
        [MessageManager showMessage:@"Please Enter a promo code" Type:TSMessageNotificationTypeError];
        
        return;
    }
    
    if (self.didApplyPromoBlock) {
        self.didApplyPromoBlock(self.txtPromoCode.text);
    }
}
- (IBAction)btnCancelClicked:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self.btnCancel setInvertedBorder];
    
    [self.btnContinue setDefaultBorder];
    
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

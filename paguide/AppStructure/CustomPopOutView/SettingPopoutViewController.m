//
//  SettingPopoutViewController.m
//  paguide
//
//  Created by Evan Beh on 30/03/2017.
//  Copyright © 2017 Evan Beh. All rights reserved.
//

#import "SettingPopoutViewController.h"

@interface SettingPopoutViewController ()
{
    BOOL isSMSon;
    BOOL isPNotificationOn;
}

@property (weak, nonatomic) IBOutlet UIButton *btnCancel;
@property (weak, nonatomic) IBOutlet UIButton *btnSubmit;

@end

@implementation SettingPopoutViewController

- (IBAction)btnSubmitClicked:(id)sender {
    
    if (self.didSubmitClickedBlock)
    {
        self.didSubmitClickedBlock();
    }
}
- (IBAction)btnCancelClicked:(id)sender {
    

    if (self.didCancelClickedBlock) {
        self.didCancelClickedBlock();
    }
    
}

-(void)setupNotificationViewSMS:(BOOL)isSmsOn PushNotification:(BOOL)isPNOn
{
    isSMSon = isSmsOn;
    isPNotificationOn = isPNOn;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.btnCancel setInvertedBorder];
    
    [self.btnSubmit setDefaultBorder];
    
    
    self.ibSwitchOne.on = isPNotificationOn;
    
    self.ibSwitchTwo.on = isSMSon;
    
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

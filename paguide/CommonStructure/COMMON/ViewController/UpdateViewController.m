//
//  UpdateViewController.m
//  paguide
//
//  Created by Evan Beh on 28/03/2017.
//  Copyright © 2017 Evan Beh. All rights reserved.
//

#import "UpdateViewController.h"
#import "AppModel.h"

@interface UpdateViewController ()
@property (weak, nonatomic) IBOutlet UIButton *btnUpdate;

@end

@implementation UpdateViewController

- (IBAction)btnUpdateClicked:(id)sender {
    
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.updateURL]];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.btnUpdate setDefaultBorder];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Request Sever

//-(void)requestServerForUpdateApp:(VoidBlock)noUpdateNeededBlock NeedUpdate:(VoidBlock)updateNeededBlock
//{
//    NSDictionary* dict = @{@"mobile_type" : @"ios"};
//    
//    [ConnectionManager requestServerWith:AFNETWORK_POST serverRequestType:ServerRequestTypePostHomeVersion parameter:dict appendString:nil success:^(id object) {
//
//        
//        
//        NSError* error;
//        
//        AppModel* model = [[AppModel alloc]initWithDictionary:object[@"data"] error:&error];
//        
//        
//        NSString* serverVersion = model.ios_consumer_version;
//        
//        NSString* appVersion = APP_Version;
//
//        if ([serverVersion compare:appVersion options:NSNumericSearch] == NSOrderedDescending) {
//            
//            //change here for update.
//            NewUpdateViewController *newUpdateController = [self.storyboard instantiateViewControllerWithIdentifier:@"NewUpdatePage"];
//            [self presentViewController:newUpdateController animated:YES completion:nil];
//            
//        } else {
//            NSLog(@"Latest Version");
//            if (completion) {
//                completion();
//            }
//        }
//
//    } failure:^(id object) {
//        
//    }];
//}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

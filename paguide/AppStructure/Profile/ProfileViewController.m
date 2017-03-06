//
//  ProfileViewController.m
//  paguide
//
//  Created by Evan Beh on 01/03/2017.
//  Copyright © 2017 Evan Beh. All rights reserved.
//

#import "ProfileViewController.h"
#import "ProfileHeaderFooterView.h"

@interface ProfileViewController ()
{
    int segmentedControlIndex;
}
@property (weak, nonatomic) IBOutlet UITableView *ibTableView;
@property (weak, nonatomic) IBOutlet UIImageView *ibProfileImgView;

@property(nonatomic)NSArray* arrListOne;
@property(nonatomic)NSArray* arrListTwo;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    //[self.ibTableView setContentInset:UIEdgeInsetsMake(150,0,0,0)];

    [self.ibProfileImgView sd_setImageWithURL:[NSURL URLWithString:@"https://s-media-cache-ak0.pinimg.com/736x/8b/b1/60/8bb160c9f3b45906ef8ffab6ac972870.jpg"]];
    [Utils setRoundBorder:self.ibProfileImgView color:[UIColor clearColor] borderRadius:self.ibProfileImgView.frame.size.height/2];
    
    // Do any additional setup after loading the view.
}




#pragma mark - Navigation

//// In a storyboard-based application, you will often want to do a little preparation before navigation
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    // Get the new view controller using [segue destinationViewController].
//    // Pass the selected object to the new view controller.
//    
//    if ([[segue identifier] isEqualToString:@"appointment_details"]) {
//        
//        // Get destination view
//        AppointmentViewController *vc = [segue destinationViewController];
//        
//        
//    }
//
//}


@end

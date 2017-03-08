//
//  ProfileViewController.m
//  paguide
//
//  Created by Evan Beh on 01/03/2017.
//  Copyright © 2017 Evan Beh. All rights reserved.
//

#import "ProfileViewController.h"
#import "ProfileTableViewCell.h"
#import "RegisterTableViewCell.h"
#import "EBActionSheetViewController.h"


#define cell_name @"Name"
#define cell_country @"Country"
#define cell_contact @"Contact Number"




@interface ProfileViewController () <UITableViewDelegate, UITableViewDataSource>
{
    int segmentedControlIndex;
    
    BOOL isEditable;
}
@property (weak, nonatomic) IBOutlet UIBarButtonItem *btnEdit;
@property (weak, nonatomic) IBOutlet UITableView *ibTableView;
@property (weak, nonatomic) IBOutlet UIImageView *ibProfileImgView;

@property(nonatomic)NSArray* arrCellList;

@end

@implementation ProfileViewController
- (IBAction)btnBackClicked:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btnEditClicked:(id)sender {
    
    if (isEditable) {
        
        [self.btnEdit setTitle:@"Submit"];
    }
    else{
        [self.btnEdit setTitle:@"Edit"];

    }
    isEditable = !isEditable;
    
    [self.ibTableView reloadData];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    isEditable = NO;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    //[self.ibTableView setContentInset:UIEdgeInsetsMake(150,0,0,0)];

    [self.ibProfileImgView sd_setImageWithURL:[NSURL URLWithString:@"https://s-media-cache-ak0.pinimg.com/736x/8b/b1/60/8bb160c9f3b45906ef8ffab6ac972870.jpg"]];
    [Utils setRoundBorder:self.ibProfileImgView color:[UIColor clearColor] borderRadius:self.ibProfileImgView.frame.size.height/2];
    
    
    self.arrCellList = @[cell_country,cell_contact,cell_name];
    
    
    // Do any additional setup after loading the view.
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrCellList.count;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* type = self.arrCellList[indexPath.row];

    if (isEditable) {
        
        if ([type isEqualToString:cell_name]) {
            
            RegisterTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"profile_cell1"];

            
            return cell;
            
        }else if ([type isEqualToString:cell_country]) {
            
            RegisterTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"profile_cell3"];
            
            cell.didSelectBlock = ^(void)
            {
                [self showActionView];
                
            };

            
            
            return cell;
        }
        else if ([type isEqualToString:cell_contact]) {
            RegisterTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"profile_cell2"];
            
            
            return cell;
        }
        

    }
    else{
    
        ProfileTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"profile_cell"];
        
        NSString* title = self.arrCellList[indexPath.row];
        cell.lblTitle.text = title;
        cell.lblDesc.text = title;
        
        
        return cell;

    }
    
    return nil;
    
   
}

-(void)showActionView
{
    EBActionSheetViewController* viewC = [[EBActionSheetViewController alloc]initWithNibName:@"EBActionSheetViewController" bundle:nil];
    
    viewC.title = @"Country Selection";
    // viewC.view.backgroundColor = [UIColor colorWithRed:10 green:10 blue:10 alpha:0.5];
    //  UINavigationController* navC = [[UINavigationController alloc]initWithRootViewController:viewC];
    
    // [navC setNavigationBarHidden:YES];
    
    
    viewC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    viewC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    
    [self.tabBarController presentViewController:viewC animated:YES completion:nil];
    
    
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

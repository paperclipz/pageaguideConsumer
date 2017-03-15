//
//  AppointmentViewController.m
//  paguide
//
//  Created by Evan Beh on 02/03/2017.
//  Copyright © 2017 Evan Beh. All rights reserved.
//

#import "AppointmentViewController.h"
#import "ApptHeaderTableViewCell.h"
#import "GeneralTableViewCell.h"
#import "HeaderView.h"

#define cell_title @"cell_title"
#define cell_detail1 @"cell_detail1"
#define cell_map @"cell_map"
#define cell_details_more @"appt_detail_more"

@interface AppointmentViewController () <UITableViewDelegate, UITableViewDataSource>
{
    NSArray* arrCellTypeList;
}
@property (weak, nonatomic) IBOutlet UITableView *ibTableView;

@end

@implementation AppointmentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;

    self.ibTableView.rowHeight = UITableViewAutomaticDimension;
    
    self.ibTableView.estimatedRowHeight = 120.0f;
    
    arrCellTypeList = @[cell_title,cell_detail1,cell_details_more,cell_map];
    
    // Do any additional setup after loading the view.
    
    [self initData];
}

-(void)initData
{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return arrCellTypeList.count;
}


- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    NSString* type = arrCellTypeList[section];
    
    
    
    if ([type isEqualToString:cell_details_more]) {
        
        UIView* view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"header_cell"];
        
        if (!view) {
            
            view = [HeaderView initializeCustomView];
            
        }
        
        HeaderView* headerView = (HeaderView*)view;
        
        headerView.lblTitle2.hidden = YES;
        
        headerView.lblTitle1.text = @"6 in 1 Bundle";
        
        
        
        return headerView;
    }
  
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    NSString* type = arrCellTypeList[section];
    
    if ([type isEqualToString:cell_details_more]) {
        
        
        return 50.0f;
    }
    
    return 0.0f;
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    NSString* type = arrCellTypeList[section];
    
    if ([type isEqualToString:@"cell_title"]) {
        
        return 1;
    
    }
    else  if ([type isEqualToString:@"cell_detail1"]) {
        
        return 1;
    
    }
    
    else  if ([type isEqualToString:cell_details_more]) {
        
        return 3;
        
    }
    else  if ([type isEqualToString:@"cell_map"]) {
        
        return 1;
    }
    
    return 0;

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* type = arrCellTypeList[indexPath.section];
    
    if ([type isEqualToString:@"cell_title"]) {
        
        return 80.0f;
    }
    else  if ([type isEqualToString:@"cell_detail1"]) {
        
        return 130.0f;
    }
    else  if ([type isEqualToString:@"cell_map"]) {
        
        return 150.0f;
    }
    else  if ([type isEqualToString:cell_details_more]) {
        
        return UITableViewAutomaticDimension;
    }

    
    return 0;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString* type = arrCellTypeList[indexPath.section];
    
    if ([type isEqualToString:@"cell_title"]) {
        ApptHeaderTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"appt_title"];
        
        
        cell.lblTitle.text = @"Travel Ptd Ltd";
        return cell;

        
    }
    else  if ([type isEqualToString:@"cell_detail1"]) {
        ApptHeaderTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"appt_detail1"];
        
        
        return cell;
    }
    
    else  if ([type isEqualToString:@"appt_detail_more"]) {
        GeneralTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"appt_detail_more"];
        
        cell.lblTitle.text = @"this is not for resell purposes";
        return cell;
    }
    else  if ([type isEqualToString:@"cell_map"]) {
        ApptHeaderTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"appt_map"];
        
        return cell;
    }
    
    return nil;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString* type = arrCellTypeList[indexPath.section];
    
    if ([type isEqualToString:@"cell_title"]) {
        
        [self performSegueWithIdentifier: @"merchant_profile" sender:self];

    }
    
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([[segue identifier] isEqualToString:@"merchant_profile"]) {
        
        
        
       
    }
        

}


@end

//
//  AppointmentViewController.m
//  paguide
//
//  Created by Evan Beh on 02/03/2017.
//  Copyright © 2017 Evan Beh. All rights reserved.
//

#import "AppointmentViewController.h"
#import "ApptHeaderTableViewCell.h"

#define cell_title @"cell_title"
#define cell_detail1 @"cell_detail1"
#define cell_map @"cell_map"

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

    
    arrCellTypeList = @[cell_title,cell_detail1,cell_map];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return arrCellTypeList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
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
    
    return 0;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString* type = arrCellTypeList[indexPath.section];
    
    if ([type isEqualToString:@"cell_title"]) {
        ApptHeaderTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"appt_title"];
        
        return cell;

        
    }
    else  if ([type isEqualToString:@"cell_detail1"]) {
        ApptHeaderTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"appt_detail1"];
        
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

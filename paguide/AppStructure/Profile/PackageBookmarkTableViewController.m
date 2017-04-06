//
//  PackageBookmarkTableViewController.m
//  paguide
//
//  Created by Evan Beh on 03/04/2017.
//  Copyright © 2017 Evan Beh. All rights reserved.
//

#import "PackageBookmarkTableViewController.h"
#import "DashboardPackageTableViewCell.h"
#import "PackageModel.h"
#import "OfflineManager.h"
#import "PackageDetailsViewController.h"

@interface PackageBookmarkTableViewController ()
{
    PackageModel* selectedPackageModel;

}
@property (nonatomic,strong)NSMutableArray* arrPackageList;

@end

@implementation PackageBookmarkTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Bookmark";
    
    self.arrPackageList = [[OfflineManager getPackageList] mutableCopy];
    
    [self.tableView reloadData];
    
    [self.tableView pullToRefresh:^{
        
        [self.tableView stopRefresh];
        
        [self.arrPackageList removeAllObjects];
        
        self.arrPackageList = nil;
        
        [self.tableView reloadData];
        
        self.arrPackageList = [[OfflineManager getPackageList] mutableCopy];
        
        [self.tableView reloadData];
        
    }];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrPackageList.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    
    DashboardPackageTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"dashPackageCell"];
    
    PackageModel* model = self.arrPackageList[indexPath.row];
    
    
    [self setupPackageInCell:cell With:model];
    return cell;
}


-(void)setupPackageInCell:(DashboardPackageTableViewCell*)cell With:(PackageModel*)model
{
    cell.lblTitle2.text = model.name;
    
    cell.lblTitle1.text = [NSString stringWithFormat:@"%@ %@",model.currency, model.price];
    
    cell.lblTitle3.text = model.mode;
    
    [cell.ibImageView sd_setImageWithURL:[NSURL URLWithString:model.listing_img]];
    
    cell.lblTitle4.text = model.category;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    selectedPackageModel = self.arrPackageList[indexPath.row];
    
    [self performSegueWithIdentifier:@"bookmark_package_detail" sender:self];
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"bookmark_package_detail"]) {
        
        PackageDetailsViewController *vc = [segue destinationViewController];
        
        vc.viewType = PACKAGE_VIEW_TYPE_AVAILABILIY;
        
        [vc setupPackageID:selectedPackageModel.packages_id];
        
    }
}


@end

//
//  MerchantProfileViewController.m
//  paguide
//
//  Created by Evan Beh on 03/03/2017.
//  Copyright © 2017 Evan Beh. All rights reserved.
//

#import "MerchantProfileViewController.h"
#import "MerchantProfileTableViewCell.h"
#import "HeaderView.h"
#import "GalleryTableViewCell.h"
#import "MWPhotoBrowser.h"


#define cell_about @"About"
#define cell_review @"Review"
#define cell_gallery @"Gallery"

@interface MerchantProfileViewController () <UITableViewDataSource, UITableViewDelegate,MWPhotoBrowserDelegate>
{
    NSArray* arrCellList;
}

@property (weak, nonatomic) IBOutlet UIImageView *ibMerchantProfileView;
@property (weak, nonatomic) IBOutlet UITableView *ibTableView;

@property (strong,nonatomic)NSArray* arrImageList;
@property (strong,nonatomic)NSMutableArray* arrMWImageList;

@end

@implementation MerchantProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
   // [self.ibMerchantProfileView sd_setImageWithURL:[NSURL URLWithString:@"https://s-media-cache-ak0.pinimg.com/736x/8b/b1/60/8bb160c9f3b45906ef8ffab6ac972870.jpg"]];

    arrCellList = @[cell_about,cell_review,cell_gallery];

    
    self.ibTableView.estimatedRowHeight = 120.0f;
    
    self.ibTableView.dataSource = nil;
    
    self.ibTableView.delegate   = nil;
    
    self.ibTableView.rowHeight = UITableViewAutomaticDimension;
    
    self.arrImageList = @[@"http://www.interviewmagazine.com/files/2013/09/28/img-scarlett-johansson_160222925524.jpg",@"http://esq.h-cdn.co/assets/cm/15/07/54daf94090795_-_esq-scarlet-johansson-2005-01-de.jpg"];
    
  //  [self.ibTableView registerClass:[GalleryTableViewCell class] forCellReuseIdentifier:@"gallery_cell"];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    NSString* type = arrCellList[section];

    
    UIView* view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"header_cell"];
    
    if (!view) {
        
        view = [HeaderView initializeCustomView];
        
    }
    
    HeaderView* headerView = (HeaderView*)view;
    
    headerView.lblTitle1.text = type;
    
    headerView.lblTitle2.text = @"More";

    headerView.lblTitle2.hidden = YES;

    if ([type isEqualToString:cell_review]) {
        
        if (true) {
            
            headerView.lblTitle2.hidden = NO;
            
        }
    }
    
    headerView.didSelectBlock = ^(void)
    {
      
        if ([type isEqualToString:cell_review]) {
            
            [self performSegueWithIdentifier:@"merchant_review" sender:self];
        }
    };
    
    return view;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50.0f;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    NSString* type = arrCellList[indexPath.section];
    
    if ([type isEqualToString:cell_about]) {
        
        return UITableViewAutomaticDimension;

    }else  if ([type isEqualToString:cell_review]) {
        
        return UITableViewAutomaticDimension;

    } else  if ([type isEqualToString:cell_gallery]) {
        
        return 100.0f;

    }

    
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return arrCellList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString* type = arrCellList[section];
    
    if ([type isEqualToString:cell_about]) {
        
        return 1;
    }else  if ([type isEqualToString:cell_review]) {
        
        return 3;
        
    } else  if ([type isEqualToString:cell_gallery]) {
        
        return 1;
        
    }
    

    return 0;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString* type = arrCellList[indexPath.section];
    
    if ([type isEqualToString:cell_about]) {
        MerchantProfileTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"merchant_about"];
        
        cell.lblTitle1.text = @"gg wpgg wpgg wpgg wpgg wpgg wpgg wpgg wpgg wpgg wpgg wpgg wpgg wpgg wpgg wpgg wpgg wpgg wpgg wpgg wpgg wpgg wpgg wpgg wpgg wpgg wpgg wpgg wpgg wpgg wpgg wpgg wpgg wpgg wpgg wpgg wpgg wpgg wpgg wpgg wpgg wpgg wp";
        
        return cell;
        
    }else  if ([type isEqualToString:cell_review]) {
        
        MerchantProfileTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"merchant_review"];
        
        cell.lblDesc2.text = @"abcd abcdabcdabcdabcdabcdabcd abcd abcdabcdabcd abcd abcd abcdabcdabcdabcdabcdabcd abcd abcdabcdabcd abcd abcd abcdabcdabcdabcdabcdabcd abcd abcdabcdabcd abcd abcd abcdabcdabcdabcdabcdabcd abcd abcdabcdabcd abcd abcd abcdabcdabcdabcdabcdabcd abcd abcdabcdabcd abcd ";
        
        return cell;
    }
    else  if ([type isEqualToString:cell_gallery]) {
        
        GalleryTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"merchant_gallery"];
        
        [cell setupImageList:self.arrImageList];
        
        
        cell.didSelectAtIndexBlock = ^(int index)
        {
            [self showGalleryView:index];
        };
        
        return cell;
    }
  
    return nil;
}

-(void)showGalleryView:(NSInteger)index
{
    
    
    self.arrMWImageList = [NSMutableArray new];
    
    for (int i = 0; i<self.arrImageList.count; i++) {
        
        [self.arrMWImageList addObject:[MWPhoto photoWithURL:[NSURL URLWithString:self.arrImageList[i]]]];
        
    }
    
    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    
    // Set options
    browser.displayActionButton = YES; // Show action button to allow sharing, copying, etc (defaults to YES)
    browser.displayNavArrows = NO; // Whether to display left and right nav arrows on toolbar (defaults to NO)
    browser.displaySelectionButtons = NO; // Whether selection buttons are shown on each image (defaults to NO)
    browser.zoomPhotosToFill = YES; // Images that almost fill the screen will be initially zoomed to fill (defaults to YES)
    browser.alwaysShowControls = NO; // Allows to control whether the bars and controls are always visible or whether they fade away to show the photo full (defaults to NO)
    browser.enableGrid = YES; // Whether to allow the viewing of all the photo thumbnails on a grid (defaults to YES)
    browser.startOnGrid = NO; // Whether to start on the grid of thumbnails instead of the first photo (defaults to NO)
    browser.autoPlayOnAppear = NO; // Auto-play first video
    
    // Customise selection images to change colours if required
    
    // Optionally set the current visible photo before displaying
    [browser setCurrentPhotoIndex:index];
    
    // Present
    
   // [self presentViewController:browser animated:YES completion:nil];
    
    [self.navigationController pushViewController:browser animated:YES];
    
}


- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser
{
    return self.arrMWImageList.count;
    
}
- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index
{
    return self.arrMWImageList[index];
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

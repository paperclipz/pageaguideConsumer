//
//  DashboardPackageFilterViewController.m
//  paguide
//
//  Created by Evan Beh on 06/03/2017.
//  Copyright © 2017 Evan Beh. All rights reserved.
//

#import "DashboardPackageFilterViewController.h"
#import "FilterCategoryTableViewCell.h"
#import "CategorySelectionViewModel.h"
#import "HeaderView.h"

@interface DashboardPackageFilterViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong)NSMutableArray* arrCategoryList;

@property (nonatomic, strong)NSMutableArray* arrRecommendationList;

@property (weak, nonatomic) IBOutlet UITableView *ibTableView;
@property (weak, nonatomic) IBOutlet UIButton *btnSubmit;
@end

@implementation DashboardPackageFilterViewController
- (IBAction)btnBackClicked:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
- (IBAction)btnResetAllClicked:(id)sender {
    
    
    for (int i = 0; i<self.arrCategoryList.count; i++) {
        
        CategorySelectionViewModel* model = self.arrCategoryList[i];
        
        model.isSelected = NO;
        
        [self.arrCategoryList replaceObjectAtIndex:i withObject:model];
    }
    
    for (int i = 0; i<self.arrRecommendationList.count; i++) {
        
        CategorySelectionViewModel* model = self.arrRecommendationList[i];
        
        model.isSelected = NO;
        
        [self.arrRecommendationList replaceObjectAtIndex:i withObject:model];
    }
    
    [self.ibTableView reloadData];

}
- (IBAction)btnSubmitClicked:(id)sender {
    
    if (self.didSubmitFilterBlock) {
        self.didSubmitFilterBlock([self processFilterData]);
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(NSString*)processFilterData
{
    
    NSMutableArray* array = [NSMutableArray new];
    
    for (int i = 0; i<self.arrCategoryList.count; i++) {
        
        CategorySelectionViewModel* model = self.arrCategoryList[i];
        
        if (model.isSelected) {
            
            [array addObject:model.title];
        }
    }
    
    for (int i = 0; i<self.arrRecommendationList.count; i++) {
        
        for (int i = 0; i<self.arrRecommendationList.count; i++) {
            
            CategorySelectionViewModel* model = self.arrRecommendationList[i];
            
            if (model.isSelected) {
                
                [array addObject:model.title];
            }
        }

        
    }
    
    return [array componentsJoinedByString:@","];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.btnSubmit setDefaultBorder];
    
    [self.btnSubmit setTitle:@"Submit" forState:UIControlStateNormal];
    
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:APP_MAIN_COLOR}];
    
    self.automaticallyAdjustsScrollViewInsets = NO;

    [self requestServerForCategoryFilter];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    
    UIView* view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"header_cell"];
    
    if (!view) {
        
        view = [HeaderView initializeCustomView];
        
    }
    
    HeaderView* headerView = (HeaderView*)view;
    
    headerView.lblTitle2.hidden = YES;
    
    
    if (section == 0) {
        headerView.lblTitle1.text = @"Category";

    }
    else{
        headerView.lblTitle1.text = @"Good For";

    }
    
    
    
    return headerView;

}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50.0f;

}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section

{
    
    if (section == 0) {
        
        return self.arrCategoryList.count;
    }
    else{
        return self.arrRecommendationList.count;

    }
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FilterCategoryTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"filter_cell"];
    
    
    __weak typeof (cell)weakCell = cell;
    
    if (indexPath.section == 0) {
        
        
        CategorySelectionViewModel* model = self.arrCategoryList[indexPath.row];
        
        cell.lblTitle.text = model.title;
        
        cell.ibSwitch.on = model.isSelected;
        
        cell.didChangewitchBlock = ^(void)
        {
            model.isSelected = weakCell.ibSwitch.isOn;
            
            [self.arrCategoryList replaceObjectAtIndex:indexPath.row withObject:model];
        };
    }
    else if (indexPath.section == 1)
    {
        
        CategorySelectionViewModel* model = self.arrRecommendationList[indexPath.row];

        
        cell.lblTitle.text = model.title;

        cell.ibSwitch.on = model.isSelected;

        
        cell.didChangewitchBlock = ^(void)
        {
            model.isSelected = weakCell.ibSwitch.isOn;
            
            [self.arrCategoryList replaceObjectAtIndex:indexPath.row withObject:model];
        };
    }
    return cell;
}


-(void)requestServerForCategoryFilter
{
    
    [ConnectionManager requestServerWith:AFNETWORK_POST serverRequestType:ServerRequestTypePostPackagesCategoryList parameter:nil appendString:nil success:^(id object) {
        
        
        [self processCategory:object[@"data"][@"category"]];
        
        [self processRecommend:object[@"data"][@"recommendation"]];

        [self.ibTableView reloadData];
        

        
    } failure:^(id object) {
        
    }];
}

-(void)processCategory:(NSArray*)arrayStringCategory
{

    NSMutableArray* tempArray = [NSMutableArray new];
    
    for (int i = 0; i<arrayStringCategory.count; i++) {
        
        NSString* title = arrayStringCategory[i];

        CategorySelectionViewModel* model = [CategorySelectionViewModel new];
        
        model.title = title;
        
        model.isSelected = NO;
     
        [tempArray addObject:model];
    }
    
    self.arrCategoryList = tempArray;
}


-(void)processRecommend:(NSArray*)arrayStringRecommend
{
    
    NSMutableArray* tempArray = [NSMutableArray new];
    
    for (int i = 0; i<arrayStringRecommend.count; i++) {
        
        NSString* title = arrayStringRecommend[i];
        
        CategorySelectionViewModel* model = [CategorySelectionViewModel new];
        
        model.title = title;
        
        model.isSelected = NO;
        
        [tempArray addObject:model];
    }
    
    self.arrRecommendationList = tempArray;
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

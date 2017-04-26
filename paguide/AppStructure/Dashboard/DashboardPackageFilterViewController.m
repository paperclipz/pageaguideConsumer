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
#import "FormDataModel.h"
#import "UITextField+Blocks.h"

#define cell_type_option @"option"

@interface DashboardPackageFilterViewController () <UITableViewDelegate, UITableViewDataSource>
{
    NSDictionary* tempObject;
}
@property (nonatomic, strong)NSMutableArray* arrFilterList;

@property (weak, nonatomic) IBOutlet UITableView *ibTableView;
@property (weak, nonatomic) IBOutlet UIButton *btnSubmit;
@end

@implementation DashboardPackageFilterViewController


- (IBAction)btnBackClicked:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
- (IBAction)btnResetAllClicked:(id)sender {
    
    [self processData:tempObject];

}
- (IBAction)btnSubmitClicked:(id)sender {
    
    if (self.didSubmitFilterBlock) {
        self.didSubmitFilterBlock([self processFilterData]);
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(NSArray*)getArrayOptionsSelectedArray:(NSArray*)array
{
    NSMutableArray* arrString = [NSMutableArray new];
    
    for (int j = 0; j<array.count; j++) {
        
        KeyValueModel* kModel = array[j];
        
        
        if (kModel.isSelected) {
            [arrString addObject:kModel.key];
            
        }
    }
    
    return arrString;

}
-(NSString*)processFilterData
{
    
    NSMutableArray* finalArray = [NSMutableArray new];
    
    for (int i = 0; i<self.arrFilterList.count; i++) {
        
        FormDataModel* model = self.arrFilterList[i];
        
        
        if ([model.title isEqualToString:@"keyword"]) {
            
            
            if (![Utils isStringNull:model.value]) {
                
                NSString* string = [NSString stringWithFormat:@"%@:%@",model.title,model.value];
                
                [finalArray addObject:string];
            }
           
        }
        else{
        
            
            if ([model.title isEqualToString:@"price"] || [model.title isEqualToString:@"rating"]) {
                
                NSArray* array = [self getArrayOptionsSelectedArray:model.arrOptionsList];

                if (![Utils isArrayNull:array]) {
                    NSString* string = [NSString stringWithFormat:@"%@:%@",model.title,[array componentsJoinedByString:@","]];
                    
                    [finalArray addObject:string];
                }

                
                
            }
            else{
                
                NSArray* array = [self getArrayOptionsSelectedArray:model.arrOptionsList];
                
                if (![Utils isArrayNull:array]) {
                    
                    [finalArray addObject:[array componentsJoinedByString:@","]];
                }
                

             
            }
            
        }
       

    }
    return [finalArray componentsJoinedByString:@","];
    
 //   return [array componentsJoinedByString:@","];
    
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
    
    self.ibTableView.estimatedRowHeight = 120.0f;
    
    self.ibTableView.rowHeight = UITableViewAutomaticDimension;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.arrFilterList.count;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    
    FormDataModel* model  = self.arrFilterList[section];
    
    UIView* view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"header_cell"];
    
    if (!view) {
        
        view = [HeaderView initializeCustomView:@"HeaderView2"];
        
    }
    
    HeaderView* headerView = (HeaderView*)view;
    
    headerView.lblTitle1.text = model.title;
    
    headerView.lblTitle1.textColor = APP_MAIN_COLOR;
    
    if (model.isExpand) {
        headerView.ibImageView.image = [UIImage imageNamed:@"icon_collapse_up_red.png"];
        
    }
    else
    {
        headerView.ibImageView.image = [UIImage imageNamed:@"icon_collapse_down_red.png"];

    }
    
    headerView.ibImageView.hidden = NO;
    
    if ([model.title isEqualToString:@"keyword"]) {
        
        headerView.ibImageView.hidden = YES;
    }
    
    
    
    headerView.didSelectBlock = ^{
        
        model.isExpand = !model.isExpand;
        
        [self.arrFilterList replaceObjectAtIndex:section withObject:model];
        
        [self reloadSection:section];
    };

    
    
    return headerView;

}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40.0f;

}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FormDataModel* model = self.arrFilterList[indexPath.section];
    if ([model.title isEqualToString:@"keyword"]) {
        return 70;
    }
    else if (model.isExpand)
    {
        return 40.0f;
    }
    else{
        return UITableViewAutomaticDimension;
    }
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section

{
    
    FormDataModel* model = self.arrFilterList[section];
    if ([model.title isEqualToString:@"keyword"]) {
        return 1;
    }else{
 
        if (model.isExpand) {
            return model.arrOptionsList.count;

        }
        
        else{
            return 1;
        }
    }
    
    
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    FormDataModel* model = self.arrFilterList[indexPath.section];


    if ([model.title isEqualToString:@"keyword"]) {
     
        FilterCategoryTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"filter_cell_txtField"];
        
            cell.txtField.placeholder = model.title;
            
            
            cell.txtField.text = model.value;
            
            [cell.txtField setDidEndEditingBlock:^(UITextField *textField) {
                
                
                model.value = textField.text;
                
                [self.arrFilterList replaceObjectAtIndex:indexPath.section withObject:model];
            }];
            
        
        return cell;

    }
    else
    {
       
        
       
        if (model.isExpand) {
            
            FilterCategoryTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"filter_cell"];
            
            __weak typeof (cell)weakCell = cell;
            
            KeyValueModel* kModel = model.arrOptionsList[indexPath.row];
            
            cell.lblTitle.text = kModel.key;
            
            cell.ibSwitch.on = kModel.isSelected;
            
            cell.didChangewitchBlock = ^(void)
            {
                
                
                if ([model.type isEqualToString:cell_type_option]) {
                    
                    [model.arrOptionsList removeAllObjects];
                    
                    model.arrOptionsList = nil;
                    
                    kModel.isSelected = weakCell.ibSwitch.isOn;
                    
                    [model.arrOptionsList replaceObjectAtIndex:indexPath.row withObject:kModel];
                    
                    [self.arrFilterList replaceObjectAtIndex:indexPath.section withObject:model];
                    
                    [self reloadSection:indexPath.section];

                }
                else{
                
                    kModel.isSelected = weakCell.ibSwitch.isOn;
                    
                    [model.arrOptionsList replaceObjectAtIndex:indexPath.row withObject:kModel];
                    
                    [self.arrFilterList replaceObjectAtIndex:indexPath.section withObject:model];

                }
               
              
            };
            

            return cell;
        }
        else{
            FilterCategoryTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"filter_cell_unExpand"];
            
            
            NSString* combineString = [[self getArrayOptionsSelectedArray:model.arrOptionsList] componentsJoinedByString:@", "];
            
            if ([Utils isStringNull:combineString]) {
                cell.lblTitle.text = @"-";

            }
            else{
                cell.lblTitle.text = combineString;
}
            
            return cell;

            
            
        }
        

    }
    
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FormDataModel* model = self.arrFilterList[indexPath.section];
    
    if (![model.title isEqualToString:@"keyword"] && !model.isExpand) {
        
        model.isExpand =   !model.isExpand;
        
        [self.arrFilterList replaceObjectAtIndex:indexPath.section withObject:model];
        
        [self reloadSection:indexPath.section];
    }
}


-(void)requestServerForCategoryFilter
{
    
    [ConnectionManager requestServerWith:AFNETWORK_POST serverRequestType:ServerRequestTypePostPackagesCategoryList parameter:nil appendString:nil success:^(id object) {
        
        [self processData:object[@"data"]];
        
//        [self processCategory:object[@"data"][@"category"]];
//        
//        [self processRecommend:object[@"data"][@"recommendation"]];

   //     [self.ibTableView reloadData];
        
    } failure:^(id object) {
        
    }];
}

-(void)processData:(NSDictionary*)object
{
    
    if (object) {
     
        NSMutableArray* tempArray = [NSMutableArray new];
        
        NSArray* arrayKey = object.allKeys;
        
        for (int i = 0; i<arrayKey.count; i++) {
            
            FormDataModel* fmodel = [FormDataModel new];
            
            NSString* key = arrayKey[i];
            
            fmodel.title = key;
            
            NSArray* arrOptions = object[key];
            
            fmodel.answer_list = arrOptions;
            
            [tempArray addObject:fmodel];
            
        }
        
        self.arrFilterList = tempArray;
        
        FormDataModel* model2 = [FormDataModel new];
        model2.type = cell_type_option;
        model2.title = @"price";
        model2.answer_list = @[@"high_low",@"low_high"];
        [self.arrFilterList addObject:model2
         ];
        
        FormDataModel* model3 = [FormDataModel new];
        model3.type = cell_type_option;
        model3.title = @"rating";
        model3.answer_list = @[@"high_low",@"low_high"];
        [self.arrFilterList addObject:model3
         ];

        
        
        FormDataModel* model4 = [FormDataModel new];
        model4.title = @"keyword";
        [self.arrFilterList addObject:model4];
        
        [self.ibTableView reloadData];

    }
    else
    {
        [self requestServerForCategoryFilter];
    }
    
    
    
    
}

-(NSMutableArray*)arrFilterList
{
    if (!_arrFilterList) {
        _arrFilterList = [NSMutableArray new];
    }
    
    return _arrFilterList;
    
}

-(void)reloadSection:(NSInteger)section
{
    // [self.ibTableView reloadData];
    
    NSIndexSet *sectionToReload = [NSIndexSet indexSetWithIndex:section];
    
    [self.ibTableView reloadSections:sectionToReload withRowAnimation:UITableViewRowAnimationFade];
}

-(NSArray*)setArraySelectedAtIndex:(int)index Array:(NSArray*)array
{
    
    NSMutableArray* arrTemp = [NSMutableArray new];
    
    for (int i = 0; i<array.count; i++) {
        
        KeyValueModel* model = array[i];
        
        
        if (index == i) {
            
            model.isSelected = YES;

        }else{
            model.isSelected = NO;

        }
        
        [arrTemp addObject:model];
    }
    
    return arrTemp;
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

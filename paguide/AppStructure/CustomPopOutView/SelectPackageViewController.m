//
//  SelectPackageViewController.m
//  paguide
//
//  Created by Evan Beh on 20/03/2017.
//  Copyright © 2017 Evan Beh. All rights reserved.
//

#import "SelectPackageViewController.h"
#import "PackageSelectionTableViewCell.h"
#import "EBActionSheetViewController.h"
#import "ScheduleModel.h"
#import "ScheduleModel.h"

#define cell_type_time @"Time"
#define cell_type_language @"Language"
#define cell_type_quantity @"Quantity"

@interface SelectPackageViewController () <UITableViewDataSource, UITableViewDelegate>
{
    NSArray* arrCellList;
    
    NSMutableArray* arrSelectedScheduleList;
    
    ScheduleModel* selectedScheduleModel;
}

@property (weak, nonatomic) IBOutlet UIButton *btnSave;

@property(nonatomic,strong)PackageModel* packageModel;

@property (nonatomic,strong)NSString* selectedDate;

@property (weak, nonatomic) IBOutlet UITableView *ibTableView;
@end

@implementation SelectPackageViewController



- (IBAction)btnSaveClicked:(id)sender {
    
    
    if ([self validate]) {
        
        if (self.didFinishSelectScheduleBlock)
        {
            self.didFinishSelectScheduleBlock(selectedScheduleModel);
        }
 
    }
}

-(BOOL)validate
{
    
    BOOL noError = YES;
    if ([Utils isStringNull:selectedScheduleModel.scheduled_time]) {
        
        [MessageManager showMessage:@"Please Select a Time" Type:TSMessageNotificationTypeWarning inViewController:self];
        
        noError = NO;
    }
    
    else if ([selectedScheduleModel.quantity integerValue] == 0) {
        
        [MessageManager showMessage:@"Quantity Cannot be 0" Type:TSMessageNotificationTypeWarning inViewController:self];
        noError = NO;

    }
    
    return noError;
}


-(void)setuDataWithPackage:(PackageModel*)pModel SelectedDate:(NSString*)selectedDate
{
    _selectedDate = selectedDate;
    
    _packageModel = pModel;
    
    arrSelectedScheduleList = [NSMutableArray new];
    
    for (int i = 0 ; i<self.packageModel.scheduled_datetime.count; i++) {
        
        ScheduleModel* sModel = self.packageModel.scheduled_datetime[i];
        
        if ([sModel.scheduled_date isEqualToString:self.selectedDate])
        {
            [arrSelectedScheduleList addObject:sModel];
        }
    }
    
    selectedScheduleModel = [ScheduleModel new];
    
    selectedScheduleModel.scheduled_date = selectedDate;//put time value first as its from the same day
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    arrCellList = @[cell_type_time,
                    cell_type_language,
                    cell_type_quantity,
                    ];
    
    self.ibTableView.delegate = self;
    self.ibTableView.dataSource = self;
    
    [self.btnSave setDefaultBorder];
    
    [self.btnSave setTitle:@"Save" forState:UIControlStateNormal];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return arrCellList.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    
    NSString* title = arrCellList[indexPath.row];
    
    
    
    if ([title isEqualToString:cell_type_time]) {
        
        
        PackageSelectionTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cell_selection1"];
        
        NSString* displayTitle;
        
        if (![Utils isStringNull:selectedScheduleModel.scheduled_time]) {
            displayTitle = selectedScheduleModel.scheduled_time;
        }
        else
        {
            displayTitle = @"Time";

        }
        [cell.btnOne setTitle:displayTitle forState:UIControlStateNormal];

        cell.didSelectBlock = ^(void)
        {
            [self showView:^(int selectedIndex) {
                
                
                ScheduleModel* model = arrSelectedScheduleList[selectedIndex];
                
                selectedScheduleModel.scheduled_time = model.scheduled_time;
                
                selectedScheduleModel.language = model.language;
                
                selectedScheduleModel.max_slot = model.max_slot;
                
                selectedScheduleModel.quantity = 0;
                
                [self.ibTableView reloadData];

            } Title:@"Select Time" ValueKey:@"scheduled_time"];
        };
        return cell;


    }
    else if ([title isEqualToString:cell_type_language]) {
    
        
        
        PackageSelectionTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cell_selection2"];
        
//        cell.didSelectBlock = ^(void)
//        {
//            [self showView:^(NSString *str) {
//                
//            } Title:@"Select Language" ValueKey:@"language"];
//        };
        
        NSString* displayTitle;
        
        if (![Utils isStringNull:selectedScheduleModel.language]) {
            displayTitle = selectedScheduleModel.language;
        }
        else
        {
            displayTitle = @"Language";
            
        }
        [cell.btnOne setTitle:displayTitle forState:UIControlStateNormal];

        return cell;

    }
    
    else if ([title isEqualToString:cell_type_quantity]) {
        
        
        PackageSelectionTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cell_selection3"];
       
        NSString* displayTitle;
        
        if (selectedScheduleModel.quantity) {
            displayTitle = [selectedScheduleModel.quantity stringValue];
        }
        else
        {
            displayTitle = @"Quantity";
            
        }
        cell.lblTitle.text = displayTitle;

        cell.maxNumber = selectedScheduleModel.max_slot;
        
        
        cell.didUpdateQuantitytBlock = ^(int value)
        {
            selectedScheduleModel.quantity = @(value);
        };
        
        return cell;

    }

    
    return nil;
    
}

-(void)showView:(IntBlock)completion Title:(NSString*)title ValueKey:(NSString*)vKey
{
    
        EBActionSheetViewController* viewC = [[EBActionSheetViewController alloc]initWithNibName:@"EBActionSheetViewController" bundle:nil];
  
    viewC.title = title;
    
    
        viewC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        viewC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        
    
        viewC.arrItemList = [arrSelectedScheduleList valueForKey:vKey];
        
        [self presentViewController:viewC animated:YES completion:nil];
        
        __weak typeof (viewC)weakVC = viewC;
        
        viewC.didSelectAtIndexBlock = ^(NSIndexPath* indexPath)
        {
            [weakVC dismissViewControllerAnimated:YES completion:^{
                
                if (completion) {
                    completion((int)indexPath.row);
                }
                
            }];
            
        };
    
    
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

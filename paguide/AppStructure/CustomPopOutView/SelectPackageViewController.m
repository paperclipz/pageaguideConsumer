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
#import "RMDateSelectionViewController.h"

#define cell_type_time @"Time"
#define cell_type_language @"Language"
#define cell_type_quantity @"No. of Person"

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
    if (self.packageModel.isScheduled) {
        if ([Utils isStringNull:selectedScheduleModel.scheduled_time]) {
            
            [MessageManager showMessage:@"Please Select a Time" Type:TSMessageNotificationTypeWarning inViewController:self];
            
            noError = NO;
        }
        
        else if ([selectedScheduleModel.quantity integerValue] == 0) {
            
            [MessageManager showMessage:@"Quantity Cannot be 0" Type:TSMessageNotificationTypeWarning inViewController:self];
            noError = NO;
            
        }

    }
    else{
    
        if (!selectedScheduleModel.selectedDate) {
            
            [MessageManager showMessage:@"Please Select a Time" Type:TSMessageNotificationTypeWarning inViewController:self];
            
            noError = NO;
        }
        else if ([Utils isStringNull:selectedScheduleModel.inputLanguage]) {
            
            [MessageManager showMessage:@"Please input a language" Type:TSMessageNotificationTypeWarning inViewController:self];
            noError = NO;
            
        }
        else if ([selectedScheduleModel.quantity integerValue] == 0) {
            
            [MessageManager showMessage:@"Quantity Cannot be 0" Type:TSMessageNotificationTypeWarning inViewController:self];
            noError = NO;
            
        }
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

-(void)setuDataWithPackage:(PackageModel*)pModel
{
    
    selectedScheduleModel = [ScheduleModel new];

    _packageModel = pModel;
    
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
        
        if (self.packageModel.isScheduled)
        {
            
            if (![Utils isStringNull:selectedScheduleModel.scheduled_time]) {
                displayTitle = [NSString stringWithFormat:@"%@ %@",selectedScheduleModel.scheduled_time,@"Hours"];
            }
            else
            {
                displayTitle = @"Time";
            }
        }
        else{
            
            if (selectedScheduleModel.selectedDate) {
                
                displayTitle = [[self dateFormatter] stringFromDate:selectedScheduleModel.selectedDate];
            }
            else
            {
                displayTitle = @"Time";
            }
            
        }
        
              [cell.btnOne setTitle:displayTitle forState:UIControlStateNormal];

        cell.didSelectBlock = ^(void)
        {
            if (self.packageModel.isScheduled) {
                
                [self showView:^(int selectedIndex) {
                    
                    ScheduleModel* model = arrSelectedScheduleList[selectedIndex];
                    
                    selectedScheduleModel.scheduled_time = model.scheduled_time;
                    
                    selectedScheduleModel.language = model.language;
                    
                    selectedScheduleModel.max_slot = model.max_slot;
                    
                    selectedScheduleModel.min_slot = model.min_slot;

                    selectedScheduleModel.quantity = 0;
                    
                    [self.ibTableView reloadData];
                    
                } Title:@"Select Time" ValueKey:@"scheduled_time"];

            }
            else{
                [self showDatePickerView:indexPath];
            }
            
            
        };
        
        return cell;

    }
    else if ([title isEqualToString:cell_type_language]) {
        
        PackageSelectionTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cell_selection2"];
        
        
        NSString* displayTitle;
        
        
        if (self.packageModel.isScheduled) {
            
            if (![Utils isStringNull:selectedScheduleModel.language]) {
                displayTitle = selectedScheduleModel.language;
            }
            else
            {
                displayTitle = @"Language";
                
            }

            
        }
        else{
            
            if (![Utils isStringNull:selectedScheduleModel.inputLanguage]) {
                displayTitle = selectedScheduleModel.inputLanguage;
            }
            else
            {
                displayTitle = @"Language";
                
            }
            
            cell.didSelectBlock = ^(void)
            {
                [self showInputLanguage];
            };

        }
               [cell.btnOne setTitle:displayTitle forState:UIControlStateNormal];

        return cell;

    }
    
    else if ([title isEqualToString:cell_type_quantity]) {
        
        
        PackageSelectionTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cell_selection3"];
       
        NSString* displayTitle;
        
        if (selectedScheduleModel.quantity) {
            
            displayTitle = [NSString stringWithFormat:@"%@ %@",[selectedScheduleModel.quantity stringValue],@"pax"];

        }
        else
        {
            displayTitle = title;
            
        }
        cell.lblTitle.text = displayTitle;

        
        if (self.packageModel.isScheduled) {
            
            [cell setupCellMinumber:selectedScheduleModel.min_slot MaxNumber:selectedScheduleModel.max_slot SelectedNumber:selectedScheduleModel.quantity];


        }
        else{

            [cell setupCellMinumber:@(0) MaxNumber:@(99) SelectedNumber:selectedScheduleModel.quantity];

        }
        
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

-(void)showDatePickerView:(NSIndexPath*)indexPath
{
    //Create select action
    RMAction *selectAction = [RMAction actionWithTitle:@"Select" style:RMActionStyleDone andHandler:^(RMActionController *controller) {
        NSLog(@"Successfully selected date: %@", ((UIDatePicker *)controller.contentView).date);
        
        
        NSDate* date = ((UIDatePicker *)controller.contentView).date;
        
        selectedScheduleModel.selectedDate = date;
        
    [self.ibTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        
    }];
    
    //Create cancel action
    RMAction *cancelAction = [RMAction actionWithTitle:@"Cancel" style:RMActionStyleCancel andHandler:^(RMActionController *controller) {
        NSLog(@"Date selection was canceled");
    }];
    
    //Create date selection view controller
    RMDateSelectionViewController *dateSelectionController = [RMDateSelectionViewController actionControllerWithStyle:RMActionControllerStyleDefault selectAction:selectAction andCancelAction:cancelAction];
    dateSelectionController.title = @"Date";
    dateSelectionController.message = @"Please choose a date and press 'Select' or 'Cancel'.";
    
    [self presentViewController:dateSelectionController animated:YES completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)showInputLanguage
{
    
    
    UIAlertController * alert =   [UIAlertController
                                  alertControllerWithTitle:@"Please Input language"
                                  message:@""
                                  preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"Language";
    }];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        UITextField *field = alert.textFields.firstObject;
        if (![Utils isStringNull:field.text]) {
            
            
            selectedScheduleModel.inputLanguage = field.text;
            
            [self.ibTableView reloadData];
            
            
        }
        
    }];

    [alert addAction:okAction]; // add action to uialertcontroller
    
    UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alert addAction:cancel];
    
    
    [self presentViewController:alert animated:YES completion:nil];
    
    
}


- (NSDateFormatter *)dateFormatter
{
    static NSDateFormatter *dateFormatter;
    if(!dateFormatter){
        dateFormatter = [NSDateFormatter new];
        dateFormatter.dateFormat = @"dd-MM-yyyy HH:mm";
    }
    
    return dateFormatter;
}


@end

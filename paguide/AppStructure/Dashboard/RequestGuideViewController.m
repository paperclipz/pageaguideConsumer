//
//  RequestGuideViewController.m
//  paguide
//
//  Created by Evan Beh on 01/03/2017.
//  Copyright © 2017 Evan Beh. All rights reserved.
//

#import "RequestGuideViewController.h"
#import "DashboardMainTableViewCell.h"
#import "RequestGuideTableViewCell.h"
#import "HeaderView.h"
#import "FormDataModel.h"
#import "RMDateSelectionViewController.h"


#define cell_type_option @"option"
#define cell_type_multi_select_option @"multi_select_option"
#define cell_type_date @"date"
#define cell_type_number @"number"


@interface RequestGuideViewController ()  <UITableViewDelegate,UITableViewDataSource>
{
    NSArray* arrCellList;
    
}
@property (weak, nonatomic) IBOutlet UIButton *btnSubmit;
@property (weak, nonatomic) IBOutlet UITableView *ibTableView;

@property (nonatomic,strong)NSMutableArray* arrFormDataList;


@end

@implementation RequestGuideViewController
- (IBAction)btnSubmitClicked:(id)sender {
    
    [self showAlertView:@"Are you sure you want to submit this form?" Success:^{
        [self requestServerToSubmitForm];

    } Cancel:^{
        
    }];
}


-(void)initSelfView
{
    [self.btnSubmit setDefaultBorder];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self initSelfView];
    
    [self requestServerForRequestForm];
    
    [self.ibTableView pullToRefresh:^{
        
        [self requestServerForRequestForm];

    }];

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.arrFormDataList.count;

}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{


  

    UIView* view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"header_cell"];

    if (!view) {

        view = [HeaderView initializeCustomView];

    }

    HeaderView* headerView = (HeaderView*)view;

    headerView.lblTitle2.hidden = YES;

    

    FormDataModel* model = self.arrFormDataList[section];
    
    headerView.lblTitle1.text = model.title;

    if ([model.type isEqualToString:cell_type_option]) {
        
    }
    else if ([model.type isEqualToString:cell_type_multi_select_option]) {
        
    }
    else if ([model.type isEqualToString:cell_type_date]) {
        
    }

    return headerView;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FormDataModel* model = self.arrFormDataList[indexPath.section];
    
    if ([model.type isEqualToString:cell_type_number])
    {
        return 80.0f;
    }
    
    else if ([model.type isEqualToString:cell_type_date])
    {
        return 70.0f;

    }
    else{
        return 50.0f;

    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return 30.0f;
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    FormDataModel* model = self.arrFormDataList[section];

    if ([model.type isEqualToString:cell_type_option]) {
        
        
        return model.arrOptionsList.count;
        
    }
    else if ([model.type isEqualToString:cell_type_multi_select_option]) {
    
        
        return model.arrOptionsList.count;
    }
    else if ([model.type isEqualToString:cell_type_date]) {
        
        
        return 1;
    }
    else if ([model.type isEqualToString:cell_type_number]) {
        
        
        return 1;
    }

    
    return 0;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    FormDataModel* model = self.arrFormDataList[indexPath.section];
    
    if ([model.type isEqualToString:cell_type_option]) {
        
        RequestGuideTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cell_request_multipleselection"];

        KeyValueModel* kModel = model.arrOptionsList[indexPath.row];

        cell.lblTitle.text = kModel.key;
        
        [cell setupformData:kModel];
        return cell;
    

    }
    
    else if ([model.type isEqualToString:cell_type_multi_select_option]) {
      
        RequestGuideTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cell_request_multipleselection"];

        KeyValueModel* kModel = model.arrOptionsList[indexPath.row];
        
        cell.lblTitle.text = kModel.key;
        
        [cell setupformData:kModel];
        return cell;

    }
    else if ([model.type isEqualToString:cell_type_date]) {
        
        RequestGuideTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cell_request_date"];

        if (model.viewModel.choosenDate) {
            
            cell.lblTitle.text = [model.viewModel.choosenDate toString];

        }
        else{
            cell.lblTitle.text = model.title;

        }
        
        [Utils setRoundBorder:cell.lblTitle color:[UIColor lightGrayColor] borderRadius:5.0f];
        
        return cell;

    }
    else if ([model.type isEqualToString:cell_type_number]) {
        

        RequestGuideTableViewCell* cell_number = [tableView dequeueReusableCellWithIdentifier:@"cell_request_number"];
        
        
        cell_number.txtField.keyboardType = UIKeyboardTypeNumberPad;
        
        cell_number.txtField.placeholder = @"Please Input A Number";
        
        if (![Utils isStringNull:model.viewModel.value]) {
            
            cell_number.txtField.text = model.viewModel.value;
        }
        else{
            cell_number.txtField.text = @"";

        }
        
        FormDataModel* tempModel = self.arrFormDataList[indexPath.section];

        cell_number.didUpdateStringBlock = ^(NSString* string)
        {
            tempModel.viewModel.value = string;
            
            [self.arrFormDataList replaceObjectAtIndex:indexPath.section withObject:tempModel];
        };
        
        return cell_number;
    }
    
    
    
    
    return nil;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    FormDataModel* model = self.arrFormDataList[indexPath.section];
    
    if ([model.type isEqualToString:cell_type_option]) {
        
        KeyValueModel* kModel = model.arrOptionsList[indexPath.row];
        [model.arrOptionsList removeAllObjects];
        model.arrOptionsList = nil;

       
        kModel.isSelected = YES;
        
        [model.arrOptionsList replaceObjectAtIndex:indexPath.row withObject:kModel];


        
        [self.arrFormDataList replaceObjectAtIndex:indexPath.section withObject:model];

        [self.ibTableView reloadData];

    }
    else if ([model.type isEqualToString:cell_type_multi_select_option]) {
        
        KeyValueModel* kModel = model.arrOptionsList[indexPath.row];
        
        kModel.isSelected =  !kModel.isSelected;
        
        [model.arrOptionsList replaceObjectAtIndex:indexPath.row withObject:kModel];
        
        
        [self.arrFormDataList replaceObjectAtIndex:indexPath.section withObject:model];
        
        [self.ibTableView reloadData];

        
    }
    else if ([model.type isEqualToString:cell_type_date]) {
        
        [self showDatePickerView:indexPath Completion:^(NSDate *date) {
            
            model.viewModel.choosenDate = date;
            
            [self.ibTableView reloadData];
           // [self.ibTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];

        }];
    }
}


#pragma mark - Request Server

-(void)requestServerForRequestForm
{
    
    [LoadingManager show];
    
    [ConnectionManager requestServerWith:AFNETWORK_POST serverRequestType:ServerRequestTypePostUserRequestFormFormat parameter:nil appendString:nil success:^(id object) {
        
        
        [self.ibTableView stopRefresh];
        
        [LoadingManager hide];

        NSError* error;
        
        BaseModel* model = [[BaseModel alloc]initWithDictionary:object error:&error];
        
        if (model.isSuccessful) {
            
             self.arrFormDataList = [FormDataModel arrayOfModelsFromDictionaries:object[@"data"] error:&error];
            
        }
        
        [self.ibTableView reloadData];
        
    } failure:^(id object) {
        
        [self.ibTableView stopRefresh];

        [LoadingManager hide];

    }];
}


-(BOOL)validate
{
    
    
    for (int i = 0; i<self.arrFormDataList.count; i++) {
        
        FormDataModel* model = self.arrFormDataList[i];

        BOOL isOptionEmpty = YES;

        
        if ([model.type isEqualToString:cell_type_option] ||
            [model.type isEqualToString:cell_type_multi_select_option]) {
            
            for (int j = 0; j<model.arrOptionsList.count; j++) {
                
                KeyValueModel* kModel = model.arrOptionsList[j];
                
                if (kModel.isSelected) {
                    
                    
                    isOptionEmpty = NO;
                    
                    break;
                }
            }
            
            if (isOptionEmpty && [model.required isEqualToString:@"yes"]) {
                
                [MessageManager showMessage:[NSString stringWithFormat:@"Please select %@",model.parameter] Type:TSMessageNotificationTypeWarning];
                
                return NO;
            }
        }
        else if ([model.type isEqualToString:cell_type_number])
        {
            
            if ([Utils isStringNull:model.viewModel.value] && [model.required isEqualToString:@"yes"]) {
                
                [MessageManager showMessage:[NSString stringWithFormat:@"Please input a number for %@",model.parameter] Type:TSMessageNotificationTypeWarning];

                return NO;
            }
        }
        
        else if ([model.type isEqualToString:cell_type_date])
        {
            
            if (!model.viewModel.choosenDate && [model.required isEqualToString:@"yes"]) {
                
                [MessageManager showMessage:[NSString stringWithFormat:@"Please select a date for %@",model.parameter] Type:TSMessageNotificationTypeWarning];
                
                return NO;
            }
        }

        
    }
    
    return YES;
}


-(NSDictionary*)getOptionData
{
    
    
    NSMutableDictionary* dict = [NSMutableDictionary new];
    
    for (int i = 0 ; i<self.arrFormDataList.count; i++) {
        
        FormDataModel* model = self.arrFormDataList[i];

        
        if ([model.type isEqualToString:cell_type_option]) {
            
            NSDictionary* dictOptions = [NSDictionary new];
            
            for (int j = 0; j<model.arrOptionsList.count;j++) {
                KeyValueModel* kModel = model.arrOptionsList[j];

                if (kModel.isSelected) {
                    
                    dictOptions = @{model.parameter : kModel.key};
                    
                    [dict addEntriesFromDictionary:dictOptions];
                    
                    break;

                }

            }
            
            
        }else if ([model.type isEqualToString:cell_type_multi_select_option])
        {
        
            NSDictionary* dictOptions = [NSDictionary new];
            
            NSMutableArray* arrOptions = [NSMutableArray new];
            
            for (int j = 0; j<model.arrOptionsList.count;j++) {
                KeyValueModel* kModel = model.arrOptionsList[j];
                
                if (kModel.isSelected) {
                    
                    
                    [arrOptions addObject:kModel.key];
                    
                    
                }
                
            }
            
            
            if (![Utils isArrayNull:arrOptions]) {
                dictOptions = @{model.parameter : arrOptions};
                
                [dict addEntriesFromDictionary:dictOptions];
            }
          

        }
        else if ([model.type isEqualToString:cell_type_date])
        {
        
            if (model.viewModel.choosenDate) {
                
                NSDictionary* dictOptions = @{model.parameter : model.viewModel.choosenDate.toString};

                [dict addEntriesFromDictionary:dictOptions];

            }
        }
        
        else if ([model.type isEqualToString:cell_type_number])
        {
            if (![Utils isStringNull:model.viewModel.value]) {
                
                NSDictionary* dictOptions = @{model.parameter : model.viewModel.value};
                
                [dict addEntriesFromDictionary:dictOptions];
                
            }

            
        }
    }
    
    NSLog(@"dict %@",dict);
    
    return dict;
}

-(void)requestServerToSubmitForm
{
    if (![self validate]) {
        return;
    }
    
    NSString* token = [Utils getToken];
    
    NSDictionary* dictToken = @{@"token" : IsNullConverstion(token),
                           };
    
    
    NSDictionary* options = [self getOptionData];
    
    
    NSMutableDictionary* dict = [[NSMutableDictionary alloc]initWithDictionary:dictToken];
    
    [dict addEntriesFromDictionary:options];
    
//    NSDictionary* dictTimes = @{@"times" : @""};
//    NSDictionary* dictSpecialty = @{@"specialty" : @""};
//    NSDictionary* dictQualifications = @{@"qualifications" : @""};
//

    
    NSLog(@"final : %@",dict);
    
    [ConnectionManager requestServerWith:AFNETWORK_POST serverRequestType:ServerRequestTypePostRequestCreate parameter:dict appendString:nil success:^(id object) {
        
        BaseModel* model = [[BaseModel alloc]initWithDictionary:object error:nil];
        
        [MessageManager showMessage:model.displayMessage Type:TSMessageNotificationTypeSuccess inViewController:self];
   
        [self requestServerForRequestForm];
        
        [Utils reloadAllAppointView];
    
    } failure:^(id object) {
        
        BaseModel* model = [[BaseModel alloc]initWithDictionary:object error:nil];
        
        [MessageManager showMessage:model.displayMessage Type:TSMessageNotificationTypeError inViewController:self];
    }];
}


#pragma mark - Show View

-(void)showDatePickerView:(NSIndexPath*)indexPath Completion:(NSDateBlock)completionWithDate
{
    //Create select action
    RMAction *selectAction = [RMAction actionWithTitle:@"Select" style:RMActionStyleDone andHandler:^(RMActionController *controller) {
        NSLog(@"Successfully selected date: %@", ((UIDatePicker *)controller.contentView).date);
        
     
        if (completionWithDate) {
            completionWithDate( ((UIDatePicker *)controller.contentView).date);
        }
//        NSInteger time = interval/1000.0;
//        
//        NSString* tentativeDate = [NSString stringWithFormat:@"%li",(long)time];
//        
//        
//        NSLog(@"time interval selected : %@",tentativeDate);
//        
//        [self.ibTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        
    }];
    
    //Create cancel action
    RMAction *cancelAction = [RMAction actionWithTitle:@"Cancel" style:RMActionStyleCancel andHandler:^(RMActionController *controller) {
        NSLog(@"Date selection was canceled");
    }];
    
    //Create date selection view controller
    RMDateSelectionViewController *dateSelectionController = [RMDateSelectionViewController actionControllerWithStyle:RMActionControllerStyleDefault selectAction:selectAction andCancelAction:cancelAction];
    dateSelectionController.title = @"Test";
    dateSelectionController.message = @"This is a test message.\nPlease choose a date and press 'Select' or 'Cancel'.";
    
    //Now just present the date selection controller using the standard iOS presentation method
    
    [self.tabBarController presentViewController:dateSelectionController animated:YES completion:nil];
}

-(IBAction)showAlertView:(NSString*)title Success:(VoidBlock)sucess Cancel:(VoidBlock)cancelBlock
{
    
    
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:@""
                                  message:title
                                  preferredStyle:UIAlertControllerStyleAlert];
    
    
    UIAlertAction* ok = [UIAlertAction
                         actionWithTitle:@"YES"
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                         {
                             

                             if (sucess) {
                                 sucess();
                             }
                             
                             
                         }];
    [alert addAction:ok]; // add action to uialertcontroller
    
    UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        
        if (cancelBlock) {
            cancelBlock();
        }
    }];
    
    [alert addAction:cancel];
    
    
    [self presentViewController:alert animated:YES completion:nil];
    
    
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

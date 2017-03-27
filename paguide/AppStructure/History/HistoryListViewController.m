//
//  HistoryListViewController.m
//  paguide
//
//  Created by Evan Beh on 03/03/2017.
//  Copyright © 2017 Evan Beh. All rights reserved.
//

#import "HistoryListViewController.h"
#import "PackageTableViewCell.h"
#import "AppointmentViewController.h"

#import "AppointmentModel.h"
#import "AppointmentWrapperModel.h"
#import "AppointmentRequestViewController.h"

@protocol AppointmentModel;

#define PER_PAGE @"10"

@interface HistoryListViewController () <UITableViewDelegate, UITableViewDataSource>
{
    AppointmentModel* apptModel;

}
@property (nonatomic) PagingViewModel* vm_appointment_paging;
@property (nonatomic) NSMutableArray<AppointmentModel>* arrAppointmentList;

@property (weak, nonatomic) IBOutlet UITableView *ibTableView;

@end

@implementation HistoryListViewController

-(NSMutableArray<AppointmentModel>*)arrAppointmentList{
    
    if (!_arrAppointmentList) {
        _arrAppointmentList = (NSMutableArray<AppointmentModel>*)[NSMutableArray new];
    }
    
    return _arrAppointmentList;
}

-(PagingViewModel*)vm_appointment_paging
{
    if (!_vm_appointment_paging) {
        _vm_appointment_paging = [PagingViewModel new];
    }
    
    return _vm_appointment_paging;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.ibTableView pullToRefresh:^{
        
        [self resetAndCallAppointmentListing];
        
    }];
    
    [self requestServerForAppointmentList];

    
    // Do any additional setup after loading the view.
}

-(void)resetAndCallAppointmentListing
{
    _vm_appointment_paging = nil;
    
    [self.arrAppointmentList removeAllObjects];
    
    self.arrAppointmentList = nil;
    
    [self.ibTableView reloadData];
    
    
    [self requestServerForAppointmentList];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.arrAppointmentList.count;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    apptModel = self.arrAppointmentList[indexPath.row];
    
    if ([apptModel.type isEqualToString:@"request"]) {
        
        [self performSegueWithIdentifier: @"appointment_request_details" sender:self];
        
    }else{
        [self performSegueWithIdentifier: @"history_details" sender:self];

        
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PackageTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"packageCell"];
    
    AppointmentModel* model = self.arrAppointmentList[indexPath.row];
    
    
    if ([model.type isEqualToString:@"request"]) {
        
        cell.lblPackage.hidden = YES;
        
        cell.lblTitle1.text = model.appointment_code;
        
        cell.lblTitle2.text = [model.request_info.specialty componentsJoinedByString:@","];
        
        
        NSString* string1 = @"Appointment : ";
        NSString* string2 = model.request_info.date;
        
        cell.lblTitle3.attributedText = [self convertAttributedStringFor:[NSString stringWithFormat:@"%@%@",string1,string2] StringToChange:string1];
        
        
        
        NSString* string3 = @"Merchant : ";
        NSString* string4 = model.merchant_info_model.name;
        
        cell.lblTitle4.attributedText = [self convertAttributedStringFor:[NSString stringWithFormat:@"%@%@",string3,string4] StringToChange:string1];
    }
    
    else{
        
        cell.lblPackage.hidden = NO;
        
        cell.lblTitle1.text = model.appointment_code;
        
        cell.lblTitle2.text = model.package_info.name;
        
        NSString* string1 = @"Appointment : ";
        NSString* string2 = model.package_info.package_date;
        
        cell.lblTitle3.attributedText = [self convertAttributedStringFor:[NSString stringWithFormat:@"%@%@",string1,string2] StringToChange:string1];
        
        
        NSString* string3 = @"Merchant : ";
        NSString* string4 = model.merchant_info_model.name;
        
        cell.lblTitle4.attributedText = [self convertAttributedStringFor:[NSString stringWithFormat:@"%@%@",string3,string4] StringToChange:string3];
    }
    
    
    return cell;
}

#pragma mark - Request Server

-(void)requestServerForAppointmentList
{
    
    if (self.vm_appointment_paging.isLoading || !self.vm_appointment_paging.hasNext) {
        return;
        
    }
    self.vm_appointment_paging.isLoading = YES;
    
    //IsNullConverstion([GVUserDefaults standardUserDefaults].token)
    NSString* token = [Utils getToken];
    NSDictionary* dict = @{
                           @"token" : token,
                           @"per_page" : PER_PAGE,
                           @"page" : @(self.vm_appointment_paging.currentPage + 1)
                           };
    
    [ConnectionManager requestServerWith:AFNETWORK_POST serverRequestType:ServerRequestTypePostHistoryListing parameter:dict appendString:nil success:^(id object) {
        
        self.vm_appointment_paging.isLoading = NO;
        
        NSError* error;
        
        AppointmentWrapperModel* model = [[AppointmentWrapperModel alloc]initWithDictionary:object error:&error];
        
        [self.vm_appointment_paging processPagingFrom:model.pageContent];
        
        [self.ibTableView stopRefresh];
        
        [self.arrAppointmentList addObjectsFromArray:model.arrAppointmentList];
        
        [self.ibTableView reloadData];
        
    } failure:^(id object) {
        self.vm_appointment_paging.isLoading = NO;
        
    }];
}

-(NSMutableAttributedString*)convertAttributedStringFor:(NSString*)fullString StringToChange:(NSString*)substring
{
    
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:fullString];
    
    NSRange string1_range1 = [attributeString.string rangeOfString:substring];
    
    [attributeString addAttribute:NSFontAttributeName
                            value:[UIFont fontWithName:@"Helvetica-Bold" size:15.0]
                            range:string1_range1];
    
    
    [attributeString addAttribute:NSForegroundColorAttributeName
                            value:APP_MAIN_COLOR
                            range:string1_range1];
    
    return attributeString;
}
#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([[segue identifier] isEqualToString:@"history_details"]) {
        // Get destination view
        AppointmentViewController *vc = [segue destinationViewController];
        
        vc.viewType = APPOITNMENT_VIEW_TYPE_HISTORY;
        
        [vc setupData:apptModel];

    }
    else if ([[segue identifier] isEqualToString:@"appointment_request_details"]) {
        
        AppointmentRequestViewController *vc = [segue destinationViewController];
        
        [vc setupData:apptModel];
        
    }
    
}




@end

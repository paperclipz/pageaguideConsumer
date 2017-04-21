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

#define PER_PAGE @"20"

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

-(void)viewWillAppear:(BOOL)animated
{
    
    if (![Utils isUserLogin])
    {
        
        [self.arrAppointmentList removeAllObjects];
        
        self.arrAppointmentList = nil;
        
        [self.ibTableView reloadData];
        
    }
    
    else if (self.isNeedReload) {
        
        [self resetAndCallAppointmentListing];
        self.isNeedReload = NO;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.ibTableView pullToRefresh:^{
        
        [self resetAndCallAppointmentListing];
        
    }];
    
    [self.ibTableView setupCustomEmptyView];

    [self.ibTableView setupFooterView];

    [self requestServerForAppointmentList];

    
    // Do any additional setup after loading the view.
}

-(void)resetAndCallAppointmentListing
{
    
    if (self.vm_appointment_paging.isLoading)
    {
        return;
    }
    
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
        
        cell.lblTitle2.text = [NSString validateText:model.request_info.title];
        
        NSString* string1 = @"Appointment : ";
        NSString* string2 = [NSString validateText:model.transaction_date];
        
        cell.lblTitle3.attributedText = [self convertAttributedStringFor:[NSString stringWithFormat:@"%@%@",string1,string2] StringToChange:string1];
        
        NSString* string3 = @"Completed date : ";
        NSString* string4 = [NSString validateText:model.complete_time];
        
        cell.lblTitle4.attributedText = [self convertAttributedStringFor:[NSString stringWithFormat:@"%@%@",string3,string4] StringToChange:string1];
    }
    
    else{
        
        cell.lblPackage.hidden = NO;
        
        cell.lblTitle1.text = [NSString validateText:model.appointment_code];
        
        cell.lblTitle2.text = [NSString validateText:model.package_info_model.name];
        
        NSString* string1 = @"Appointment : ";
        NSString* string2 = [NSString validateText:model.package_info_model.package_date];
        
        cell.lblTitle3.attributedText = [self convertAttributedStringFor:[NSString stringWithFormat:@"%@%@",string1,string2] StringToChange:string1];
        
        NSString* string3 = @"Completed date : ";
        NSString* string4 = [NSString validateText:model.complete_time];
        
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
    
    if (self.vm_appointment_paging.currentPage == 0)
    {
        [LoadingManager show];
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
        
        [LoadingManager hide];

        self.vm_appointment_paging.isLoading = NO;
        
        NSError* error;
        
        AppointmentWrapperModel* model = [[AppointmentWrapperModel alloc]initWithDictionary:object error:&error];
        
        [self.vm_appointment_paging processPagingFrom:model.pageContent];
        
        [self.ibTableView stopRefresh];
        
        [self.arrAppointmentList addObjectsFromArray:model.arrAppointmentList];
        
        [self.ibTableView reloadData];
        
        [self.ibTableView stopFooterLoadingView];
        
        [self.ibTableView customTableViewReloadData];
        
    } failure:^(id object) {
        
        self.vm_appointment_paging.isLoading = NO;
        
        [self.ibTableView stopFooterLoadingView];

        [self.ibTableView customTableViewReloadData];

        [LoadingManager hide];

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

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.ibTableView scrollViewDidScroll:scrollView activated:^{
        
        if (self.vm_appointment_paging.hasNext && self.vm_appointment_paging.currentPage > 0) {
            
            [self.ibTableView startFooterLoadingView];
            
            [self requestServerForAppointmentList];
        }
        
    }];
    
    
}// any offset changes





@end

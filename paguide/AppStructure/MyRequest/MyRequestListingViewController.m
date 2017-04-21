//
//  MyRequestListingViewController.m
//  paguide
//
//  Created by Evan Beh on 20/03/2017.
//  Copyright © 2017 Evan Beh. All rights reserved.
//

#import "MyRequestListingViewController.h"
#import "PackageTableViewCell.h"
#import "AppointmentWrapperModel.h"
#import "AppointmentModel.h"
#import "MyRequestDetailViewController.h"

#define PER_PAGE @"20"

@interface MyRequestListingViewController () <UITableViewDelegate, UITableViewDataSource>
{
    AppointmentModel* apptModel;

}
@property (weak, nonatomic) IBOutlet UITableView *ibTableView;

@property (nonatomic) PagingViewModel* vm_appointment_paging;
@property (nonatomic) NSMutableArray<AppointmentModel>* arrAppointmentList;

@end

@implementation MyRequestListingViewController

-(NSMutableArray<AppointmentModel>*)arrAppointmentList{
    
    if (!_arrAppointmentList) {
        _arrAppointmentList = (NSMutableArray<AppointmentModel>*)[NSMutableArray new];
    }
    
    return _arrAppointmentList;
}

-(void)viewDidAppear:(BOOL)animated
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
    
    self.ibTableView.delegate = self;
    self.ibTableView.dataSource = self;
    
    
    [self.ibTableView pullToRefresh:^{
        
        [self resetAndCallAppointmentListing];
        
    }];
    
    [self.ibTableView setupCustomEmptyView];

    [self requestServerforMyRequestList];
    
    [self.ibTableView setupFooterView];


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
    
    [self requestServerforMyRequestList];
    
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PackageTableViewCell*cell = [tableView dequeueReusableCellWithIdentifier:@"packageCell"];
    
    AppointmentModel* model = self.arrAppointmentList[indexPath.row];
    
    
    cell.lblTitle1.text = model.request_code;
    
    cell.lblTitle2.text = [NSString validateText:model.request_info.title];
    
    NSString* string1 = @"Requested Date : ";
    NSString* string2 = model.request_info.created_at;
    
    cell.lblTitle3.attributedText = [self convertAttributedStringFor:[NSString stringWithFormat:@"%@%@",string1,string2] StringToChange:string1];
    
    
    
    NSString* string3 = @"Status : ";
    NSString* string4 = model.status;
    
    cell.lblTitle4.attributedText = [self convertAttributedStringFor:[NSString stringWithFormat:@"%@%@",string3,string4] StringToChange:string1];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    apptModel = self.arrAppointmentList[indexPath.row];
    
    [self performSegueWithIdentifier: @"myrequest_detail" sender:self];
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

#pragma mark - Request Server

-(void)requestServerforMyRequestList
{
    

    if (self.vm_appointment_paging.isLoading || !self.vm_appointment_paging.hasNext) {
        return;
        
    }
    self.vm_appointment_paging.isLoading = YES;

    if (self.vm_appointment_paging.currentPage == 0) {
        
        [LoadingManager show];
    }

    NSDictionary* dict = @{@"token" : [Utils getToken],
                           @"per_page" : PER_PAGE,
                           @"page" : @(self.vm_appointment_paging.currentPage + 1)

                           };
    
    [ConnectionManager requestServerWith:AFNETWORK_POST serverRequestType:ServerRequestTypePostRequestConsumerlisting parameter:dict appendString:nil success:^(id object) {
        
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
     
        [LoadingManager hide];

        self.vm_appointment_paging.isLoading = NO;

        [self.ibTableView stopFooterLoadingView];

        [self.ibTableView customTableViewReloadData];

    }];
                           
}

-(PagingViewModel*)vm_appointment_paging
{
    if (!_vm_appointment_paging) {
        _vm_appointment_paging = [PagingViewModel new];
    }
    
    return _vm_appointment_paging;
}

//// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([[segue identifier] isEqualToString:@"myrequest_detail"]) {
        
        MyRequestDetailViewController *vc = [segue destinationViewController];
        
        [vc setupData:apptModel];
        
    }
    
    
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.ibTableView scrollViewDidScroll:scrollView activated:^{
        
        if (self.vm_appointment_paging.hasNext && self.vm_appointment_paging.currentPage > 0) {
            
            [self.ibTableView startFooterLoadingView];
            
            [self requestServerforMyRequestList];
        }
        
    }];
    
    
}// any offset changes


@end

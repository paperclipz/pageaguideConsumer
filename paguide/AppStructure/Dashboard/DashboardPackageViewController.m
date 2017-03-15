//
//  DashboardPackageViewController.m
//  paguide
//
//  Created by Evan Beh on 01/03/2017.
//  Copyright © 2017 Evan Beh. All rights reserved.
//

#import "DashboardPackageViewController.h"
#import "DashboardPackageTableViewCell.h"
#import "CalenderViewController.h"
#import "PackageDetailsViewController.h"
#import "RatingViewController.h"

@interface DashboardPackageViewController () <UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *ibTableView;

@property (weak, nonatomic) IBOutlet UIButton *btnFilter;
@end

@implementation DashboardPackageViewController
- (IBAction)btnFilterClicked:(id)sender {
}
- (IBAction)btnLoginClicked:(id)sender {
    
  
    [Utils showRegisterPage];
}
- (IBAction)btnTest2Clicked:(id)sender {
    
    
    RatingViewController* rVC = [RatingViewController new];
    rVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    rVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    
    [self.tabBarController presentViewController:rVC animated:YES completion:nil];
    
//    __weak typeof (self)weakSelf = self;
    
//    self.promoCodeViewController.didApplyPromoBlock = ^(void)
//    {
//        [weakSelf.promoCodeViewController dismissViewControllerAnimated:YES completion:^{
//            
//            
//            [weakSelf.navigationController popToRootViewControllerAnimated:YES];
//        }];
//    };
    

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self initSelfView];

    [self requestServerForPackageListing];

    // Do any additional setup after loading the view.
}

-(void)initSelfView
{
    [Utils setRoundBorder:self.btnFilter color:[UIColor clearColor] borderRadius:self.btnFilter.frame.size.height/2];
    
    self.btnFilter.backgroundColor = [UIColor whiteColor];
    
    self.btnFilter.tintColor = [UIColor redColor];
    
    self.btnFilter.layer.shadowColor = [UIColor blackColor].CGColor;
    self.btnFilter.layer.shadowOpacity = 0.5;
    self.btnFilter.layer.shadowRadius = 1;
    self.btnFilter.layer.shadowOffset = CGSizeMake(5.0f, 5.0f);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DashboardPackageTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"dashPackageCell"];
    
    
    [cell.ibImageView sd_setImageWithURL:[NSURL URLWithString:@"http://www.mediastinger.com/wp-content/uploads/2016/02/Batman-v-Superman-Final-Trailer-hq.jpg"]];
    
    cell.lblTitle1.text = @"badman vs superman";
    

    NSString* string2 = @"RM 89.90 72.00 | save 13.50";
    
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:string2];
    
    NSRange string2_range1 = [attributeString.string rangeOfString:@"RM 89.90"];
    NSRange string2_range2 = [attributeString.string rangeOfString:@"72.00"];

    
    
    [attributeString addAttribute:NSStrikethroughStyleAttributeName
                            value:@2
                            range:string2_range2];
    
    

    [attributeString addAttribute:NSFontAttributeName
                   value:[UIFont fontWithName:@"Helvetica-Bold" size:12.0]
                   range:string2_range1];
  
    
    [attributeString addAttribute:NSForegroundColorAttributeName
                            value:[UIColor redColor]
                            range:string2_range1];
    

    
    cell.lblTitle2.attributedText = attributeString;
    
    cell.lblTitle3.text = @"Travel sdn Bhd";
    
    cell.lblTitle4.text = @"GOGO";
    
    cell.lblTitle5.text = @"2 slot left";
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"package_details" sender:self];
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([[segue identifier] isEqualToString:@"package_details"]) {
        
        PackageDetailsViewController *vc = [segue destinationViewController];
        
        vc.viewType = PACKAGE_VIEW_TYPE_AVAILABILIY;

    }
}

#pragma mark - Request Server

-(void)requestServerForPackageListing
{
    NSDictionary* dict = @{@"per_page" : @"",
                           @"page" : @"1",
                           @"filter" : @"Historical",
                           
                           };
    
    [ConnectionManager requestServerWith:AFNETWORK_POST serverRequestType:ServerRequestTypePostPackageListing parameter:dict appendString:nil success:^(id object) {
        
        
    } failure:^(id object) {
        
    }];
}
@end

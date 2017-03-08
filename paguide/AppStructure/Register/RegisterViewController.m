//
//  RegisterViewController.m
//  paguide
//
//  Created by Evan Beh on 27/02/2017.
//  Copyright © 2017 Evan Beh. All rights reserved.
//

#import "RegisterViewController.h"
#import "RegisterTableViewCell.h"
#import "EBActionSheetViewController.h"

#define viewTypeLogin @"login"
#define viewTypeRegister @"register"

@protocol KeyValueModel;

@interface cellObject : NSObject

@property (nonatomic, strong)NSString* placeHolder;
@property (nonatomic, assign)REGISTER_CELL_TYPE type;

@end

@implementation cellObject
@end


@interface RegisterViewController () <UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIButton *btnSubmit;
@property (nonatomic,strong) NSArray* arrItemList;
@property (nonatomic, strong)NSString* viewType;

@end

@implementation RegisterViewController
- (IBAction)btnSubmitClicked:(id)sender {
}
- (IBAction)btnTestClicked:(id)sender {
    
   // self.definesPresentationContext = YES;
    
    [self showActionView];
    
}
- (IBAction)btnBackClicked:(id)sender {
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - System lifecycle

-(void)viewWillAppear:(BOOL)animated
{
    
    if ([self.viewType isEqualToString:viewTypeLogin]) {
    
        [self.navigationController setNavigationBarHidden:YES];

    }
    else{
        [self.navigationController setNavigationBarHidden:NO];

    }
    
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    if ([self.viewType isEqualToString:viewTypeLogin]) {
        
        [self.navigationController setNavigationBarHidden:NO];
        
    }
    else
    {
        [self.navigationController setNavigationBarHidden:NO];

    }

}


- (void)viewDidLoad {
    [super viewDidLoad];
    
//    NSString* type = [self valueForKey:@"viewType"];
//    
//    
//    @try {
//        NSLog(@"user define : %@",type);
//
//    } @catch (NSException *exception) {
//        
//        
//        NSLog(@"user define have error");
//
//    }
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self initSelfView];

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - View Object


-(void)initSelfView
{
    [Utils setRoundBorder:self.btnSubmit color:[UIColor clearColor] borderRadius:5.0f];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.view.backgroundColor = [UIColor clearColor];
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    
}

-(NSArray*)arrItemList
{
    
    if (!_arrItemList) {
        

        NSMutableArray* arrayTemp = [NSMutableArray new];
        
        cellObject* obj = [cellObject new];
        obj.placeHolder = @"Email Addess";
        obj.type = REGISTER_CELL_TYPE_email_address;

        [arrayTemp addObject:obj];
        
        obj = [cellObject new];
        obj.placeHolder = @"Name";
        obj.type = REGISTER_CELL_TYPE_name;
        
        [arrayTemp addObject:obj];
        
        obj = [cellObject new];
        obj.placeHolder = @"Country";
        obj.type = REGISTER_CELL_TYPE_country;
        
        [arrayTemp addObject:obj];
        
        obj = [cellObject new];
        obj.placeHolder = @"Phone Number";
        obj.type = REGISTER_CELL_TYPE_phone_number;
        
        [arrayTemp addObject:obj];
        
        _arrItemList = arrayTemp;
        
        obj = [cellObject new];
        obj.placeHolder = @"Term of Use";
        obj.type = REGISTER_CELL_TYPE_TNC;
        
        [arrayTemp addObject:obj];
        
        _arrItemList = arrayTemp;

        
    }

    return _arrItemList;
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrItemList.count;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    cellObject* obj = self.arrItemList[indexPath.row];
    
    REGISTER_CELL_TYPE cellType = obj.type;

    
    if (cellType == REGISTER_CELL_TYPE_TNC) {
        
        RegisterTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"registerCell2"];
        
        KeyValueModel* model = [KeyValueModel new];
        model.key = @"termofservice";
        model.value = @"Terms of Service";
        
        KeyValueModel* model2 = [KeyValueModel new];
        model2.key = @"privacypolicy";
        model2.value = @"Privacy Policy";
        
        NSArray* array = @[model,model2];
        
        [cell setup:T_N_C KeyValue:array DidClickBlock:^(NSString *str) {
            
            
            for (int i = 0; i<array.count; i++) {
                
                KeyValueModel* tempModel = array[i];
                
                if ([tempModel.key isEqualToString:@"termofservice"] ) {
                    [self showTermOfUseView];
                    break;
                }
                else if ([tempModel.key isEqualToString:@"privacypolicy"] ) {
                    
                    [self showPrivacyView];
                    break;
                    
                }
            }
            
            
        }];
        return cell;


    }
    else if (cellType == REGISTER_CELL_TYPE_country)
    {
        RegisterTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"registercell3"];
        
        cell.lblCustomTitle.text = obj.placeHolder;
        
        cell.didSelectBlock = ^(void)
        {
            [self showActionView];
        };
        
        return cell;

    
    
    }
    
    else if (cellType == REGISTER_CELL_TYPE_phone_number)
    {
        RegisterTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"registercell4"];
        
        cell.txtDefault.placeholder = obj.placeHolder;
        
        [cell.btnPrefix setTitle:@"Prefix" forState:UIControlStateNormal];
        
        cell.didSelectBlock = ^(void)
        {
            [self showActionView];

        };
        
        
        return cell;
        
        
        
    }

    else{
    
        RegisterTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"registerCell"];

    
         cell.txtDefault.placeholder = obj.placeHolder;
    
        return cell;
    }

    
   
}



-(void)showPrivacyView
{
    NSLog(@"showPrivacyView");

}

-(void)showTermOfUseView
{
    NSLog(@"showTermOfUseView");
}

-(void)showActionView
{
    EBActionSheetViewController* viewC = [[EBActionSheetViewController alloc]initWithNibName:@"EBActionSheetViewController" bundle:nil];
    
    viewC.title = @"Country Selection";
    // viewC.view.backgroundColor = [UIColor colorWithRed:10 green:10 blue:10 alpha:0.5];
    //  UINavigationController* navC = [[UINavigationController alloc]initWithRootViewController:viewC];
    
    // [navC setNavigationBarHidden:YES];
    
    
    viewC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    viewC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    
    [self presentViewController:viewC animated:YES completion:nil];
    

}


@end

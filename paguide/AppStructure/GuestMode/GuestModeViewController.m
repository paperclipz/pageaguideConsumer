//
//  GuestModeViewController.m
//  paguide
//
//  Created by Evan Beh on 02/11/2017.
//  Copyright © 2017 Evan Beh. All rights reserved.
//

#import "GuestModeViewController.h"
#import "GeneralTableViewCell.h"
#import "EBActionSheetViewController.h"
#import "GeneralView.h"


@protocol CountryModel
@end

@interface GuestModeViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic,copy)IDBlock guestBlock;
@property (nonatomic,copy)IDBlock loginBlock;
@property(nonatomic,strong)NSMutableDictionary* dictCells;
@property (nonatomic, strong)NSArray<CountryModel>* arrCountryList;

@end

@implementation GuestModeViewController


-(ProfileModel*)getData
{
    
    GeneralTableViewCell* cell = (GeneralTableViewCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];

    ProfileModel* gModel = [ProfileModel new];
    
    gModel.name = cell.txtField.text;
    gModel.email = cell.txtField2.text;
    gModel.temp_prefix = cell.ibButton2.titleLabel.text;
    gModel.temp_mobile_number = cell.txtField3.text;

    
    
    return gModel;
    
}

-(BOOL)validateGuestMode:(ProfileModel*)gModel
{
    BOOL isPass = YES;
    
    
    if ([Utils isStringNull:gModel.name]) {
        
        [MessageManager showMessage:@"Please input in your name" Type:TSMessageNotificationTypeError];
        isPass = false;
    }
    else if ([Utils isStringNull:gModel.email])
    {
        [MessageManager showMessage:@"Please input in your email" Type:TSMessageNotificationTypeError];
        isPass = false;

    }
    else if ([Utils isStringNull:gModel.temp_prefix])
    {
        [MessageManager showMessage:@"Please select phone number prefix" Type:TSMessageNotificationTypeError];
        isPass = false;
        
    }
    else if ([Utils isStringNull:gModel.temp_mobile_number])
    {
        [MessageManager showMessage:@"Please input in your phone number" Type:TSMessageNotificationTypeError];
        isPass = false;

    }

    
    return isPass;
}

-(void)userDidSelecGuestMode:(IDBlock)guestCompletion userDidLogin:(IDBlock)loginCompletion
{
    self.guestBlock = guestCompletion;
    self.loginBlock = loginCompletion;
    
}


-(void)setupTableView
{
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.tableView.estimatedRowHeight = 100.0f;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.dictCells = [NSMutableDictionary new];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTableView];
    self.edgesForExtendedLayout = UIRectEdgeNone;

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell* cacheCell = [self.dictCells objectForKey:[NSString stringWithFormat:@"section : %ld || row : %ld",(long)indexPath.section,(long)indexPath.row]];
    
   
    
    if (indexPath.row == 0) {
        
        GeneralTableViewCell* cell;
        
        if (cacheCell) {
            
            cell = (GeneralTableViewCell*)cacheCell;
        }
        else
        {
            cell = [tableView dequeueReusableCellWithIdentifier:@"cell_gm1"];
            
            [self.dictCells setObject:cell forKey:[NSString stringWithFormat:@"section : %ld || row : %ld",(long)indexPath.section,(long)indexPath.row]];
        }
        
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        
        cell.lblHeader.text = @"Continue Using Guest Mode. Please fill the the details below";
        cell.lblTitle.textColor = [UIColor darkGrayColor];
        cell.lblTitle2.textColor = [UIColor darkGrayColor];
        cell.lblTitle3.textColor = [UIColor darkGrayColor];

        cell.txtField.borderStyle = UITextBorderStyleNone;
        cell.txtField2.borderStyle = UITextBorderStyleNone;
        cell.txtField3.borderStyle = UITextBorderStyleNone;

        [cell.ibButton1 setTitle:@"Guest Mode" forState:UIControlStateNormal];
        
        [cell.ibButton1 setTintColor:[UIColor whiteColor]];
        [Utils setRoundBorder:cell.ibButton1 color:[UIColor clearColor] borderRadius:cell.ibButton1.frame.size.height/2];
        cell.ibButton1.backgroundColor = APP_MAIN_COLOR;

        cell.didSelectInnerButton1Block = ^{
            
            ProfileModel* gModel = [self getData];
            
            
            if ([self validateGuestMode:gModel]) {
                
                if (self.guestBlock) {
                    self.guestBlock(gModel);
                }
            }
            
        };
        
        
        [cell.ibButton2 setTitle:@"Prefix" forState:UIControlStateNormal];
        [cell.ibButton2 setTintColor:APP_MAIN_COLOR];

        
        
        __weak typeof (cell)weakCell = cell;
        
        cell.didSelectInnerButton2Block = ^{
        
            [self showPrefixView:^(NSString *str) {
                
                [weakCell.ibButton2 setTitle:str forState:UIControlStateNormal];

                
            }];
        };
        
        cell.lblTitle.text = @"Name";
        cell.lblTitle2.text = @"Email";
        cell.lblTitle3.text = @"Contact Number";

        return cell;

    }
    else
    {
        GeneralTableViewCell* cell;
        

        if (cacheCell) {
            
            cell = (GeneralTableViewCell*)cacheCell;
        }
        else
        {
            cell = [tableView dequeueReusableCellWithIdentifier:@"cell_gm2"];
            
            [self.dictCells setObject:cell forKey:[NSString stringWithFormat:@"section : %ld || row : %ld",(long)indexPath.section,(long)indexPath.row]];
        }
        [cell.ibButton1 setTitle:@"Login" forState:UIControlStateNormal];
        [Utils setRoundBorder:cell.ibButton1 color:[UIColor clearColor] borderRadius:cell.ibButton1.frame.size.height/2];
        cell.ibButton1.backgroundColor = APP_MAIN_COLOR;
        [cell.ibButton1 setTintColor:[UIColor whiteColor]];

        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        cell.lblHeader.text = @"Login or register your account here. Press the Login button below!!";

        
        cell.didSelectInnerButton1Block = ^{
            
            [Utils showRegisterPage];
            
        };
        return cell;

    }
    
    
    
    
}

-(void)showPrefixView:(StringBlock)completion
{
    VoidBlock openPopOutView = ^(void)
    {
        EBActionSheetViewController* viewC = [[EBActionSheetViewController alloc]initWithNibName:@"EBActionSheetViewController" bundle:nil];
        viewC.title = @"Prefix";
        
        viewC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        viewC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        
        viewC.arrItemList = [self getPrefixList:self.arrCountryList];
        
        CountryModel* defaultSelection = [DataManager getDefaultPrefix];
        NSArray* arrDefault;
        
        if (defaultSelection) {
            
            arrDefault = @[defaultSelection];
            
            [viewC setDefaultData:[self getPrefixList:arrDefault]];
        }
        
        viewC.arrItemList = [self getPrefixList:self.arrCountryList];
        
        [self presentViewController:viewC animated:YES completion:nil];
        
        //   [viewC setInitial:[NSIndexPath indexPathForRow:[self getSingaporeIndexPath] inSection:[Utils isArrayNull:arrDefault]?0:1]];
        
        __weak typeof (viewC)weakVC = viewC;
        
        viewC.didSelectAtIndexBlock = ^(NSIndexPath* indexPath)
        {
            [weakVC dismissViewControllerAnimated:YES completion:^{
                NSString* prefix;
                
                if ([Utils isArrayNull:arrDefault]) {
                    
                    CountryModel* model = self.arrCountryList[indexPath.row];
                    
                    prefix = model.c_prefix;
                    
                    [DataManager saveDefaultPrefix:model];
                }
                else{
                    
                    
                    if (indexPath.section == 0) {
                        CountryModel* model = arrDefault[indexPath.row];
                        
                        prefix = model.c_prefix;
                    }
                    else{
                        
                        CountryModel* model = self.arrCountryList[indexPath.row];
                        
                        prefix = model.c_prefix;
                        
                        [DataManager saveDefaultPrefix:model];
                        
                    }
                    
                }
                
                
                if (completion) {
                    completion(prefix);
                }
            }];
            
        };
    };
    
    [[DataManager Instance] getCountryList:^(NSArray *array) {
        
        self.arrCountryList = (NSArray<CountryModel>*)array;
        
        
        openPopOutView();
        
    }];
    
    
}


-(NSArray*)getPrefixList:(NSArray*)countryList
{
    
    NSMutableArray* array = [NSMutableArray new];
    
    for (int i = 0; i<countryList.count; i++) {
        
        CountryModel* model = countryList[i];
        
        NSString* combinedString = [NSString stringWithFormat:@"%@ (%@)",model.c_prefix,model.c_name];
        
        [array addObject:combinedString];
    }
    
    return array;
}

+(instancetype)instantiate
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"GuestMode" bundle:nil];
    GuestModeViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"sb_guestmode"];
    
    return vc;
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveNotification:)
                                                 name:NOTIF_CENTER_LOGIN
                                               object:nil];

}

-(void)viewWillDisappear:(BOOL)animated
{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIF_CENTER_LOGIN object:nil];
    
}

#pragma mark - Add Observer

- (void) receiveNotification:(NSNotification *) notification
{
    // [notification name] should always be @"TestNotification"
    // unless you use this method for observation of other notifications
    // as well.
    
    if ([[notification name] isEqualToString:NOTIF_CENTER_LOGIN])
        
        
        [self.navigationController popViewControllerAnimated:YES];
        NSLog (@"Successfully received the login notification");
}
@end

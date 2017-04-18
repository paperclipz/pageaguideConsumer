//
//  EBActionSheetViewController.m
//  paguide
//
//  Created by Evan Beh on 28/02/2017.
//  Copyright © 2017 Evan Beh. All rights reserved.
//

#import "EBActionSheetViewController.h"
#import "EBActionSheetTableViewCell.h"
#import "TTTAttributedLabel.h"
#import "EBActionSheetHeaderView.h"

@interface EBActionSheetViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *ibtableView;
@property (strong, nonatomic) NSArray* arrDefaultList;

@end

@implementation EBActionSheetViewController
- (IBAction)btnCloseClicked:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)setDefaultData:(NSArray*)arrDefault
{
    self.arrDefaultList = arrDefault;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    
       self.ibtableView.delegate = self;
    self.ibtableView.dataSource = self;
    
    [self.ibtableView registerNib:[UINib nibWithNibName:@"EBActionSheetTableViewCell" bundle:nil] forCellReuseIdentifier:@"customcell"];
    
   // self.lblTitle.text = self.title;
    
    [Utils setRoundBorder:self.ibtableView color:[UIColor clearColor] borderRadius:5];
//    int numberOfCellToShow = 5;
//    float height = self.ibtableView.frame.size.height - 50.0f*numberOfCellToShow;
//    [self.ibtableView setContentInset:UIEdgeInsetsMake(height,0,0,0)];

    // Do any additional setup after loading the view from its nib.
}

-(void)setInitial:(NSIndexPath*)indexPath
{
    
    if (indexPath) {
        [self.ibtableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
  
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    if ([Utils isArrayNull:self.arrDefaultList]) {
        
        return 1;
    }
    else{
        return 2;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44.0f;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView* view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"headerView"];
    
    EBActionSheetHeaderView* headerView = (EBActionSheetHeaderView*)view;
    
    if (!view) {
        
        headerView = [EBActionSheetHeaderView initializeCustomView];
        
    }
    
    
    
    if ([Utils isArrayNull:self.arrDefaultList]) {
    
        headerView.lblTitle.text = self.title;
        headerView.btnClose.hidden = NO;

    }
    else{
        if (section == 0) {
            headerView.lblTitle.text = @"Custom";
            headerView.btnClose.hidden = NO;

        }
        else{
            headerView.lblTitle.text = self.title;
            headerView.btnClose.hidden = YES;

        }
    }
    
    headerView.didCloseBlock = ^(void)
    {
        [self dismissViewControllerAnimated:YES completion:nil];
        
    };

  
    return headerView;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if ([Utils isArrayNull:self.arrDefaultList]) {
    
        return self.arrItemList.count;

    }
    else{
    
        if (section == 0) {
            
            return 1;
        }
        else{
            return self.arrItemList.count;

        }
    }

}

-(void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([indexPath row] == ((NSIndexPath*)[[tableView indexPathsForVisibleRows] lastObject]).row){
       
        dispatch_async(dispatch_get_main_queue(), ^{
            
            //This code will run in the main thread:
            CGRect frame = self.ibtableView.frame;
            
            frame.size.height = self.ibtableView.contentSize.height;
            
            float height = 0;
            
            float oriheight = frame.size.height;
            float viewheight = self.view.frame.size.height - 100;
            if (oriheight> viewheight) {
                height = viewheight;
            }
            else{
                height = frame.size.height;

            }
      
            
        self.ibtableView.frame = CGRectMake(self.ibtableView.frame.origin.x, (self.view.frame.size.height - height)/2, self.ibtableView.frame.size.width, height);
            
        });
    }
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;

{
    EBActionSheetTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"customcell"];
    
    if ([Utils isArrayNull:self.arrDefaultList]) {
    
        NSString* title = self.arrItemList[indexPath.row];
        
        cell.lblTitle.text = title;
    }
    else{
    
        if (indexPath.section == 0) {
            
            cell.lblTitle.text = self.arrDefaultList[indexPath.row];

        }
        else{
            NSString* title = self.arrItemList[indexPath.row];
            
            cell.lblTitle.text = title;
        }
    }
   
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.didSelectAtIndexBlock) {
        self.didSelectAtIndexBlock(indexPath);
    }
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

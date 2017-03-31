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

@interface EBActionSheetViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *ibtableView;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UIButton *btnClose;

@end

@implementation EBActionSheetViewController
- (IBAction)btnCloseClicked:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self.btnClose setImage:[self.btnClose.imageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];

    self.ibtableView.delegate = self;
    self.ibtableView.dataSource = self;
    
    [self.ibtableView registerNib:[UINib nibWithNibName:@"EBActionSheetTableViewCell" bundle:nil] forCellReuseIdentifier:@"customcell"];
    
    self.lblTitle.text = self.title;
    
    [Utils setRoundBorder:self.btnClose color:[UIColor clearColor] borderRadius:self.btnClose.frame.size.height/2];
    
    [Utils setRoundBorder:self.ibtableView color:[UIColor clearColor] borderRadius:5];
//    int numberOfCellToShow = 5;
//    float height = self.ibtableView.frame.size.height - 50.0f*numberOfCellToShow;
//    [self.ibtableView setContentInset:UIEdgeInsetsMake(height,0,0,0)];

    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrItemList.count;

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
            
            [self.btnClose layoutIfNeeded];
            
        });
    }
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;

{
    EBActionSheetTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"customcell"];
    
    NSString* title = self.arrItemList[indexPath.row];
    
    cell.lblTitle.text = title;
    
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

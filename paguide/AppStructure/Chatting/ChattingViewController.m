//
//  ChattingViewController.m
//  paguide
//
//  Created by Evan Beh on 26/09/2017.
//  Copyright © 2017 Evan Beh. All rights reserved.
//

#import "ChattingViewController.h"
#import "UITextView+Placeholder.h"
#import "ChattingTableViewCell.h"

#import "ChatWrapperModel.h"

@interface ChattingViewController () <UITableViewDelegate, UITableViewDataSource, UITextViewDelegate>
{
    float viewHeight;

}
@property (weak, nonatomic) IBOutlet UILabel *lblUserName;
@property (weak, nonatomic) IBOutlet UITableView *ibTableView;
@property (weak, nonatomic) IBOutlet UITextView *ibTxtView;
@property (weak, nonatomic) IBOutlet UIButton *btnSend;
@property (weak, nonatomic) IBOutlet UIImageView *ibImgSend;
@property (nonatomic)NSMutableArray* arrMessage;
@property (nonatomic)MerchantProfileModel* merchantProfile;
@property (nonatomic)NSString* requestID;

@end

@implementation ChattingViewController

-(void)setupPreData:(MerchantProfileModel*)model requestID:(NSString*)requestId
{
    self.requestID = requestId;
    
    self.merchantProfile = model;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSelfView];
    
    self.arrMessage = [NSMutableArray new];
    
    self.lblUserName.text = self.merchantProfile.name;
    
    [self requestServerForChatListing:self.requestID];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initSelfView
{

    self.title = @"Chat";
    
    self.edgesForExtendedLayout = UIRectEdgeNone;

    [self registerForKeyboardNotifications];
    
    
    self.ibTableView.delegate = self;
    self.ibTableView.dataSource = self;
    self.ibTxtView.delegate = self;
    
    
    UINib *nib = [UINib nibWithNibName:@"ChattingReceiverTblVCell" bundle:nil];
    
    [[self ibTableView] registerNib:nib forCellReuseIdentifier:@"cell_receiver"];
    
    nib = [UINib nibWithNibName:@"ChattingSenderTblVCell" bundle:nil];
    
    [[self ibTableView] registerNib:nib forCellReuseIdentifier:@"cell_sender"];
    
    self.ibTableView.estimatedRowHeight = 140.0f;
    
    self.ibTableView.rowHeight = UITableViewAutomaticDimension;
        
    [self.btnSend setTitle:@"" forState:UIControlStateNormal];
    
    self.ibImgSend.tintColor = APP_MAIN_COLOR;
    
    self.ibTxtView.placeholder = [@"Send A Message" uppercaseString];
    
//    [Utils setRoundBorder:self.ibImgProfile color:[UIColor clearColor] borderRadius:self.ibImgProfile .frame.size.width/2];
    
}

-(void)dismissKeyboard:(UITapGestureRecognizer*)sender
{
    [self.view endEditing:YES];
    
    [self resignFirstResponder];
}

- (void)registerForKeyboardNotifications
{
    UITapGestureRecognizer* tabGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissKeyboard:)];
    
    [self.view addGestureRecognizer:tabGesture];
    
    viewHeight = self.view.frame.size.height;
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.arrMessage.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    ChatModel* cModel = self.arrMessage[indexPath.row];
    
    if ([cModel.user_type isEqualToString:@"consumer"]) {
        ChattingTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cell_sender"];
        
        cell.lblUserName.text = cModel.created_at.date;
        
        cell.lblMessage.text = cModel.comment;
        
        [cell setCellType:YES];
        
        return cell;
    }
   
    else{
        ChattingTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cell_receiver"];
        
        cell.lblUserName.text = cModel.created_at.date;

        cell.lblMessage.text = cModel.comment;
        
        [cell setCellType:NO];
        
        return cell;
    }

}

#pragma mark - Add Navigation Items
- (IBAction)btnSendClicked:(id)sender {
    
    
    if (![Utils isStringNull:self.ibTxtView.text]) {
        
        [self sendMessage:self.ibTxtView.text];
        
    }
}

-(void)sendMessage:(NSString*)message
{
    
    [self.arrMessage addObject:message];
    
    self.ibTxtView.text = @"";
    
    [self.view endEditing:YES];
    
    [self resignFirstResponder];
    
    [self.ibTableView reloadData];
    
}

#pragma mark - Request Server

//    https://devpage.pageadvisor.com/requests/:requestId/comments?services_token=%5BSERVICE_TOKEN%5D&token=%5BUSER_TOKEN%5D

-(void)requestServerForChatListing:(NSString*)requestID
{
    
    NSString* token = [Utils getToken];
    NSDictionary* dict = @{@"token" : token,
                           };
    
    NSString* appendString = [NSString stringWithFormat:@"%@/comments",@"1"];
    
    [ConnectionManager requestServerWith:AFNETWORK_GET serverRequestType:ServerRequestTypePostRequestComment parameter:dict appendString:appendString success:^(id object) {
        
        NSError* error;
        ChatWrapperModel* wrapperModel = [[ChatWrapperModel alloc]initWithDictionary:object error:&error];
        
        [self.arrMessage addObjectsFromArray:wrapperModel.arrChatList];
        
        [self.ibTableView reloadData];
        
        
    } failure:^(id object) {
        
        
        [MessageManager showMessage:object Type:TSMessageNotificationTypeError inViewController:self];
    }];
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

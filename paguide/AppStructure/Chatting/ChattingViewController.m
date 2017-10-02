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
#define LIMIT 20

@interface ChattingViewController () <UITableViewDelegate, UITableViewDataSource, UITextViewDelegate>
{
    float viewHeight;
    BOOL isMiddleOfLoading;
    int currentPage;


}
@property (weak, nonatomic) IBOutlet UILabel *lblUserName;
@property (weak, nonatomic) IBOutlet UITableView *ibTableView;
@property (weak, nonatomic) IBOutlet UITextView *ibTxtView;
@property (weak, nonatomic) IBOutlet UIButton *btnSend;
@property (weak, nonatomic) IBOutlet UIImageView *ibImgSend;
@property (nonatomic)NSMutableArray* arrMessage;
@property (nonatomic)MerchantProfileModel* merchantProfile;
@property (nonatomic)NSString* requestID;
@property (nonatomic,strong)ChatWrapperModel* chatWrapperModel;
@property (strong, nonatomic) UIActivityIndicatorView* acivityIndicator;

@end

@implementation ChattingViewController

-(void)setupPreData:(MerchantProfileModel*)model requestID:(NSString*)requestId
{
    self.requestID = requestId;
    
    self.merchantProfile = model;
    
    currentPage = 1;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSelfView];
    
    self.arrMessage = [NSMutableArray new];
    
    self.lblUserName.text = self.merchantProfile.name;
    
    [self requestServerToGetForChatListing:self.requestID];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initSelfView
{

    [self addActivityIndicator];
    
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

-(void)addActivityIndicator
{
    
    self.navigationItem.rightBarButtonItem = nil;
    
    self.acivityIndicator = [[UIActivityIndicatorView alloc]init];
    
    UIBarButtonItem* buttonBar = [[UIBarButtonItem alloc]initWithCustomView:self.acivityIndicator];
    
    self.acivityIndicator.hidesWhenStopped = YES;
    
    self.navigationItem.rightBarButtonItems  = @[buttonBar];
    
    self.acivityIndicator.color = APP_MAIN_COLOR;
    
    
    
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
        
        cell.lblUserName.text = cModel.created_at;
        
        cell.lblMessage.text = cModel.comment;
        
        [cell setCellType:YES];
        
        return cell;
    }
   
    else{
        ChattingTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cell_receiver"];
        
        cell.lblUserName.text = cModel.created_at;

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
    
    //[self.arrMessage addObject:message];
    
    self.ibTxtView.text = @"";
    
    [self.view endEditing:YES];
    
    [self resignFirstResponder];
    
    [self.ibTableView reloadData];
    
    [self requestServerToPostForChatListing:self.requestID Message:message];

}

#pragma mark - Request Server

//    https://devpage.pageadvisor.com/requests/:requestId/comments?services_token=%5BSERVICE_TOKEN%5D&token=%5BUSER_TOKEN%5D

-(void)requestServerToGetForChatListing:(NSString*)requestID
{
    
    if (isMiddleOfLoading) {
        return;
    }
    
    if (currentPage > 1) {
        
        if ([Utils isStringNull:self.chatWrapperModel.next_page_url]) {
            
            [self.acivityIndicator stopAnimating];

            return;
        }
    }
    
    isMiddleOfLoading = YES;
    
    
    NSString* token = [Utils getToken];
    NSDictionary* dict = @{@"token" : token,
                           @"page" : @(currentPage),
                           @"limit" : @(LIMIT)
                           };
    
    NSString* appendString = [NSString stringWithFormat:@"%@/comments",requestID];
    
    [ConnectionManager requestServerWith:AFNETWORK_GET serverRequestType:ServerRequestTypePostRequestComment parameter:dict appendString:appendString success:^(id object) {
        
        [self processChatData:object];
        
        isMiddleOfLoading = NO;
        
        [self.acivityIndicator stopAnimating];


    } failure:^(id object) {
        
        isMiddleOfLoading = NO;

        [self.acivityIndicator stopAnimating];

        [MessageManager showMessage:object Type:TSMessageNotificationTypeError inViewController:self];
    }];
}

-(void)requestServerToPostForChatListing:(NSString*)requestID Message:(NSString*)message
{
    [self.acivityIndicator stopAnimating];
    
    
    NSString* token = [Utils getToken];
    NSDictionary* dict = @{@"token" : token,
                           @"comment": message
                           };
    
    NSString* appendString = [NSString stringWithFormat:@"%@/comments",requestID];

    
    [ConnectionManager requestServerWith:AFNETWORK_POST serverRequestType:ServerRequestTypePostRequestComment parameter:dict appendString:appendString success:^(id object) {
        
        currentPage = 1;
        
        [self requestServerToGetForChatListing:self.requestID];
        
        isMiddleOfLoading = NO;
        
    } failure:^(id object) {
        
        isMiddleOfLoading = NO;
        
        [MessageManager showMessage:object Type:TSMessageNotificationTypeError inViewController:self];
    }];

}


-(void)processChatData:(id)object
{
    
    @try {
        
        //for first time load
        if (currentPage == 1) {
            
            [self resetData];
            
            NSError* error;
            
            self.chatWrapperModel = [[ChatWrapperModel alloc]initWithDictionary:object error:&error];
            
            NSArray* tempArray = self.chatWrapperModel.arrChatList;
            
            NSMutableArray* reverseArray = [[[tempArray reverseObjectEnumerator] allObjects] mutableCopy];
            
            [self.arrMessage addObjectsFromArray:reverseArray];
            
            [self.ibTableView reloadData];
            
            
            if (![Utils isArrayNull:self.arrMessage] && currentPage <=1) {
                [self.ibTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.arrMessage.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
                
            }
        }
        //for continuios load
        else{
            
            
            NSError* error;
            
            self.chatWrapperModel = [[ChatWrapperModel alloc]initWithDictionary:object error:&error];
            
            
            NSArray* tempArray = self.chatWrapperModel.arrChatList;
            
            NSMutableArray* reverseArray = [[[tempArray reverseObjectEnumerator] allObjects] mutableCopy];
            
            
            NSMutableArray* arrTempMessage = self.arrMessage;
            
            NSMutableArray* arrTempReverseArray = [reverseArray mutableCopy];
            
            [arrTempReverseArray addObjectsFromArray:arrTempMessage];
            
            self.arrMessage = (NSMutableArray<ChatModel>*)arrTempReverseArray;
            
            [self.ibTableView reloadData];
            
            NSIndexPath* scrollToIndexPath = [NSIndexPath indexPathForRow:reverseArray.count inSection:0];
            
            [self.ibTableView scrollToRowAtIndexPath: scrollToIndexPath atScrollPosition: UITableViewScrollPositionTop animated: NO];
        }
        
        currentPage+=1;
        
    } @catch (NSException *exception) {
        
    }
    
    
}

#pragma mark - Scroll View

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    float scrollOffset = scrollView.contentOffset.y;
    
    if (scrollOffset == 0)
        
    {
        if (![Utils isArrayNull:self.arrMessage]) {
            
            [self.acivityIndicator startAnimating];
            
            [self requestServerToGetForChatListing:self.requestID];
            
        }
    }
}

-(void)resetData
{
    [self.arrMessage removeAllObjects];
    
    self.arrMessage = nil;
    
    self.arrMessage = [NSMutableArray new];

    [self.ibTableView reloadData];
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

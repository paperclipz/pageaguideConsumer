//
//  UnratedViewController.m
//  paguide
//
//  Created by Evan Beh on 30/05/2017.
//  Copyright © 2017 Evan Beh. All rights reserved.
//

#import "UnratedViewController.h"
#import "UnratedCollectionViewCell.h"
#import "AppointmentModel.h"
#import "MerchantProfileModel.h"
#import "iCarousel.h"

@interface UnratedViewController () <UICollectionViewDelegate,UICollectionViewDataSource,iCarouselDataSource, iCarouselDelegate, UICollectionViewDelegateFlowLayout>


@property (weak, nonatomic) IBOutlet iCarousel *ibIcarousel;
@property (weak, nonatomic) IBOutlet UICollectionView *ibCollectionView;
@property (nonatomic)NSMutableArray* arrRatings;

@property (nonatomic, assign) CGFloat previousOffset;
@property (nonatomic, assign) NSInteger currentPage;

@end

@implementation UnratedViewController

- (IBAction)btnCloseClicked:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)setupCarousel
{
    self.ibIcarousel.delegate = self;
    self.ibIcarousel.dataSource = self;
    self.ibIcarousel.pagingEnabled = YES;
    self.ibIcarousel.backgroundColor = [UIColor clearColor];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.ibCollectionView registerClass:[UnratedCollectionViewCell class] forCellWithReuseIdentifier:@"cell1"];
    
    [self setupCarousel];

    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    return self.arrayAppointments.count;
    
}

- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewLayout *)collectionViewLayout
minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    // Adjust cell size for orientation
    
    CGRect frame = [Utils getWindowFrame];
    
    return CGSizeMake(frame.size.width, 320.0f);
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UnratedCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell1" forIndexPath:indexPath];
    
    [self setupCell:cell Index:indexPath.row];
    
    return cell;
}


#pragma mark - Icarousel
- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    return self.arrayAppointments.count;
    
}
- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(nullable UIView *)view
{
    
    CGRect frame = [Utils getWindowFrame];

    UnratedCollectionViewCell* cell = [[UnratedCollectionViewCell alloc]initWithFrame:CGRectMake(0, 0, frame.size.width*0.8, 320.0f)];
    
    [self setupCell:cell Index:index];

    return cell;
}


-(void)setupCell:(UnratedCollectionViewCell*)cell Index:(NSInteger)index
{
    
    AppointmentModel* aModel = self.arrayAppointments[index];
    
    MerchantProfileModel* mModel = aModel.merchant_info_model;
    
    cell.lblTitle1.text = aModel.title;
    
    cell.lblTitle2.text = mModel.name;
    
    [cell setRatingInView:mModel.rating];
    
    cell.txtRating.text = mModel.review;
    
    cell.didRateClicked = ^(int rating)
    {
        mModel.rating = rating;
        
        aModel.merchant_info_model = mModel;
        
        [self.arrayAppointments replaceObjectAtIndex:index withObject:aModel];
        
    };
    
    
    cell.didUpdateStringBlock = ^(NSString* string)
    {
        mModel.review = string;
        
        aModel.merchant_info_model = mModel;
        
        [self.arrayAppointments replaceObjectAtIndex:index withObject:aModel];
        
    };
    
    __weak typeof(self) weakSelf = self;
    
    __weak typeof(cell) weakCell = cell;
    
    cell.didFinishRateBlock = ^{
        
        
        if ([Utils isStringNull:weakCell.txtRating.text]) {
            [MessageManager showMessage:@"Please Input A Review" Type:TSMessageNotificationTypeError inViewController:weakSelf];
        }
        else{
            
            
            [weakSelf requestServerForAppointmentRating:weakCell.rating Review:weakCell.txtRating.text AppointmentID:aModel.appointment_id Type:aModel.type Completion:^{
                
                
                [self.arrayAppointments removeObjectAtIndex:index];
                [self.ibCollectionView reloadData];
                [self.ibIcarousel reloadData];
                
                if ([Utils isArrayNull:self.arrayAppointments]) {
                    
                    
                    [self dismissViewControllerAnimated:YES completion:nil];
                }
                
            }];
            
        }
        
        
    };
}
-(void)requestServerForAppointmentRating:(int)rating Review:(NSString*)review AppointmentID:(NSString*)apptID Type:(NSString*)type
                             Completion :(VoidBlock)completion
{
    
    NSString* token = [Utils getToken];
    
    NSDictionary* dict = @{@"token" : IsNullConverstion(token),
                           @"appointment_id" : IsNullConverstion(apptID),
                           @"type" : type,
                           @"rate" : @(rating),
                           @"reviews" : IsNullConverstion(review),
                           };
    
    [LoadingManager show];
    
    [ConnectionManager requestServerWith:AFNETWORK_POST serverRequestType:ServerRequestTypePostAppointmentComplete parameter:dict appendString:nil success:^(id object) {
        
        [LoadingManager hide];

        if (completion) {
            completion();
        }
    } failure:^(id object) {
        [LoadingManager hide];

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

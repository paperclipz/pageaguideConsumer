//
//  GalleryTableViewCell.m
//  paguide
//
//  Created by Evan Beh on 03/03/2017.
//  Copyright © 2017 Evan Beh. All rights reserved.
//

#import "GalleryTableViewCell.h"
#import "GalleryCollectionViewCell.h"

@interface GalleryTableViewCell() <UICollectionViewDelegate, UICollectionViewDataSource>

@end
@implementation GalleryTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self.ibCollectionView registerClass:[GalleryCollectionViewCell class] forCellWithReuseIdentifier:@"gallery_collection_cell"];
    
    self.ibCollectionView.delegate  = self;
    
    self.ibCollectionView.dataSource = self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setupImageList:(NSArray*)imageList
{
    self.arrImageList = imageList;
    
    [self.ibCollectionView reloadData];
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.arrImageList.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    GalleryCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"gallery_collection_cell" forIndexPath:indexPath];
    
    
    if (!cell)
    {
        cell = [[GalleryCollectionViewCell alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
    }
    
    NSString* imageUrl = self.arrImageList[indexPath.row];
    
    [cell.ibImageView sd_setImageWithURL:[NSURL URLWithString:imageUrl]];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.didSelectAtIndexBlock) {
        self.didSelectAtIndexBlock(indexPath.row);
    }
}





@end

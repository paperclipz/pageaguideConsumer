//
//  GalleryTableViewCell.h
//  paguide
//
//  Created by Evan Beh on 03/03/2017.
//  Copyright © 2017 Evan Beh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GalleryTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UICollectionView *ibCollectionView;
@property(strong, nonatomic)NSArray* arrImageList;

-(void)setupImageList:(NSArray*)imageList;

@property(nonatomic,copy)IntBlock didSelectAtIndexBlock;

@end

//
//  CommonCollectionViewCell.m
//  SeetiesIOS
//
//  Created by Evan Beh on 10/26/15.
//  Copyright © 2015 Stylar Network. All rights reserved.
//

#import "CommonCollectionViewCell.h"

@interface CommonCollectionViewCell()
@property(nonatomic,weak)IBOutlet UIView* borderView;
@property(nonatomic,weak)IBOutlet UIView* borderlessView;

@end
@implementation CommonCollectionViewCell

-(void)setCustomIndexPath:(NSIndexPath*)indexPath
{
}

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        NSArray *objects = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil];
        
        for (id currentObject in objects ){
            if ([currentObject isKindOfClass:[self class]]) {
                
                [currentObject initSelfView];
                
                UIView* view = currentObject;
                
                view.frame = frame;
                
                return currentObject;
            }
        }
        return nil;
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame name:(NSString*)name
{
    self = [super initWithFrame:frame];
    if (self) {
        NSArray *objects = [[NSBundle mainBundle] loadNibNamed:name owner:nil options:nil];
        
        for (id currentObject in objects ){
            if ([currentObject isKindOfClass:[self class]]) {
                [currentObject initSelfView];
                
                UIView* view = currentObject;
                
                view.frame = frame;

                return currentObject;
            }
        }
        return nil;
    }
    
    return self;
}


-(void)initSelfView
{
   
}

@end

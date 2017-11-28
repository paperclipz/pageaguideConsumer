//
//  PackageDetailsTableViewCell.m
//  paguide
//
//  Created by Evan Beh on 07/03/2017.
//  Copyright © 2017 Evan Beh. All rights reserved.
//

#import "PackageDetailsTableViewCell.h"


@interface PackageDetailsTableViewCell()

@property(nonatomic,assign)MKCoordinateRegion region;
@property(nonatomic,strong)MKPointAnnotation* annotation;

@end

@implementation PackageDetailsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.annotation = [[MKPointAnnotation alloc] init];
    [self.annotation setCoordinate:self.region.center];
    [self.annotation setTitle:@""]; //You can set the subtitle too
    [self.ibMapView addAnnotation:self.annotation];
    
    MKCoordinateRegion zoomIn = self.ibMapView.region;
    zoomIn.span.latitudeDelta *= 0.9;
    zoomIn.span.longitudeDelta *= 0.9;
    [self.ibMapView setRegion:zoomIn animated:NO];
    self.ibMapView.userInteractionEnabled = NO;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void)setLocation:(CLLocation*)location
{
    CLLocationCoordinate2D coord = location.coordinate;
    self.region = MKCoordinateRegionMakeWithDistance(coord,1000,1000);
    
    [self.ibMapView setRegion:self.region];
    
    [self.annotation setCoordinate:self.region.center];


    
}
@end

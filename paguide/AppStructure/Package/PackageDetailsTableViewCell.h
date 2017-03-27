//
//  PackageDetailsTableViewCell.h
//  paguide
//
//  Created by Evan Beh on 07/03/2017.
//  Copyright © 2017 Evan Beh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface PackageDetailsTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblDesc;
@property (weak, nonatomic) IBOutlet MKMapView *ibMapView;

-(void)setLocation:(CLLocation*)location;
//-(void)setupCoordinate:(CLLocation)
@end

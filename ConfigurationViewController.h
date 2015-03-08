//
//  ConfigurationViewController.h
//  Rendezvous
//
//  Created by Cauê Silva on 03/03/15.
//  Copyright (c) 2015 Eduardo Quadros. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface ConfigurationViewController : UIViewController <CLLocationManagerDelegate, MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (retain, nonatomic) MKMapCamera *camera;
@property (retain, nonatomic) CLBeaconRegion *beaconRegion;
@property (retain, nonatomic) CLLocationManager *locationManager;

@property NSString *userName;

@end

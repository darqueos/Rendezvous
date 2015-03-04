//
//  ConfigurationViewController.m
//  Rendezvous
//
//  Created by Cauê Silva on 03/03/15.
//  Copyright (c) 2015 Eduardo Quadros. All rights reserved.
//

#import "ConfigurationViewController.h"

@interface ConfigurationViewController ()

@end

@implementation ConfigurationViewController

- (void)viewDidLoad {
    // Shows message when the user refuses to allow app permissions.
    [super viewDidLoad];

    _locationManager = [[CLLocationManager alloc] init];
    [_locationManager requestAlwaysAuthorization];
    [_locationManager setDelegate:self];

    // Coordinates
    [_locationManager setActivityType:CLActivityTypeFitness];
    [_locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    [_locationManager setDistanceFilter:kCLHeadingFilterNone];
    [_locationManager startUpdatingLocation];

    // Orientation
    [_locationManager setHeadingFilter:kCLHeadingFilterNone];
    [_locationManager startUpdatingHeading];
    
    // Map Options
//    [_mapView setDelegate:self];
    [_mapView setZoomEnabled:NO];               // Disable Zoom
    [_mapView setScrollEnabled:NO];             // Disable scrolling.
    [_mapView setPitchEnabled:NO];              // Disable 3D view of the map.
    [_mapView setRotateEnabled:YES];            // Enable map rotation.
    [_mapView setUserInteractionEnabled:NO];    // Disable User Interaction
    [_mapView setShowsUserLocation:YES];        // Show user on map
}

-(BOOL) prefersStatusBarHidden {
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark Updating Coordinates

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    // Get user's current location
    CLLocationCoordinate2D loc  = [[locations lastObject] coordinate];
    MKCoordinateRegion region   = MKCoordinateRegionMakeWithDistance(loc, 80, 80);

    // Set the initial region on map as user current location
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [_mapView setRegion:region animated:NO];
    });

    [self updateMap:loc];
}

#pragma mark Updating Orientation

- (BOOL)locationManagerShouldDisplayHeadingCalibration:(CLLocationManager *)manager {
    return YES;
}

- (void)updateMap:(CLLocationCoordinate2D)loc {
    _camera = [MKMapCamera cameraLookingAtCenterCoordinate:loc fromEyeCoordinate:loc eyeAltitude:50];
    _camera.centerCoordinate = loc;

    _mapView.userTrackingMode = MKUserTrackingModeFollowWithHeading;
    [_mapView setCamera:_camera animated:YES];
//  [_mapView setCenterCoordinate:coordinate animated:YES];
//  [_mapView setRegion:region animated:YES];
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

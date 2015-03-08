//
//  ConfigurationViewController.m
//  Rendezvous
//
//  Created by Cauê Silva on 03/03/15.
//  Copyright (c) 2015 Eduardo Quadros. All rights reserved.
//

#import "ConfigurationViewController.h"
#import <Parse/Parse.h>
#import <ParseFacebookUtils/PFFacebookUtils.h>
#import "FriendAnnotation.h"
#import "SVPulsingAnnotationView.h"

@interface ConfigurationViewController ()

@property PFObject *parseFriendUser;
@property NSString *currentUserID;

@property FriendAnnotation *friendPin;
@property PFGeoPoint *friendLoc;

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
    [_mapView setDelegate:self];
    [_mapView setZoomEnabled:NO];               // Disable Zoom
    [_mapView setScrollEnabled:NO];             // Disable scrolling.
    [_mapView setPitchEnabled:NO];              // Disable 3D view of the map.
    [_mapView setRotateEnabled:NO];            // Enable map rotation.
    [_mapView setUserInteractionEnabled:YES];    // Disable User Interaction
    [_mapView setShowsUserLocation:YES];        // Show user on map
    
    _currentUserID = [NSString stringWithFormat:@"%@", [[PFUser currentUser] objectId]];
    _friendPin = [[FriendAnnotation alloc] initWithTitle:_userName Location:CLLocationCoordinate2DMake(0, 0)];
    
    [_mapView addAnnotation:_friendPin];
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
    
    PFQuery *query2 = [PFQuery queryWithClassName:@"AppUser"];
    [query2 whereKey:@"uid" equalTo:_currentUserID];
    [query2 findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {

            if (objects.count < 1) {
                PFObject *newPFUser = [PFObject objectWithClassName:@"AppUser"];
                newPFUser[@"uid"] = [[PFUser currentUser] objectId];
                if ([_currentUserID isEqualToString:@"2hwTl1INIu"]) {
                    newPFUser[@"name"] = @"Aleph";
                } else if ([_currentUserID isEqualToString:@"oEHf9XXQGq"]) {
                    newPFUser[@"name"] = @"Eduardo";
                } else {
                    newPFUser[@"name"] = @"Caue";
                }
                newPFUser[@"location"] = [PFGeoPoint geoPointWithLatitude:loc.latitude longitude:loc.longitude];

                [newPFUser save];
            } else {
                PFObject *currentUserObject = [objects firstObject];
                PFGeoPoint *currentUserObjectLocation = currentUserObject[@"location"];
                
                if (!((currentUserObjectLocation.latitude == loc.latitude) && (currentUserObjectLocation.longitude == loc.longitude))) {
                    currentUserObject[@"location"] = [PFGeoPoint geoPointWithLatitude:loc.latitude longitude:loc.longitude];
                    [currentUserObject save];
                }

            }
            
        }
    }];
    
    
    PFQuery *query = [PFQuery queryWithClassName:@"AppUser"];
    [query whereKey:@"name" equalTo:_userName];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            
            if (objects.count > 0) {
                _parseFriendUser = objects.firstObject;
                
                _friendLoc = _parseFriendUser[@"location"];
                
            }
            
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        
        }
    }];
    
    if (!((_friendLoc.latitude == _friendPin.coordinate.latitude) && (_friendLoc.longitude == _friendPin.coordinate.longitude))) {
        [_mapView removeAnnotation:_friendPin];
        
        [_friendPin replaceThisCoordinate:CLLocationCoordinate2DMake(_friendLoc.latitude, _friendLoc.longitude)];
        
        [_mapView addAnnotation:_friendPin];
    }
    
    CLLocation *friendCLLocation = [[CLLocation alloc] initWithLatitude:_friendPin.coordinate.latitude longitude:_friendPin.coordinate.longitude];
    CLLocation *userCLLocation = [[CLLocation alloc] initWithLatitude:loc.latitude longitude:loc.longitude];
    float distance = [userCLLocation distanceFromLocation:friendCLLocation];
    CLLocationCoordinate2D centerLocation = CLLocationCoordinate2DMake((loc.latitude + friendCLLocation.coordinate.latitude)/2, (loc.longitude + friendCLLocation.coordinate.longitude)/2);
    
    
    MKCoordinateRegion region   = MKCoordinateRegionMakeWithDistance(centerLocation, distance*2, distance*2);
    [_mapView setRegion:region animated:YES];
}

#pragma mark Updating Orientation

- (BOOL)locationManagerShouldDisplayHeadingCalibration:(CLLocationManager *)manager {
    return YES;
}

- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading {
    CLLocationDirection direction;

    if (newHeading.headingAccuracy > 0) {
        direction = newHeading.trueHeading;
    } else {
        direction = newHeading.magneticHeading;
    }
}


// Set annotation view just like user current location icon, but green
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    if([annotation isKindOfClass:[FriendAnnotation class]]) {
        static NSString *identifier = @"FriendAnnotation";
        
        SVPulsingAnnotationView *pulsingView = (SVPulsingAnnotationView *)[_mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        
        if(pulsingView == nil) {
            pulsingView = [[SVPulsingAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
            pulsingView.annotationColor = [UIColor colorWithRed:0 green:0.7 blue:0 alpha:1];
        }
        
        pulsingView.canShowCallout = YES;
        return pulsingView;
    }
    
    return nil;
}

//- (void)updateMap:(CLLocation *) {}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
@end

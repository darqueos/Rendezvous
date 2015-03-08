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
    [_mapView setRotateEnabled:YES];            // Enable map rotation.
    [_mapView setUserInteractionEnabled:NO];    // Disable User Interaction
    [_mapView setShowsUserLocation:YES];        // Show user on map
    
    _currentUserID = [NSString stringWithFormat:@"%@", [[PFUser currentUser] objectId]];
    _friendPin = [[FriendAnnotation alloc] initWithTitle:@"Friend Anotation" Location:CLLocationCoordinate2DMake(0, 0)];
    
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
    MKCoordinateRegion region   = MKCoordinateRegionMakeWithDistance(loc, 80, 80);
    
    PFQuery *query2 = [PFQuery queryWithClassName:@"AppUser"];
    [query2 whereKey:@"uid" equalTo:_currentUserID];
    [query2 findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {

            if (objects.count < 1) {
                PFObject *newPFUser = [PFObject objectWithClassName:@"AppUser"];
                newPFUser[@"uid"] = [[PFUser currentUser] objectId];
                if ([_currentUserID isEqualToString:@"2hwTl1INIu"]) {
                    newPFUser[@"name"] = @"Aleph";
                } else if ([_currentUserID isEqualToString:@"USER DO EDUARDO"]) {
                    newPFUser[@"name"] = @"Eduardo";
                } else {
                    newPFUser[@"name"] = @"Caue";
                }
                newPFUser[@"location"] = [PFGeoPoint geoPointWithLatitude:loc.latitude longitude:loc.longitude];

                [newPFUser save];
            } else {
                [objects firstObject][@"location"] = [PFGeoPoint geoPointWithLatitude:loc.latitude longitude:loc.longitude];
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
    
    [_mapView removeAnnotation:_friendPin];
    
    [_friendPin replaceThisCoordinate:CLLocationCoordinate2DMake(_friendLoc.latitude, _friendLoc.longitude)];
    
    [_mapView addAnnotation:_friendPin];
    // Set the initial region on map as user current location
    [_mapView setRegion:region animated:NO];
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

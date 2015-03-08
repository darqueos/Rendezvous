//
//  FriendAnnotation.m
//  Rendezvous
//
//  Created by Aleph Retamal on 3/8/15.
//  Copyright (c) 2015 Eduardo Quadros. All rights reserved.
//

#import "FriendAnnotation.h"

@implementation FriendAnnotation

- (id)initWithTitle:(NSString *)newTitle Location:(CLLocationCoordinate2D)location {
    self = [super init];
    if (self) {
        _title = newTitle;
        _coordinate = location;
    }
    return self;
}

- (void) replaceThisCoordinate:(CLLocationCoordinate2D)c {
    _coordinate = c;
}

- (MKAnnotationView *)annotationView {
    MKAnnotationView *annotationView = [[MKAnnotationView alloc] initWithAnnotation:self reuseIdentifier:@"FriendAnnotation"];
    
    annotationView.enabled = YES;
    annotationView.canShowCallout = YES;
    
    
    annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    
    return annotationView;
}

@end

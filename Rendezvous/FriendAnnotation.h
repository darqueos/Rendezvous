//
//  FriendAnnotation.h
//  Rendezvous
//
//  Created by Aleph Retamal on 3/8/15.
//  Copyright (c) 2015 Eduardo Quadros. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface FriendAnnotation : NSObject <MKAnnotation>

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (copy, nonatomic) NSString *title;

- (id)initWithTitle:(NSString *)newTitle Location:(CLLocationCoordinate2D)location;
- (MKAnnotationView *)annotationView;
- (void) replaceThisCoordinate:(CLLocationCoordinate2D)c;

@end

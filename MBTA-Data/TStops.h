//
//  TStops.h
//  MBTA-Mantle
//
//  Created by Steve Caine on 10/26/15.
//  Copyright (c) 2015 Steve Caine. All rights reserved.
//

#import <Mantle/Mantle.h>

// ----------------------------------------------------------------------

@interface TStop : MTLModel <MTLJSONSerializing>

@property (  copy, nonatomic, readonly) NSString *ID;
@property (  copy, nonatomic, readonly) NSString *name;
@property (  copy, nonatomic, readonly) NSString *station;
@property (  copy, nonatomic, readonly) NSString *station_name;
// for stopsbyroute
@property (assign, nonatomic, readonly) NSUInteger order;
// for stopsbylocation - stop's distance in miles from requested location
@property (assign, nonatomic, readonly) CLLocationDistance distance;
// calculated
@property (assign, nonatomic, readonly) CLLocationCoordinate2D location;

// ???
//@property (  copy, nonatomic, readonly) NSNumber *sequence;

@end

// ----------------------------------------------------------------------

@interface TStopsByRoute : MTLModel <MTLJSONSerializing>

// from request
@property (  copy, nonatomic, readonly) NSString *routeID;

@property (strong, nonatomic, readonly) NSArray  *directions;

@end

// ----------------------------------------------------------------------

@interface TStopsByLocation : MTLModel <MTLJSONSerializing>

@property (assign, nonatomic, readonly) CLLocationCoordinate2D location; // from request
@property (strong, nonatomic, readonly) NSArray *stops;

@end

// ----------------------------------------------------------------------

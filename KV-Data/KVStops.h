//
//  KVStops.h
//  MBTA-Mantle
//
//  Created by Steve Caine on 10/27/15.
//  Copyright (c) 2015 Steve Caine. All rights reserved.
//

#import <Foundation/Foundation.h>

// ----------------------------------------------------------------------

@interface KVStop : NSObject

@property (  copy, nonatomic, readonly) NSString *stop_id;
@property (  copy, nonatomic, readonly) NSString *stop_name;
@property (  copy, nonatomic, readonly) NSString *parent_station;
@property (  copy, nonatomic, readonly) NSString *parent_station_name;
// for stopsbyroute
@property (assign, nonatomic, readonly) NSUInteger order;
// for stopsbylocation - stop's distance in miles from requested location
@property (assign, nonatomic, readonly) CLLocationDistance distance;
// calculated
@property (assign, nonatomic, readonly) CLLocationCoordinate2D location;

- (instancetype)initWithDictionary:(NSDictionary *)dict;

@end

// ----------------------------------------------------------------------

@interface KVStopsByRoute : NSObject

// from request
@property (  copy, nonatomic, readonly) NSString *routeID;

@property (strong, nonatomic, readonly) NSArray  *directions;

- (instancetype)initWithDictionary:(NSDictionary *)dict routeID:(NSString *)routeID;

@end

// ----------------------------------------------------------------------

@interface KVStopsByLocation : NSObject

@property (assign, nonatomic, readonly) CLLocationCoordinate2D location; // from request
@property (strong, nonatomic, readonly) NSArray *stops;

- (instancetype)initWithDictionary:(NSDictionary *)dict location:(CLLocationCoordinate2D)location;

@end

// ----------------------------------------------------------------------

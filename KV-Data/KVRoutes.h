//
//  KVRoutes.h
//  MBTA-Mantle
//
//  Created by Steve Caine on 10/29/15.
//  Copyright (c) 2015 Steve Caine. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "TDataTypes.h"

// ----------------------------------------------------------------------
@class KVStopsByRoute;
// ----------------------------------------------------------------------

@interface KVRouteDirection : NSObject

@property (assign, nonatomic, readonly) NSNumber	*direction_id;
@property (  copy, nonatomic, readonly) NSString	*direction_name;
@property (strong, nonatomic, readonly) NSArray		*stops;

- (instancetype)initWithDictionary:(NSDictionary *)dict;

@end

// ----------------------------------------------------------------------

@interface KVRoute : NSObject

@property (  copy, nonatomic, readonly) NSString	*route_id;
@property (  copy, nonatomic, readonly) NSString	*route_name;
@property (assign, nonatomic, readonly) BOOL		 route_hide;

@property (assign, nonatomic, readonly) RouteMode	 mode;
// from stopsbyroute called for this route
@property (strong, nonatomic, readonly) NSArray		*directions;

- (instancetype)initWithDictionary:(NSDictionary *)dict;

- (void)updateWithStopsByRoute:(KVStopsByRoute *)stops;

@end

// ----------------------------------------------------------------------

@interface KVRouteMode : NSObject

@property (assign, nonatomic, readonly) RouteMode	 mode;
@property (  copy, nonatomic, readonly) NSString	*mode_name;
@property (strong, nonatomic, readonly) NSArray		*routes;

- (instancetype)initWithDictionary:(NSDictionary *)dict;

@end

// ----------------------------------------------------------------------

@interface KVRoutes : NSObject

@property (strong, nonatomic, readonly) NSArray *modes;

- (KVRoute *)routeByID:(NSString *)routeID;

- (instancetype)initWithDictionary:(NSDictionary *)dict;

@end

// ----------------------------------------------------------------------

@interface KVRoutesByStop : NSObject

@property (  copy, nonatomic, readonly) NSString *stop_id;
@property (  copy, nonatomic, readonly) NSString *stop_name;
@property (strong, nonatomic, readonly) NSArray  *modes;

- (instancetype)initWithDictionary:(NSDictionary *)dict;

@end

// ----------------------------------------------------------------------

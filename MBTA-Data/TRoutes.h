//
//  TRoutes.h
//  MBTA-Mantle
//
//  Created by Steve Caine on 10/26/15.
//  Copyright (c) 2015 Steve Caine. All rights reserved.
//

#import <Mantle/Mantle.h>

#import "TDataTypes.h"

// ----------------------------------------------------------------------
@class TStopsByRoute;
// ----------------------------------------------------------------------

@interface TRouteDirection : MTLModel <MTLJSONSerializing>

@property (assign, nonatomic, readonly) NSUInteger	ID;
@property (  copy, nonatomic, readonly) NSString	*name;
@property (strong, nonatomic, readonly) NSArray		*stops;

@end

// ----------------------------------------------------------------------

@interface TRoute : MTLModel <MTLJSONSerializing>

@property (  copy, nonatomic, readonly) NSString	*ID;
@property (  copy, nonatomic, readonly) NSString	*name;
@property (assign, nonatomic, readonly) BOOL		 noUI;
@property (assign, nonatomic, readonly) RouteMode	 mode;
// from stopsbyroute called for this route
@property (strong, nonatomic, readonly) NSArray		*directions;

- (void)updateWithStopsByRoute:(TStopsByRoute *)stops;

@end

// ----------------------------------------------------------------------

@interface TRouteMode : MTLModel <MTLJSONSerializing>

@property (assign, nonatomic, readonly) NSUInteger	 type;
@property (  copy, nonatomic, readonly) NSString	*name;
@property (strong, nonatomic, readonly) NSArray		*routes;

@end

// ----------------------------------------------------------------------

@interface TRoutes : MTLModel <MTLJSONSerializing>

@property (strong, nonatomic, readonly) NSArray *modes;

- (TRoute *)routeByID:(NSString *)routeID;

@end

// ----------------------------------------------------------------------

@interface TRoutesByStop : MTLModel <MTLJSONSerializing>

@property (  copy, nonatomic, readonly) NSString *stopID;
@property (  copy, nonatomic, readonly) NSString *stopName;
@property (strong, nonatomic, readonly) NSArray  *modes;

@end

// ----------------------------------------------------------------------

//
//  TRoutes.h
//  MBTA-Mantle
//
//  Created by Steve Caine on 10/26/15.
//  Copyright (c) 2015 Steve Caine. All rights reserved.
//

#import <Mantle/Mantle.h>

// ----------------------------------------------------------------------

typedef enum : NSUInteger {
	mode_unknown,
	mode_Subway, // there are two Subway modes: Green Line and everything else
	mode_Rail,	 // so this enum is part of our logic to combine them
	mode_Bus,
	mode_Boat
} RouteMode;

// ----------------------------------------------------------------------

@interface TRouteDirection : MTLModel <MTLJSONSerializing>

@property (  copy, nonatomic) NSNumber *ID;
@property (  copy, nonatomic) NSString *name;
@property (strong, nonatomic) NSArray  *stops;

@end

// ----------------------------------------------------------------------

@interface TRoute : MTLModel <MTLJSONSerializing>

@property (  copy, nonatomic) NSString	*ID;
@property (  copy, nonatomic) NSString	*name;
@property (  copy, nonatomic) NSString	*noUI; // BOOL
@property (assign, nonatomic) RouteMode	 mode;
@property (strong, nonatomic) NSArray   *directions;

@end

// ----------------------------------------------------------------------

@interface TRouteMode : MTLModel <MTLJSONSerializing>

@property (  copy, nonatomic) NSNumber *type;
@property (  copy, nonatomic) NSString *name;
@property (strong, nonatomic) NSArray  *routes;

@end

// ----------------------------------------------------------------------

@interface TRoutes : MTLModel <MTLJSONSerializing>

@property (strong, nonatomic) NSArray *modes;
// CALC
- (TRoute *)routeByID:(NSString *)routeID;

@end

// ----------------------------------------------------------------------

@interface TRoutesByStop : MTLModel <MTLJSONSerializing>

@property (  copy, nonatomic) NSString *stopID;
@property (  copy, nonatomic) NSString *stopName;
@property (strong, nonatomic) NSArray  *modes;

@end

// ----------------------------------------------------------------------

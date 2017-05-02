//
//  TRoutes.m
//  MBTA-Mantle
//
//  Created by Steve Caine on 10/26/15.
//  Copyright (c) 2015 Steve Caine. All rights reserved.
//

#import "TRoutes.h"

#import "TStops.h"

#import "TDataTypes.h"

#import "Debug_iOS.h"

// ----------------------------------------------------------------------

@interface TRoutes ()
// CALC
@property (strong, nonatomic) NSMutableArray *all_routes;
@property (strong, nonatomic) NSMutableDictionary *routes_by_mode_name;
@end

// ----------------------------------------------------------------------

@interface TRouteMode ()
@end

// ----------------------------------------------------------------------

@interface TRoute ()
@property (assign, nonatomic, readwrite) RouteMode	mode;
@property (  copy, nonatomic, readonly)  NSString	*route_hide;
@property (strong, nonatomic, readwrite) NSArray	*directions;
@end

// ----------------------------------------------------------------------
#pragma mark -
// ----------------------------------------------------------------------

@implementation TRouteDirection

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
	return @{
			 @"ID"		: @"direction_id",
			 @"name"	: @"direction_name",
			 @"stops"	: @"stop",
			 };
}

+ (NSValueTransformer *)IDJSONTransformer {
	return [MTLValueTransformer transformerUsingForwardBlock:^id(NSString *value, BOOL *success, NSError *__autoreleasing *error) {
		return [NSNumber numberWithInteger:value.integerValue];
	}];
}

+ (NSValueTransformer *)stopsJSONTransformer {
	return [MTLJSONAdapter arrayTransformerWithModelClass:TStop.class];
}

- (NSString *)description {
	NSMutableString *result = [NSMutableString stringWithFormat:@"<%@ %p>", NSStringFromClass(self.class), self];
	[result appendFormat:@"\n\tid = %i, name = '%@'", (int)self.ID, self.name];
	if (self.stops.count) {
		int index = 0;
		for (TStop *stop in self.stops) {
			NSString *stop_order = [NSString stringWithFormat:@"%i", (int)stop.order];
			[result appendFormat:@"\n\t%2i: %@: stop %@ (%@) is at %f, %f (lat/lon)", index++, stop_order, stop.ID, stop.name, stop.location.latitude, stop.location.longitude];
		}
	}
	return result;
}

@end

// ----------------------------------------------------------------------
#pragma mark -
// ----------------------------------------------------------------------

@implementation TRoute

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
	return @{
			 @"ID"			: @"route_id",
			 @"name"		: @"route_name",
			 @"route_hide"	: @"route_hide",
			 // directions?
			 };
}

- (BOOL)noUI {
	return (self.route_hide.length > 0);
}

- (void)updateWithStopsByRoute:(TStopsByRoute *)stops {
	self.directions = stops.directions;
}

- (NSString *)description {
	NSMutableString *result = [NSMutableString stringWithFormat:@"<%@ %p>", NSStringFromClass(self.class), self];
	
	BOOL numericID = (self.ID.integerValue != 0);
	NSString *strID = (numericID ? [NSString stringWithFormat:@"#%@", self.ID] : [NSString stringWithFormat:@"'%@'",self.ID]);
	
	[result appendFormat:@"\n\t\t id = %@, name = '%@'", strID, self.name];
	if (self.directions.count) {
		int index = 0;
		for (TRouteDirection *direction in self.directions) {
			[result appendFormat:@"\n\t%2i: direction '%@' has %lu stops", index++, direction.name, direction.stops.count];
		}
	}
	return result;
}

@end

// ----------------------------------------------------------------------
#pragma mark -
// ----------------------------------------------------------------------

@implementation TRouteMode

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
	return @{
			 @"type"	: @"route_type",
			 @"name"	: @"mode_name",
			 @"routes"	: @"route"
			 };
}

+ (NSValueTransformer *)typeJSONTransformer {
	return [MTLValueTransformer transformerUsingForwardBlock:^id(NSString *value, BOOL *success, NSError *__autoreleasing *error) {
		return [NSNumber numberWithInteger:value.integerValue];
	}];
}

+ (NSValueTransformer *)routesJSONTransformer {
	return [MTLJSONAdapter arrayTransformerWithModelClass:TRoute.class];
}

- (NSString *)description {
	NSMutableString *result = [NSMutableString stringWithFormat:@"<%@ %p>", NSStringFromClass(self.class), self];
	[result appendFormat:@"\n\ttype = %i, name = '%@'", (int)self.type, self.name];
	if (self.routes.count) {
		int index = 0;
		for (TRoute *route in self.routes) {
			
			BOOL numericID = (route.ID.integerValue != 0);
			NSString *strID = (numericID ? [NSString stringWithFormat:@"#%@", route.ID] : [NSString stringWithFormat:@"'%@'",route.ID]);
			
			[result appendFormat:@"\n\t%2i: route %@ (%@)", index++, strID, route.name];
		}
	}
	return result;
}

@end

// ----------------------------------------------------------------------
#pragma mark -
// ----------------------------------------------------------------------

@implementation TRoutes

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
	return @{
			 @"modes" : @"mode"
			 };
}

+ (NSValueTransformer *)modesJSONTransformer {
	return [MTLJSONAdapter arrayTransformerWithModelClass:TRouteMode.class];
}

// post-process our object to cross-reference its contents
- (BOOL)validate:(NSError **)error {
	
	self.all_routes = @[].mutableCopy;
	self.routes_by_mode_name = @{}.mutableCopy;
	
	for (TRouteMode *mode in self.modes) {
		RouteMode route_mode = [TRouteModes findModeInName:mode.name];
		for (TRoute * route in mode.routes)
			route.mode = route_mode;
		[self.all_routes addObjectsFromArray:mode.routes];
		// in the case of Subway, this combines routes from both subway modes (Green Line and everything else)
		NSMutableArray *mode_routes = [self.routes_by_mode_name objectForKey:mode.name];
		if (mode_routes == nil) {
			mode_routes = [NSMutableArray arrayWithArray:mode.routes];
			[self.routes_by_mode_name setObject:mode_routes forKey:mode.name];
		}
		[mode_routes addObjectsFromArray:mode.routes];
	}

    return YES;
}

- (TRoute *)routeByID:(NSString *)routeID {
	TRoute *result = nil;
	for (TRouteMode *mode in self.modes) {
		for (TRoute *route in mode.routes) {
			if ([route.ID isEqualToString:routeID]) {
				result = route;
				break;
			}
			if (result)
				break;
		}
	}
	return result;
}

- (NSString *)description {
	NSMutableString *result = [NSMutableString stringWithFormat:@"<%@ %p>", NSStringFromClass(self.class), self];
	if (self.modes.count) {
		int index = 0;
		for (TRouteMode *mode in self.modes) {
			[result appendFormat:@"\n%2i: %@", index++, mode];
		}
	}
	return result;
}

@end

// ----------------------------------------------------------------------
#pragma mark -
// ----------------------------------------------------------------------

@implementation TRoutesByStop

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
	return @{
			 @"stopID"		: @"stop_id",
			 @"stopName"	: @"stop_name",
			 @"modes"		: @"mode",
			 };
}

+ (NSValueTransformer *)modesJSONTransformer {
	return [MTLJSONAdapter arrayTransformerWithModelClass:TRouteMode.class];
}

- (NSString *)description {
	NSMutableString *result = [NSMutableString stringWithFormat:@"<%@ %p>", NSStringFromClass(self.class), self];
	[result appendFormat:@"\n\tstop = '%@', name = '%@'", self.stopID, self.stopName];
	if (self.modes.count) {
		int index = 0;
		for (TRouteMode *mode in self.modes) {
			[result appendFormat:@"\n%2i: %@", index++, mode];
		}
	}
	return result;
}

@end

// ----------------------------------------------------------------------

//
//  KVRoutes.m
//  MBTA-Mantle
//
//  Created by Steve Caine on 10/29/15.
//  Copyright (c) 2015 Steve Caine. All rights reserved.
//

#import "KVRoutes.h"

#import "KVStops.h"

#import "TDataTypes.h"

// ----------------------------------------------------------------------

@interface KVRouteDirection ()
@property (strong, nonatomic, readonly) NSArray *stop;
@end

@interface KVRoute ()
@property (  copy, nonatomic, readonly) NSString *mode_name;
@end

@interface KVRouteMode ()
@property (  copy, nonatomic, readonly) NSString *route_type;
@property (strong, nonatomic, readonly) NSArray *route;
@end

@interface KVRoutes ()
@property (  copy, nonatomic, readonly) NSString *stop_id;
@property (  copy, nonatomic, readonly) NSString *stop_name;
@property (strong, nonatomic, readonly) NSArray  *mode;
@end

@interface KVRoutesByStop ()
@property (strong, nonatomic, readonly) NSArray  *mode;
@end

// ----------------------------------------------------------------------
#pragma mark -
// ----------------------------------------------------------------------

@implementation KVRouteDirection

- (instancetype)initWithDictionary:(NSDictionary *)dict {
	self = [super init];
	if (self) {
		[self setValuesForKeysWithDictionary:dict]; // loads '_stop' array
		if (_stop.count) {
			NSMutableArray *kvStops = @[].mutableCopy;
			for (NSDictionary *nsStop in _stop) {
				KVStop *kvStop = [[KVStop alloc] initWithDictionary:nsStop];
				[kvStops addObject:kvStop];
			}
			_stops = kvStops;
		}
	}
	return self;
}

- (NSString *)description {
	NSMutableString *result = [NSMutableString stringWithFormat:@"<%@ %p>", NSStringFromClass(self.class), self];
	[result appendFormat:@"\n\tid = '%@', name = '%@'", self.direction_id, self.direction_name];
	if (self.stops.count) {
		int index = 0;
		for (KVStop *stop in self.stops) {
			NSString *stop_order = [NSString stringWithFormat:@"%i", (int)stop.order];
			[result appendFormat:@"\n\t%2i: %@: stop %@ (%@) is at %f, %f (lat/lon)", index++, stop_order, stop.stop_id, stop.stop_name, stop.location.latitude, stop.location.longitude];
		}
	}
	return result;
}

@end

// ----------------------------------------------------------------------

@implementation KVRoute

- (instancetype)initWithDictionary:(NSDictionary *)dict {
	self = [super init];
	if (self) {
		[self setValuesForKeysWithDictionary:dict];
	}
	return self;
}

- (void)updateWithStopsByRoute:(KVStopsByRoute *)stops {
	
}

- (NSString *)description {
	NSMutableString *result = [NSMutableString stringWithFormat:@"<%@ %p>", NSStringFromClass(self.class), self];
	
	BOOL numericID = ([self.route_id integerValue] != 0);
	NSString *strID = (numericID ? [NSString stringWithFormat:@"#%@", self.route_id] : [NSString stringWithFormat:@"'%@'",self.route_id]);
	
	[result appendFormat:@"\n\t\t id = '%@', name = '%@'", strID, self.route_name];
	if (self.directions.count) {
		int index = 0;
		for (KVRouteDirection *direction in self.directions) {
			[result appendFormat:@"\n\t%2i: direction '%@' has %lu stops", index++, direction.direction_name, direction.stops.count];
		}
	}
	return result;
}

@end

// ----------------------------------------------------------------------

@implementation KVRouteMode

- (instancetype)initWithDictionary:(NSDictionary *)dict {
	self = [super init];
	if (self) {
		[self setValuesForKeysWithDictionary:dict]; // loads '_route' array
		if (_route.count) {
			NSMutableArray *kvRoutes = @[].mutableCopy;
			for (NSDictionary *nsRoute in _route) {
				KVRoute *kvRoute = [[KVRoute alloc] initWithDictionary:nsRoute];
				[kvRoutes addObject:kvRoute];
			}
			if (_route_type.length)
				_mode = [TRouteModes findModeInName:_route_type];
			_routes = kvRoutes;
		}
	}
	return self;
}

- (NSString *)description {
	NSMutableString *result = [NSMutableString stringWithFormat:@"<%@ %p>", NSStringFromClass(self.class), self];
	[result appendFormat:@"\n\ttype = '%i', name = '%@'", (int)self.route_type, self.mode_name];
	if (self.routes.count) {
		int index = 0;
		for (KVRoute *route in self.routes) {
			
			BOOL numericID = ([route.route_id integerValue] != 0);
			NSString *strID = (numericID ? [NSString stringWithFormat:@"#%@", route.route_id] : [NSString stringWithFormat:@"'%@'",route.route_id]);
			
			[result appendFormat:@"\n\t%2i: route %@ (%@)", index++, strID, route.route_name];
		}
	}
	return result;
}

@end

// ----------------------------------------------------------------------

@implementation KVRoutes

- (instancetype)initWithDictionary:(NSDictionary *)dict {
	self = [super init];
	if (self) {
		[self setValuesForKeysWithDictionary:dict];
		if (_mode.count) {
			NSMutableArray *kvModes = @[].mutableCopy;
			for (NSDictionary *nsMode in _mode) {
				KVRouteMode *kvMode = [[KVRouteMode alloc] initWithDictionary:nsMode];
				[kvModes addObject:kvMode];
			}
			_modes = kvModes;
		}
	}
	return self;
}

- (KVRoute *)routeByID:(NSString *)routeID {
	return nil;
}

- (NSString *)description {
	NSMutableString *result = [NSMutableString stringWithFormat:@"<%@ %p>", NSStringFromClass(self.class), self];
	if (self.modes.count) {
		int index = 0;
		for (KVRouteMode *mode in self.modes) {
			[result appendFormat:@"\n%2i: %@", index++, mode];
		}
	}
	return result;
}

@end

// ----------------------------------------------------------------------

@implementation KVRoutesByStop

- (instancetype)initWithDictionary:(NSDictionary *)dict {
	self = [super init];
	if (self) {
		[self setValuesForKeysWithDictionary:dict];
	}
	return self;
}

- (NSString *)description {
	NSMutableString *result = [NSMutableString stringWithFormat:@"<%@ %p>", NSStringFromClass(self.class), self];
	[result appendFormat:@"\n\tstop = '%@', name = '%@'", self.stop_id, self.stop_name];
	if (self.modes.count) {
		int index = 0;
		for (KVRouteMode *mode in self.modes) {
			[result appendFormat:@"\n%2i: %@", index++, mode];
		}
	}
	return result;
}

@end

// ----------------------------------------------------------------------

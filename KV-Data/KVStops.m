//
//  KVStops.m
//  MBTA-Mantle
//
//  Created by Steve Caine on 10/27/15.
//  Copyright (c) 2015 Steve Caine. All rights reserved.
//

#import "KVStops.h"

#import "KVRoutes.h"

// ----------------------------------------------------------------------

@interface KVStop ()
@property (assign, nonatomic, readwrite) CLLocationCoordinate2D location;

@property (  copy, nonatomic, readonly) NSNumber *stop_order;
@property (  copy, nonatomic, readonly) NSNumber *stop_lat;
@property (  copy, nonatomic, readonly) NSNumber *stop_lon;
@end

// ----------------------------------------------------------------------

@interface KVStopsByRoute ()
@property (strong, nonatomic, readonly)  NSArray *direction;
@end

// ----------------------------------------------------------------------

@interface KVStopsByLocation ()
@property (strong, nonatomic, readonly)  NSArray *stop;  // of NSDictionary

@property (strong, nonatomic, readwrite) NSArray *stops; // of KVStop
@end

// ----------------------------------------------------------------------
#pragma mark -
// ----------------------------------------------------------------------

@implementation KVStop

- (instancetype)initWithDictionary:(NSDictionary *)dict {
	self = [super init];
	if (self) {
		[self setValuesForKeysWithDictionary:dict];
		if (_stop_order)
			_order = [_stop_order integerValue];
		if (_stop_lat && _stop_lon) {
			_location.latitude  = [_stop_lat doubleValue];
			_location.longitude = [_stop_lon doubleValue];
		}
	}
	return self;
}

- (NSString *)description {
#if 1
	NSMutableString *result = [NSMutableString stringWithFormat:@"<%@ %p>", NSStringFromClass([self class]), self];
	
	BOOL numericID = ([self.stop_id integerValue] != 0);
	NSString *strID = (numericID ? [NSString stringWithFormat:@"#%@", self.stop_id] : [NSString stringWithFormat:@"'%@'",self.stop_id]);
	
	if (self.order)
		[result appendFormat:@"%2i: ", (int)self.order];
	
	[result appendFormat:@"Stop %@ ('%@')", strID, self.stop_name];
	
	if (self.distance > 0.0)
		[result appendFormat:@" is %f miles away", self.distance];
	
	[result appendFormat:@" at %f, %f (lat,lon)", self.location.latitude, self.location.longitude];
	
	return result;
#else
	NSMutableString *result = [NSMutableString stringWithFormat:@"%@ (%@) = '%@' - %f", NSStringFromClass(self.class), self.stop_id, self.stop_name, self.distance];
	return result;
#endif
}

@end

// ----------------------------------------------------------------------

@implementation KVStopsByRoute

- (instancetype)initWithDictionary:(NSDictionary *)dict routeID:(NSString *)routeID {
	self = [super init];
	if (self) {
		[self setValuesForKeysWithDictionary:dict]; // loads '_direction' array
		if (_direction.count) {
			NSMutableArray *kvDirections = [NSMutableArray array];
			for (NSDictionary *nsDirection in _direction) {
				KVRouteDirection *kvDirection = [[KVRouteDirection alloc] initWithDictionary:nsDirection];
				[kvDirections addObject:kvDirection];
			}
			_directions = kvDirections;
		}
		_routeID = routeID;
	}
	return self;
}

- (NSString *)description {
	NSMutableString *result = [NSMutableString stringWithFormat:@"<%@ %p>", NSStringFromClass([self class]), self];
	if (self.directions.count) {
		int index = 0;
		for (KVRouteDirection *direction in self.directions) {
			[result appendFormat:@"\n%2i: %@", index++, direction];
		}
	}
	return result;
}

@end

// ----------------------------------------------------------------------

@implementation KVStopsByLocation

- (instancetype)initWithDictionary:(NSDictionary *)dict location:(CLLocationCoordinate2D)location {
	self = [super init];
	if (self) {
		[self setValuesForKeysWithDictionary:dict]; // loads '_stop' array
		if (_stop.count) {
			NSMutableArray *kvStops = [NSMutableArray arrayWithCapacity:_stop.count];
			for (NSDictionary *nsStop in _stop) {
				KVStop *kvStop = [[KVStop alloc] initWithDictionary:nsStop];
				[kvStops addObject:kvStop];
			}
			_stops = kvStops;
		}
		_location = location;
	}
	return self;
}

- (NSString *)description {
	NSMutableString *result = [NSMutableString stringWithFormat:@"<%@ %p> ", NSStringFromClass(self.class), self];
	
	int index = 0;
	for (KVStop *kvStop in self.stops) {
		[result appendFormat:@"\n%2i: %@", index++, kvStop];
	}
	
	return result;
}

@end

// ----------------------------------------------------------------------

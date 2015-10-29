//
//  KVStops.m
//  MBTA-Mantle
//
//  Created by Steve Caine on 10/27/15.
//  Copyright (c) 2015 Steve Caine. All rights reserved.
//

#import "KVStops.h"

// ----------------------------------------------------------------------

@interface KVStop ()
@property (  assign, nonatomic, readonly) CLLocationDegrees stop_lat;
@property (  assign, nonatomic, readonly) CLLocationDegrees stop_lon;
@end

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
	}
	return self;
}

- (NSString *)description {
	NSMutableString *result = [NSMutableString stringWithFormat:@"%@ (%@) = '%@' - %f", NSStringFromClass(self.class), self.stop_id, self.stop_name, self.distance];
	return result;
}

@end

// ----------------------------------------------------------------------

@implementation KVStopsByRoute

- (instancetype)initWithDictionary:(NSDictionary *)dict {
	self = [super init];
	if (self) {
		[self setValuesForKeysWithDictionary:dict];
	}
	return self;
}

@end

// ----------------------------------------------------------------------

@implementation KVStopsByLocation

- (instancetype)initWithDictionary:(NSDictionary *)dict location:(CLLocationCoordinate2D)location {
	self = [super init];
	if (self) {
		[self setValuesForKeysWithDictionary:dict];
		if (_stop.count) {
			NSMutableArray *kvStops = [NSMutableArray arrayWithCapacity:_stop.count];
			for (NSDictionary *nsStop in _stop) {
				KVStop *kvStop = [[KVStop alloc] initWithDictionary:nsStop];
				[kvStops addObject:kvStop];
			}
			_stops = [kvStops copy];
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

//
//  TStops.m
//  MBTA-Mantle
//
//  Created by Steve Caine on 10/26/15.
//  Copyright (c) 2015 Steve Caine. All rights reserved.
//

#import "TStops.h"

#import "TRoutes.h"

// ----------------------------------------------------------------------

@interface TStop ()
@property (  assign, nonatomic, readonly) CLLocationDegrees stop_lat;
@property (  assign, nonatomic, readonly) CLLocationDegrees stop_lon;
@end

// ----------------------------------------------------------------------
#pragma mark -
// ----------------------------------------------------------------------

@implementation TStop

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
	return @{
			 @"ID"			 : @"stop_id",
			 @"name"		 : @"stop_name",
			 @"station"		 : @"parent_station",
			 @"station_name" : @"parent_station_name",
			 // for stopsbyroute
			 @"order"		 : @"order",
			 // for stopsbylocation - stop's distance in miles from requested location
			 @"distance"	 : @"distance",
			 // private
			 @"stop_lat"	 : @"stop_lat",
			 @"stop_lon"	 : @"stop_lon",
			 };
}

+ (NSValueTransformer *)orderJSONTransformer {
	return [MTLValueTransformer transformerUsingForwardBlock:^id(NSString *value, BOOL *success, NSError *__autoreleasing *error) {
		return [NSNumber numberWithInteger:[value integerValue]];
	}];
}
+ (NSValueTransformer *)distanceJSONTransformer {
	return [MTLValueTransformer transformerUsingForwardBlock:^id(NSString *value, BOOL *success, NSError *__autoreleasing *error) {
		return [NSNumber numberWithDouble:[value doubleValue]];
	}];
}
+ (NSValueTransformer *)stop_latJSONTransformer {
	return [MTLValueTransformer transformerUsingForwardBlock:^id(NSString *value, BOOL *success, NSError *__autoreleasing *error) {
		return [NSNumber numberWithDouble:[value doubleValue]];
	}];
}
+ (NSValueTransformer *)stop_lonJSONTransformer {
	return [MTLValueTransformer transformerUsingForwardBlock:^id(NSString *value, BOOL *success, NSError *__autoreleasing *error) {
		return [NSNumber numberWithDouble:[value doubleValue]];
	}];
}

- (NSString *)description {
	NSMutableString *result = [NSMutableString stringWithFormat:@"%@ (%@) = '%@' - %f", NSStringFromClass(self.class), self.ID, self.name, self.distance];
	return result;
}

- (CLLocationCoordinate2D) location {
	CLLocationCoordinate2D result = { self.stop_lat, self.stop_lon };
	return result;
}

@end

// ----------------------------------------------------------------------
#pragma mark -
// ----------------------------------------------------------------------

@implementation TStopsByRoute

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
	return @{
			 @"directions"	: @"direction",
			 };
}

+ (NSValueTransformer *)directionsJSONTransformer {
	return [MTLJSONAdapter arrayTransformerWithModelClass:[TRouteDirection class]];
}

- (NSString *)description {
	NSMutableString *result = [NSMutableString stringWithFormat:@"<%@ %p>", NSStringFromClass([self class]), self];
	if ([self.directions count]) {
		int index = 0;
		for (TRouteDirection *direction in self.directions) {
			[result appendFormat:@"\n%2i: %@", index++, direction];
		}
	}
	return result;
}

@end

// ----------------------------------------------------------------------
#pragma mark -
// ----------------------------------------------------------------------

@implementation TStopsByLocation

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
	return @{
			 @"stops" : @"stop"
			 };
}

+ (NSValueTransformer *)stopsJSONTransformer {
	return [MTLJSONAdapter arrayTransformerWithModelClass:[TStop class]];
}

- (NSString *)description {
	NSMutableString *result = [NSMutableString stringWithFormat:@"<%@ %p> ", NSStringFromClass(self.class), self];
	
	int index = 0;
	for (TStop *stop in self.stops) {
		[result appendFormat:@"\n%2i: %@", index++, stop];
	}
	
	return result;
}

@end

// ----------------------------------------------------------------------

//
//  TRequestTypes.m
//  MBTA-Mantle
//
//  Created by Steve Caine on 10/26/15.
//  Copyright (c) 2015 Steve Caine. All rights reserved.
//

#import "TDataTypes.h"

// ----------------------------------------------------------------------

@implementation TRouteModes

+ (NSString *)nameForMode:(RouteMode)mode {
	if (mode >= RouteMode_begin && mode < RouteModes_end) {
		return [self modes][mode];
	}
	return nil;
}

// "xxx-name-xxx" => enum (find mode name within -name-)
+ (RouteMode)findModeInName:(NSString *)name {
	RouteMode result = mode_unknown;
	if (name.length) {
		for (RouteMode mode = RouteMode_begin; mode != RouteModes_end; ++mode) {
			NSString *str = [self modes][mode];
			if ([name rangeOfString:str].location != NSNotFound) {
				result = mode;
				break;
			}
		}
	}
	return result;
}

+ (NSArray *)modes {
	static NSArray *_modes;
	if (_modes == nil) {
		_modes = @[
				   @"(unknown)",
				   @"Subway",
				   @"Rail",
				   @"Bus",
				   @"Boat"
				   ];
	}
	return _modes;
}

@end

// ----------------------------------------------------------------------

// ----------------------------------------------------------------------
#pragma mark -
// ----------------------------------------------------------------------

@implementation TRequestTypes

// enum => name
+ (NSString *)nameOfRequest:(TRequestType)requestType {
	if (requestType > TRequest_invalid && requestType < TRequestsCount) {
		return [self requests][requestType];
	}
	return nil;
}

// "xxx-name-xxx" => enum (find request name within -name-)
+ (TRequestType)findRequestTypeInName:(NSString *)name {
	if (name.length) {
		for (TRequestType type = TRequests_begin; type != TRequests_end; ++type) {
			NSString *str = [self requests][type];
			if ([name rangeOfString:str].location != NSNotFound)
				return type;
		}
	}
	return TRequest_invalid;
}

// ----------------------------------------------------------------------

+ (NSArray *)requests {
	static NSArray *_requests;
	
	if (_requests == nil) {
		_requests = @[
					  @"(invalid)",
					  @"servertime",
					  @"routes",
					  @"routesbystop",
					  @"stopsbyroute",
					  @"stopsbylocation",
					  /** /
					  schedulebystop
					  schedulebyroute
					  schedulebytrip
					  
					  predictionsbystop
					  predictionsbyroute
					  predictionsbytrip
					  
					  vehiclesbyroute
					  vehiclesbytrip
					  
					  alerts
					  alertsbyroute
					  alertsbystop
					  alertbyid
					  
					  alertheaders
					  alertheadersbyroute
					  alertheadersbystop
					  / **/
					  ];
	}
	return _requests;
}

@end

// ----------------------------------------------------------------------

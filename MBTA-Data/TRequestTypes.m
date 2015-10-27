//
//  TRequestTypes.m
//  MBTA-Mantle
//
//  Created by Steve Caine on 10/26/15.
//  Copyright (c) 2015 Steve Caine. All rights reserved.
//

#import "TRequestTypes.h"

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

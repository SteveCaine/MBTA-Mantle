//
//  TDataTypes.h
//  MBTA-Mantle
//
//  Created by Steve Caine on 10/26/15.
//  Copyright (c) 2015 Steve Caine. All rights reserved.
//

#import <Foundation/Foundation.h>

// ----------------------------------------------------------------------

typedef enum : NSUInteger {
	mode_unknown,
	mode_Subway, // there are two Subway modes: Green Line and everything else
	mode_Rail,	 // so 'mode_Subway' is part of our logic to combine them
	mode_Bus,
	mode_Boat,
	
	RouteModes_end,
	RouteMode_begin = mode_Subway,
	
	RouteModesCount = RouteModes_end - RouteMode_begin
} RouteMode;

@interface TRouteModes : NSObject

+ (NSString *)nameForMode:(RouteMode)mode;
+ (RouteMode)findModeInName:(NSString *)name;

@end

// ----------------------------------------------------------------------
#pragma mark -
// ----------------------------------------------------------------------

typedef enum TRequestTypes {
	TRequest_invalid,
	TRequest_servertime,
	TRequest_routes,
	TRequest_routesbystop,
	TRequest_stopsbyroute,
	TRequest_stopsbylocation,
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
	TRequests_end,
	TRequests_begin = TRequest_servertime,
	
	TRequestsCount = TRequests_end - TRequests_begin
} TRequestType;

// ----------------------------------------------------------------------

@interface TRequestTypes : NSObject

+ (NSString *)nameOfRequest:(TRequestType)requestType;

// searches -name- for request name as substring
+ (TRequestType)findRequestTypeInName:(NSString *)name;

@end

// ----------------------------------------------------------------------

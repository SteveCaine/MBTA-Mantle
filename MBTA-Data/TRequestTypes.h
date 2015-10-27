//
//  TRequestTypes.h
//  MBTA-Mantle
//
//  Created by Steve Caine on 10/26/15.
//  Copyright (c) 2015 Steve Caine. All rights reserved.
//

#import <Foundation/Foundation.h>

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

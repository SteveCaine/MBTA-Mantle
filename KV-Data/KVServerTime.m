//
//  KVServerTime.m
//  MBTA-Mantle
//
//  Created by Steve Caine on 10/27/15.
//  Copyright (c) 2015 Steve Caine. All rights reserved.
//

#import "KVServerTime.h"

// ----------------------------------------------------------------------

@interface KVServerTime ()

@property (strong, nonatomic, readwrite) NSDate *servertime;

@property (assign, nonatomic) NSTimeInterval server_dt;

@end

// ----------------------------------------------------------------------

@implementation KVServerTime

- (NSDate *)servertime {
	if (_servertime == nil)
		_servertime = [NSDate dateWithTimeIntervalSince1970:_server_dt];
	return _servertime;
}

- (instancetype)initWithDictionary:(NSDictionary *)dict {
	self = [super init];
	if (self) {
		[self setValuesForKeysWithDictionary:dict];
	}
	return self;
}

- (NSString *)description {
	NSMutableString *result = [NSMutableString stringWithFormat:@"%@ servertime = %@", NSStringFromClass(self.class), self.servertime];
	return result;
}

@end

// ----------------------------------------------------------------------

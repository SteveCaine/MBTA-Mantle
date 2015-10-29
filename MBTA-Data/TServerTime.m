//
//  TServerTime.m
//  MBTA-Mantle
//
//  Created by Steve Caine on 10/26/15.
//  Copyright (c) 2015 Steve Caine. All rights reserved.
//

#import "TServerTime.h"

// ----------------------------------------------------------------------

@interface TServerTime ()
@end

// ----------------------------------------------------------------------

@implementation TServerTime

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
	// map all properties by name
	NSMutableDictionary *result = [[NSDictionary mtl_identityPropertyMapWithModel:[self class]] mutableCopy];
	
	// override those where property-name != JSON key
	NSDictionary *custom = @{
							 @"servertime" : @"server_dt"
							 };
	[result addEntriesFromDictionary:custom];
	
	return result;
}

- (NSString *)description {
	NSMutableString *result = [NSMutableString stringWithFormat:@"%@ servertime = %@", NSStringFromClass(self.class), self.servertime];
	return result;
}

// ----------------------------------------------------------------------

+ (NSValueTransformer *)servertimeJSONTransformer {
	return [MTLValueTransformer transformerUsingForwardBlock:^id(NSString *value, BOOL *success, NSError *__autoreleasing *error) {
		return [NSDate dateWithTimeIntervalSince1970:[value integerValue]];
	}];
}

@end

// ----------------------------------------------------------------------

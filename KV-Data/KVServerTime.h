//
//  KVServerTime.h
//  MBTA-Mantle
//
//  Created by Steve Caine on 10/27/15.
//  Copyright (c) 2015 Steve Caine. All rights reserved.
//

#import <Foundation/Foundation.h>

// ----------------------------------------------------------------------

@interface KVServerTime : NSObject

@property (strong, nonatomic, readonly) NSDate *servertime;

- (instancetype)initWithDictionary:(NSDictionary *)dict;

@end

// ----------------------------------------------------------------------

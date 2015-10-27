//
//  TServerTime.h
//  MBTA-Mantle
//
//  Created by Steve Caine on 10/26/15.
//  Copyright (c) 2015 Steve Caine. All rights reserved.
//

#import <Mantle/Mantle.h>

// ----------------------------------------------------------------------

@interface TServerTime : MTLModel <MTLJSONSerializing>

@property (  copy, nonatomic, readonly) NSDate *servertime;

@end

// ----------------------------------------------------------------------

//
//	MasterViewController.m
//	MBTA-Mantle
//
//	Created by Steve Caine on 10/26/15.
//	Copyright (c) 2015 Steve Caine. All rights reserved.
//

#import "MasterViewController.h"

#import "DetailViewController.h"

#import "TDataTypes.h"

#import "TServerTime.h"
#import "TRoutes.h"
#import "TStops.h"

#import "KVServerTime.h"
#import "KVRoutes.h"
#import "KVStops.h"

#import "FilesUtil.h"

#import "Debug_iOS.h"

// ----------------------------------------------------------------------

static NSString * const SegueID_DetailVC = @"showDetail";
static NSString * const CellID_BasicCell = @"Cell";

static NSString * const type_json		 = @"json";

static NSString * const subtitle_idle	 = @"idle";
static NSString * const subtitle_success = @"Success!";
static NSString * const subtitle_failed  = @"Failed!";

static const NSTimeInterval resetDelay = 2.5;

enum {
	section_mantle,
	section_kvcoding,
};

// ----------------------------------------------------------------------

@interface MasterViewController ()
@property (strong, nonatomic) NSArray *sectionNames;
@property (strong, nonatomic) NSArray *jsonNames;
@end

// ----------------------------------------------------------------------
#pragma mark -
// ----------------------------------------------------------------------

@implementation MasterViewController

- (NSDictionary *)readJSON:(NSString *)jsonPath {
	NSDictionary * result = nil;
	
	NSData *data = [NSData dataWithContentsOfFile:jsonPath];
	if (data.length) {
		MyLog(@"%s read %lu bytes", __FUNCTION__, data.length);
		NSError *error = nil;
		id dict = nil;
		
		@try {
			dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
		}
		@catch (NSException *exception) {
			NSLog(@"Exception thrown: %@", exception);
		}
		if (error)
			NSLog(@"JSON de-serializing error: %@", error.localizedDescription);
		
		else if (dict == nil || ![dict isKindOfClass:NSDictionary.class])
			NSLog(@"Nil/Invalid JSON.");
		
		else {
			result = dict;
		}
	}
	return result;
}

// ----------------------------------------------------------------------

- (id)dict2KVObject:(NSDictionary *)dict forType:(TRequestType)requestType {
	id obj = nil;
	
	if (dict.count && requestType != TRequest_invalid) {
		switch (requestType) {
			case TRequest_servertime:
				obj = [[KVServerTime alloc] initWithDictionary:dict];
				break;
			case TRequest_routes:
				obj = [[KVRoutes alloc] initWithDictionary:dict];
				break;
			case TRequest_routesbystop:
				obj = [[KVRoutesByStop alloc] initWithDictionary:dict];
				break;
			case TRequest_stopsbyroute:
				obj = [[KVStopsByRoute alloc] initWithDictionary:dict routeID:@"?"];
				break;
			case TRequest_stopsbylocation: {
				CLLocationCoordinate2D location = { 41, -71 };
				obj = [[KVStopsByLocation alloc] initWithDictionary:dict location:location];
			}	break;
			default:
				break;
		}
	}
	
	return obj;
}

// ----------------------------------------------------------------------

- (id)dict2MantleObject:(NSDictionary *)dict forType:(TRequestType)requestType {
	id obj = nil;
	
	if (dict.count && requestType != TRequest_invalid) {
		NSError *error = nil;
		switch (requestType) {
			case TRequest_servertime:
				obj = [MTLJSONAdapter modelOfClass:TServerTime.class fromJSONDictionary:dict error:&error];
				break;
			case TRequest_routes:
				obj = [MTLJSONAdapter modelOfClass:TRoutes.class fromJSONDictionary:dict error:&error];
				break;
			case TRequest_routesbystop:
				obj = [MTLJSONAdapter modelOfClass:TRoutesByStop.class fromJSONDictionary:dict error:&error];
				break;
			case TRequest_stopsbyroute:
				obj = [MTLJSONAdapter modelOfClass:TStopsByRoute.class fromJSONDictionary:dict error:&error];
				// set .routeID here from request
				break;
			case TRequest_stopsbylocation:
				obj = [MTLJSONAdapter modelOfClass:TStopsByLocation.class fromJSONDictionary:dict error:&error];
				// set .location here from request
				break;
			default:
				break;
		}
		if (error)
			NSLog(@"dict2Mantle error: %@", error.localizedDescription);
	}
	return obj;
}

// ----------------------------------------------------------------------

- (BOOL)useKVCoding:(NSString *)jsonPath {
	BOOL result = NO;
	
	NSDictionary *dict = [self readJSON:jsonPath];
	if (dict) {
		NSString *name = [[FilesUtil namesFromPaths:@[jsonPath] stripExtensions:YES] firstObject];
		TRequestType requestType = [TRequestTypes findRequestTypeInName:name];
		MyLog(@" request type = '%@'", [TRequestTypes nameOfRequest:requestType]);
		id obj = [self dict2KVObject:dict forType:requestType];
		if (obj) {
			MyLog(@" obj => %@", obj);
			result = YES;
		}
	}
	
	return result;
}

// ----------------------------------------------------------------------

- (BOOL)useMantle:(NSString *)jsonPath {
	BOOL result = NO;
	
	NSDictionary *dict = [self readJSON:jsonPath];
	if (dict) {
		NSString *name = [[FilesUtil namesFromPaths:@[jsonPath] stripExtensions:YES] firstObject];
		TRequestType requestType = [TRequestTypes findRequestTypeInName:name];
		MyLog(@" request type = '%@'", [TRequestTypes nameOfRequest:requestType]);
		id obj = [self dict2MantleObject:dict forType:requestType];
		if (obj) {
			MyLog(@" obj => %@", obj);
			result = YES;
		}
	}
	return result;
}

// ----------------------------------------------------------------------

- (void)resetForIndexPath:(NSIndexPath *)indexPath {
	// ASSUMED: we've already validated indexPath in caller
	UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
	cell.detailTextLabel.text = subtitle_idle;
}

// ----------------------------------------------------------------------
#pragma mark -
// ----------------------------------------------------------------------

- (void)awakeFromNib {
	[super awakeFromNib];
	
	self.sectionNames = @[ @"Mantle", @"KV-Coding", ];

	NSArray *jsonPaths = [FilesUtil pathsForBundleFilesType:type_json sortedBy:SortFiles_alphabeticalAscending];
	
	self.jsonNames = [FilesUtil namesFromPaths:jsonPaths stripExtensions:YES];
}

- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

// ----------------------------------------------------------------------
#pragma mark - UITableViewDataSource
// ----------------------------------------------------------------------

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return self.sectionNames.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	if (section < self.sectionNames.count)
		return self.sectionNames[section];
	return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return self.jsonNames.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellID_BasicCell forIndexPath:indexPath];
	
	NSString *text = self.jsonNames[indexPath.row];
	NSRange r = [text rangeOfString:@"-"];
	if (r.location == 1)
		text = [text substringFromIndex:r.location + r.length];
	cell.textLabel.text = text;
	
	cell.detailTextLabel.text = subtitle_idle;
	
	/** /
	if (indexPath.section == section_kvcoding) {
		switch (indexPath.row + 1) {
			case TRequest_servertime:
			case TRequest_stopsbylocation:
			case TRequest_stopsbylocation + 1:
				break;
			default:
				cell.userInteractionEnabled = cell.textLabel.enabled = cell.detailTextLabel.enabled = NO;
				break;
		}
	}
	/ **/
	
	return cell;
}

// ----------------------------------------------------------------------
#pragma mark - UITableViewDelegate
// ----------------------------------------------------------------------

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
	[cell setSelected:NO animated:YES];

	if (indexPath.row < self.jsonNames.count) {
		NSString *jsonName = self.jsonNames[indexPath.row];
		NSString *jsonPath = [NSBundle.mainBundle pathForResource:jsonName ofType:type_json];
		if (jsonPath.length) {
			BOOL success = NO;
			
			switch (indexPath.section) {
				case section_kvcoding:
					success = [self useKVCoding:jsonPath];
					break;
				case section_mantle:
					success = [self useMantle:jsonPath];
					break;
				default:
					break;
			}
			
			cell.detailTextLabel.text = (success ? @"Success!" : @"Failed!");
			// now post new 'ready' for this row: after X seconds, reset to its original state
			[self performSelector:@selector(resetForIndexPath:) withObject:indexPath afterDelay:resetDelay];
		}
	}
}

// ----------------------------------------------------------------------
#pragma mark - Segues
// ----------------------------------------------------------------------

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
	return NO;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	if ([segue.identifier isEqualToString:SegueID_DetailVC]) {
//		NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
		NSDate *object = NSDate.date;
		[segue.destinationViewController setDetailItem:object];
	}
}

@end

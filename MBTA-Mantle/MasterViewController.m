//
//	MasterViewController.m
//	MBTA-Mantle
//
//	Created by Steve Caine on 10/26/15.
//	Copyright (c) 2015 Steve Caine. All rights reserved.
//

#import "MasterViewController.h"

#import "DetailViewController.h"

#import "TRequestTypes.h"

#import "TServerTime.h"
#import "TRoutes.h"
#import "TStops.h"

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

// ----------------------------------------------------------------------

@interface MasterViewController ()
@property (strong, nonatomic) NSArray *jsonNames;
@end

// ----------------------------------------------------------------------
#pragma mark -
// ----------------------------------------------------------------------

@implementation MasterViewController

- (BOOL)parseJSON:(NSString *)jsonPath {
	BOOL result = NO;
	
	NSData *data = [NSData dataWithContentsOfFile:jsonPath];
	if ([data length]) {
		MyLog(@"%s read %i bytes", __FUNCTION__, data.length);
		
		NSError *error = nil;
		id json = nil;
		
		@try {
			json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
		}
		@catch (NSException *exception) {
			NSLog(@"Exception thrown: %@", exception);
		}
		if (error)
			NSLog(@"JSON de-serializing error: %@", [error localizedDescription]);

		else if (json == nil || ![json isKindOfClass:[NSDictionary class]])
			NSLog(@"Nil/Invalid JSON.");
		
		else {
			NSString *name = [[FilesUtil namesFromPaths:@[jsonPath] stripExtensions:YES] firstObject];
			TRequestType requestType = [TRequestTypes findRequestTypeInName:name];
			
			id obj = nil;
			switch (requestType) {
				case TRequest_servertime:
					obj = [MTLJSONAdapter modelOfClass:[TServerTime class] fromJSONDictionary:json error:&error];
					break;
				case TRequest_routes:
					obj = [MTLJSONAdapter modelOfClass:[TRoutes class] fromJSONDictionary:json error:&error];
					break;
				case TRequest_routesbystop:
					obj = [MTLJSONAdapter modelOfClass:[TRoutesByStop class] fromJSONDictionary:json error:&error];
					break;
				case TRequest_stopsbyroute:
					obj = [MTLJSONAdapter modelOfClass:[TStopsByRoute class] fromJSONDictionary:json error:&error];
					break;
				case TRequest_stopsbylocation:
					obj = [MTLJSONAdapter modelOfClass:[TStopsByLocation class] fromJSONDictionary:json error:&error];
					break;
				default:
					break;
			}
			if (error)
				NSLog(@"Mantle error: %@", [error localizedDescription]);
			else if (obj) {
				MyLog(@" obj => %@", obj);
				result = YES;
			}
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
	return 1;
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
	
	switch (indexPath.row + 1) {
		case TRequest_servertime:
		case TRequest_stopsbylocation:
		case TRequest_stopsbylocation + 1:
			break;
		default:
			cell.userInteractionEnabled = cell.textLabel.enabled = cell.detailTextLabel.enabled = NO;
			break;
	}
	
	return cell;
}

// ----------------------------------------------------------------------
#pragma mark - UITableViewDelegate
// ----------------------------------------------------------------------

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
	[cell setSelected:NO animated:YES];

	if (indexPath.row < [self.jsonNames count]) {
		NSString *jsonName = self.jsonNames[indexPath.row];
		NSString *jsonPath = [[NSBundle mainBundle] pathForResource:jsonName ofType:type_json];
		if ([jsonPath length]) {
			BOOL success = [self parseJSON:jsonPath];
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
	if ([[segue identifier] isEqualToString:SegueID_DetailVC]) {
//		NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
		NSDate *object = [NSDate date];
		[[segue destinationViewController] setDetailItem:object];
	}
}

@end

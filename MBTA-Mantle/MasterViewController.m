//
//	MasterViewController.m
//	MBTA-Mantle
//
//	Created by Steve Caine on 10/26/15.
//	Copyright (c) 2015 Steve Caine. All rights reserved.
//

#import "MasterViewController.h"

#import "DetailViewController.h"

// ----------------------------------------------------------------------

static NSString * const SegueID_DetailVC = @"showDetail";

static NSString * const CellID_BasicCell = @"Cell";

// ----------------------------------------------------------------------

@interface MasterViewController ()
@property (strong, nonatomic) NSArray *strs;
@end

// ----------------------------------------------------------------------
#pragma mark -
// ----------------------------------------------------------------------

@implementation MasterViewController

- (void)awakeFromNib {
	[super awakeFromNib];
	self.strs = @[ @"one", @"two", @"three" ];
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
	return self.strs.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellID_BasicCell forIndexPath:indexPath];
	cell.textLabel.text = self.strs[indexPath.row];
	return cell;
}

// ----------------------------------------------------------------------
#pragma mark - UITableViewDelegate
// ----------------------------------------------------------------------

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
	[cell setSelected:NO animated:YES];
}

// ----------------------------------------------------------------------
#pragma mark - Segues
// ----------------------------------------------------------------------

//- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
//	return NO;
//}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	if ([[segue identifier] isEqualToString:SegueID_DetailVC]) {
//		NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
		NSDate *object = [NSDate date];
		[[segue destinationViewController] setDetailItem:object];
	}
}

@end

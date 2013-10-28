//
//  CBBDataTableViewController.m
//  CBB Counter
//
//  Created by Spruce Bondera on 9/2/13.
//  Copyright (c) 2013 Spruce Bondera. All rights reserved.
//

#import "CBBDataTableViewController.h"
#import "CBBDataEditingViewController.h"
#import "Common.h"


@interface CBBDataTableViewController ()
@property (nonatomic, strong) NSMutableArray *data;
@end

@implementation CBBDataTableViewController

-(NSMutableArray *) data {
    return [[NSUserDefaults standardUserDefaults] objectForKey: TreesDataKey];
}


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Makes sure there's a tree data array in there
    if (!self.data) {
        [[NSUserDefaults standardUserDefaults] setObject: [[NSMutableArray alloc] init] forKey:TreesDataKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    self.tableView.dataSource = self;
    self.tableView.delegate = self;

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.data count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: CellPrototypeName];
    
    cell.textLabel.text = [@"Tree " stringByAppendingFormat:@"%ld", (long)indexPath.row + 1];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Green: %@ CBB: %@ Fungus: %@", self.data[indexPath.row][GreenKey], self.data[indexPath.row][CBBKey], self.data[indexPath.row][FungusKey]];
    return cell;
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString: @"New"]){
        [segue.destinationViewController setEditingNumber: [self.data count]];
    } else if ([segue.identifier isEqualToString: @"EditTreeItem"]){
        [segue.destinationViewController setEditingNumber: [self.tableView indexPathForSelectedRow].row];
    }
}
-(void) viewDidAppear:(BOOL)animated{
    [self.tableView reloadData];
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.data removeObjectAtIndex: indexPath.row];
        [self.tableView reloadData];
    }
}

- (IBAction)clear:(UIBarButtonItem *)sender {
    [[[NSUserDefaults standardUserDefaults] objectForKey:TreesDataKey] removeAllObjects];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self.tableView reloadData];
}

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
    
{
    
}

@end

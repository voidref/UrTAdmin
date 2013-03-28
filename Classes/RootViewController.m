//
//  RootViewController.m
//  UrTAdmin
//
//  Created by Alan Westbrook on 6/12/10.
//  Copyright Rockwood Software 2010. All rights reserved.
//

#import "RootViewController.h"
#import "AddServerController.h"
#import "EditServerViewController.h"
#import "ServerActivityViewController.h"
#import "ServerData.h"


@implementation RootViewController


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad 
{
    [super viewDidLoad];
    [[NSBundle mainBundle] loadNibNamed:@"NoServers" owner:self options:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    self.navigationItem.leftBarButtonItem = self.editButtonItem;

	if (0 == [ServerData serverCount])
	{
        self.cachedTV = self.tableView;
		self.view = self.noServersView;
        self.navigationItem.leftBarButtonItem = nil;
	}
    else if (self.view == self.noServersView)
    {
        self.tableView = self.cachedTV;
    }
    
    [self.tableView reloadData];
}

- (void)viewDidAppear: (BOOL)animated 
{
    [super viewDidAppear:animated];
}

/*
 // Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations.
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
 */


#pragma mark -
#pragma mark Table view data source

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView: (UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView: (UITableView *)tableView 
 numberOfRowsInSection: (NSInteger)    section 
{
    return [ServerData serverCount];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    static NSString *CellIdentifier = @"ServerCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    if (cell == nil)
	{
        NSLog(@"** Error: This should not happen, your xib is busted");
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    }
    
	// Configure the cell.
	NSArray* data = [ServerData getServerDataAtIndex:indexPath.row];

    if (data.count == 4)
    {
        cell.textLabel.text = [data objectAtIndex:0];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", [data objectAtIndex:1]];
    }
    else
    {
        NSLog(@"** Error, data incomplete for row %i, bad coder, bad!", indexPath.row);
        [ServerData deleteServerAtIndex: indexPath.row];
    }
		
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source.
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }   
}
*/


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


#pragma mark -
#pragma mark Table view delegate


#pragma mark -
#pragma mark Navigation Controller delegate

- (void)navigationController:(UINavigationController *)navigationController 
      willShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animated
{
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue_
                  sender:(id)sender_
{
    // Make the assumption that if we have set the name of the Seque, we will need to do this.
    if (segue_.identifier.length > 0)
    {
        id<ServerViewController> controller = [segue_ destinationViewController];
        
        [controller setServerIndex: [self.tableView indexPathForSelectedRow].row];
    }
}

#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}




@end


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
#import "ServerViewController.h"
#import "ServerData.h"


@implementation RootViewController

@synthesize current;

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad 
{
    [super viewDidLoad];

//	self.title = @"Servers";
    
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc ] initWithBarButtonSystemItem: UIBarButtonSystemItemAdd 
//																							target: self 
//																							action: @selector(createNewServer:)];
		
	serverCount = [ServerData serverCount];
    
//    self.navigationController.delegate = self;
}
	

- (IBAction) createNewServer: (id)sender
{
	addServer = [[AddServerController alloc ] initWithNibName: @"AddServer" bundle: [NSBundle mainBundle]];
	
	[self presentViewController: addServer animated: YES completion:nil];
}

/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
*/

- (void)viewDidAppear: (BOOL)animated 
{
    [super viewDidAppear:animated];
	
	serverCount = [ServerData serverCount];
    
//	if (0 == serverCount) 
//	{
//		[self createNewServer:nil];
//	} 

    [self.tableView reloadData];
}

/*
- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
}
*/

/*
 // Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations.
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
 */

- (void) startEditing: (NSInteger) index_
{
    editor = [[EditServerViewController alloc ] initWithNibName: @"EditServerViewController"
                                                         bundle: [NSBundle mainBundle]];
    editor.delegate = self;
    editor.serverIndex = index_;
    [self.navigationController pushViewController:editor animated:YES];
//    [self presentViewController: editor
//                       animated: YES
//                     completion: nil];
    
}

- (void) stopEditing
{
    [self dismissViewControllerAnimated:YES
                             completion:nil];
}

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
    return serverCount;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    if (cell == nil)
	{
        NSLog(@"** Error: This should not happen, your xib is busted");
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    }
    
	// Configure the cell.
	NSArray* data = [ServerData getServerDataAtIndex:indexPath.row + 1];

	cell.textLabel.text = [data objectAtIndex:0];
	cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", [data objectAtIndex:1]];

		
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


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
    NSLog(@"%s: %@", __PRETTY_FUNCTION__, indexPath);
    
//    current = [[ServerViewController alloc] initWithNibName:@"ServerViewController" bundle:nil];
    
    // Server Indexes are 1 based (possibly because I am crazy)
//    [current setIndex:indexPath.row + 1];
    
    // Pass the selected object to the new view controller.
//    [self.navigationController pushViewController:current animated:YES];
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
//    [self startEditing: indexPath.row + 1];
}

#pragma mark -
#pragma mark Navigation Controller delegate

- (void)navigationController:(UINavigationController *)navigationController 
      willShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animated
{
    if (viewController == self) 
    {
        [current reset];
    }
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue_
                  sender:(id)sender_
{
    if ([segue_.identifier isEqualToString: @"ServerView"])
    {
        ServerViewController* controller = (ServerViewController*)[segue_ destinationViewController];
        
        // TODO: I need to change over to 0 based indexes for the servers
        controller.index = [self.tableView indexPathForSelectedRow].row + 1;
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


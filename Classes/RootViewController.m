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


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad 
{
    [super viewDidLoad];
}
	
/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
*/

- (void)viewDidAppear: (BOOL)animated 
{
    [super viewDidAppear:animated];
	
    // TODO: Add "no servers, press '+' above to add one" screen.
//	if (0 == [ServerData serverCount])
//	{
//		self.view = self.noServersView;
//	}
//    else if (nil == self.view)
//    {
//        self.view = self.tableView;
//    }

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
//    editor = [[EditServerViewController alloc ] initWithNibName: @"EditServerViewController"
//                                                         bundle: [NSBundle mainBundle]];
//    editor.delegate = self;
//    editor.serverIndex = index_;
//    [self.navigationController pushViewController:editor animated:YES];    
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
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
//    [self startEditing: indexPath.row];
}

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
    if ([segue_.identifier isEqualToString: @"ServerView"])
    {
        ServerViewController* controller = (ServerViewController*)[segue_ destinationViewController];
        
        controller.index = [self.tableView indexPathForSelectedRow].row;
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


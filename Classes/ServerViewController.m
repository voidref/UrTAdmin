//
//  ServerViewController.m
//  UrTAdmin
//
//  Created by Alan Westbrook on 9/6/11.
//  Copyright 2011 Voidref Software. All rights reserved.
//

#import "ServerViewController.h"
#import "EditServerViewController.h"
#import "ServerData.h"

@implementation ServerViewController

@synthesize mapName;
@synthesize playerList;
@synthesize conn;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.conn = nil;
        serverIndex = -1;
    }

    return self;
}

- (void)dealloc
{
    [self reset];
    
}

- (void) reset
{
    self.conn = nil;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];    
    
//    [self setEditingButtonState:NO];
}

- (void)viewDidUnload
{
    [self reset];
    self.mapName = nil;
    self.playerList = nil;
        
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)setIndex: (uint32_t)index_
{
    serverIndex = index_;

	NSArray* data = [ServerData getServerDataAtIndex: serverIndex];
    NSLog(@"Server %d Data array: %@", serverIndex, data);
    
	self.title = [data objectAtIndex:0];
    if (self.title.length < 1)
    {
        self.title = @"noname server";
    }
    
    [conn close];
    conn = [[ServerConnection alloc] initWithDelegate: self];
    [conn initNetworkCommunication:[NSString stringWithFormat:@"%@", [data objectAtIndex:1]]
                              port:[[NSString stringWithFormat:@"%@", [data objectAtIndex:2]] intValue]
                          password:[NSString stringWithFormat:@"%@", [data objectAtIndex:3]]];
}

- (void)serverDataAvailable
{
    NSString* map = [conn getVar:@"mapname"];
    
    if( map.length < 1 )
    {
        map = @"<between maps>";
    }

    self.mapName.text = map;
    
    [playerList reloadData];
}

#pragma mark - Editing modes

- (void) startEditing: (id) sender
{
    [self setEditingButtonState:YES];

    editor = [[EditServerViewController alloc ] initWithNibName: @"EditServerViewController" 
                                                         bundle: [NSBundle mainBundle]];
    editor.delegate = self;
    editor.serverIndex = serverIndex;
    [self presentViewController: editor
                       animated: YES
                     completion: nil];

}

- (void) stopEditing: (BOOL) deleted
{
    [self setEditingButtonState:NO];
    [self dismissViewControllerAnimated:YES
                             completion:nil];
    
    if (YES == deleted) 
    {
        [[self navigationController] popToRootViewControllerAnimated:YES];
    }
    else
    {
        // force a refresh
        [self setIndex: serverIndex];
    }
}

- (void) setEditingButtonState: (BOOL) editing
{
    if (YES == editing) 
    {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc ] initWithBarButtonSystemItem: UIBarButtonSystemItemDone 
                                                                                                 target: self 
                                                                                                 action: @selector(stopEditing:)];
    }
    else
    {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc ] initWithBarButtonSystemItem: UIBarButtonSystemItemEdit 
                                                                                                 target: self 
                                                                                                 action: @selector(startEditing:)];
    }
}

#pragma mark -
#pragma mark Table view data source

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
    return conn.players.count;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    static NSString *CellIdentifier = @"PlayerCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    if (cell == nil) 
	{
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    
	// Configure the cell.    
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
               
	cell.textLabel.text = [conn getPlayerAtrib:paName
                                         index:indexPath.row];
    
	cell.detailTextLabel.text = [conn getPlayerAtrib:paScore
                                               index:indexPath.row];
	
    return cell;
}

@end

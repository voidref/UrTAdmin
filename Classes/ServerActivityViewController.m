//
//  ServerViewController.m
//  UrTAdmin
//
//  Created by Alan Westbrook on 9/6/11.
//  Copyright 2011 Rockwood Software. All rights reserved.
//

#import "ServerActivityViewController.h"
#import "ServerData.h"

@implementation ServerActivityViewController

@synthesize conn;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _serverIndex = -1;
    }

    return self;
}

- (void)dealloc
{
    [self reset];
}

- (void) reset
{
    self.mapName    = nil;
    self.conn       = nil;
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
}

- (void)viewDidUnload
{
    [self reset];
        
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)setServerIndex: (NSUInteger)index_
{
    _serverIndex = index_;

	NSArray* data = [ServerData getServerDataAtIndex: _serverIndex];
    NSLog(@"Server %d Data array: %@", _serverIndex, data);
    
	self.title = [data objectAtIndex:0];
    if (self.title.length < 1)
    {
        self.title = @"noname server";
    }
    
    [self.conn close];
    self.conn = [[ServerConnection alloc] initWithDelegate: self];
    [self.conn initNetworkCommunication:[NSString stringWithFormat:@"%@", [data objectAtIndex:1]]
                              port:[[NSString stringWithFormat:@"%@", [data objectAtIndex:2]] intValue]
                          password:[NSString stringWithFormat:@"%@", [data objectAtIndex:3]]];
}

- (void)serverDataAvailable
{
    NSString* map = [self.conn getVar:@"mapname"];
    
    if( map.length < 1 )
    {
        map = @"<between maps>";
    }

    self.mapName = map;
    
    [self.tableView reloadData];
}


#pragma mark -
#pragma mark Table view data source

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
    return 2;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
    NSInteger result = 0;

    switch (section)
    {
        case 0:
            result = 1;
            break;
            
        case 1:
            result = conn.players.count;
            break;
    }
    
    return result;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    static NSString* playerCellIdentifier   = @"PlayerCell";
    static NSString* mapCellIdentifier      = @"MapCell";
    
    NSString* cellId = playerCellIdentifier;
    NSString* label  = nil;
    NSString* detail = nil;
    
    if (0 == indexPath.section)
    {
        cellId = mapCellIdentifier;
        label  = @"Map";
        detail = self.mapName;
    }
    else
    {
        label = [self.conn getPlayerAtrib:paName
                                    index:indexPath.row];
        
        detail = [self.conn getPlayerAtrib:paScore
                                     index:indexPath.row];
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];

    if (cell == nil) 
	{
        NSLog(@" ** Error: should not get here, xib is busticated");
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
    }
    
	cell.textLabel.text         = label;
	cell.detailTextLabel.text   = detail;
	
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString* result = nil;
    
    if ((1 == section) && (conn.players.count > 0))
    {
        result = @"Players";
    }
    
    return result;
}

@end

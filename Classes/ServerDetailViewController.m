//
//  ServerDetailViewController.m
//  UrTAdmin
//
//  Created by Alan Westbrook on 3/25/13.
//  Copyright (c) 2013 Rockwood Software. All rights reserved.
//

#import "ServerDetailViewController.h"
#import "ServerData.h"

@interface ServerDetailViewController ()

@end

@implementation ServerDetailViewController

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

    NSArray* data = [ServerData getServerDataAtIndex: _serverIndex];
    
    [self setDetails: data];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Cell Data

- (void) setDetails: (NSArray*) data_
{
    // TODO: Really, change to using CoreData, these literals suck.
    self.name.text       = data_[0];
    self.address.text    = data_[1];
    self.port.text       = data_[2];
    self.password.text   = data_[3];
}

#pragma mark - Cell Delegate


- (void) inlineEditTableViewCell: (InlineEditTableViewCell *)cell_
                 propertyUpdated: (NSString *)property_
                           value: (NSString *)value_
{
    // Yes, we are checking pointers here as they will be identical
    if (kDetailTextProperty == property_)
    {
        NSMutableArray* data = [[ServerData getServerDataAtIndex: _serverIndex] mutableCopy];

        // This could be tricky, need to keep the tags synchronized.
        data[cell_.tag] = value_;

        // This does cause a lot (4 updates, in this case) of data churn because we still haven't changed over to using CoreData
        [ServerData setServerData: data
                          atIndex: _serverIndex];
        [self setDetails: data];
}
}

#pragma mark - Table view delegate

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleNone;
}

@end

//
//  ServerDetailViewController.h
//  UrTAdmin
//
//  Created by Alan Westbrook on 3/25/13.
//  Copyright (c) 2013 Rockwood Software. All rights reserved.
//

#import "ServerViewController.h"
#import "InlineEditTableViewCell.h"

@interface ServerDetailViewController : UITableViewController<ServerViewController,
                                                              InlineEditTableViewCellDelegate>

@property (assign, nonatomic)            NSInteger serverIndex;
@property (weak)                IBOutlet UILabel*  name;
@property (weak)                IBOutlet UILabel*  address;
@property (weak)                IBOutlet UILabel*  port;
@property (weak)                IBOutlet UILabel*  password;

@end

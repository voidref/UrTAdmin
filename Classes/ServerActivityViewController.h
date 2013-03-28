//
//  ServerViewController.h
//  UrTAdmin
//
//  Created by Alan Westbrook on 9/6/11.
//  Copyright 2011 Rockwood Software. All rights reserved.
//

#import "ServerConnection.h"
#import "ServerViewController.h"

@interface ServerActivityViewController : UITableViewController <ServerConnectionDelegate,
                                                                 UITableViewDataSource,
                                                                 ServerViewController>
{
    NSUInteger                  _serverIndex;
}

@property (strong)              NSString*           mapName;
@property (nonatomic, strong)   ServerConnection*   conn;

- (void) dealloc;
- (void) reset;

- (void) setServerIndex:        (NSUInteger)    index_;

- (void) serverDataAvailable;


@end

//
//  ServerViewController.h
//  UrTAdmin
//
//  Created by Alan Westbrook on 9/6/11.
//  Copyright 2011 Rockwood Software. All rights reserved.
//

#import "ServerConnection.h"
#import "EditServerViewController.h"
#import "ServerViewController.h"

@interface ServerActivityViewController : UITableViewController <ServerConnectionDelegate,
                                                                 UITableViewDataSource,
                                                                 ServerViewController>
{
    EditServerViewController*   _editor;
    NSUInteger                  _serverIndex;
}

@property (strong)              NSString*           mapName;
@property (nonatomic, strong)   ServerConnection*   conn;

- (void) dealloc;
- (void) reset;

- (void) setServerIndex:        (NSUInteger)    index_;

- (void) startEditing:          (id)            sender_;
- (void) stopEditing:           (BOOL)          editing_;
- (void) setEditingButtonState: (BOOL)          editing_;

- (void) serverDataAvailable;


@end

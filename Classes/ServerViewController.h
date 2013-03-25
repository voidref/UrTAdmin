//
//  ServerViewController.h
//  UrTAdmin
//
//  Created by Alan Westbrook on 9/6/11.
//  Copyright 2011 Voidref Software. All rights reserved.
//

#import "ServerConnection.h"
#import "EditServerViewController.h"

@interface ServerViewController : UITableViewController <ServerConnectionDelegate, UITableViewDataSource>
{
    NSString*                   _mapName;
    ServerConnection*           conn;
    EditServerViewController*   editor;
    uint32_t                    serverIndex;
}

@property (weak) IBOutlet     UILabel*            mapName;
@property (nonatomic, strong)   ServerConnection*   conn;

- (void) dealloc;
- (void) reset;

- (void) setIndex: (uint32_t)index;

- (void) startEditing: (id) sender;
- (void) stopEditing: (BOOL) editing;
- (void) setEditingButtonState: (BOOL) editing;

- (void) serverDataAvailable;


@end

//
//  ServerViewController.h
//  UrTAdmin
//
//  Created by Alan Westbrook on 9/6/11.
//  Copyright 2011 Voidref Software. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ServerConnection.h"
#import "EditServerViewController.h"

@interface ServerViewController : UIViewController <ServerConnectionDelegate, UITableViewDataSource, EditServerViewControllerDelegate> 
{
    UILabel*                    __weak mapName;
    UITableView*                __weak playerList;
    ServerConnection*           conn;
    EditServerViewController*   editor;
    uint32_t                    serverIndex;
}

@property (weak) IBOutlet     UILabel*            mapName;
@property (weak) IBOutlet     UITableView*        playerList;
@property (nonatomic, strong)   ServerConnection*   conn;

- (void) dealloc;
- (void) reset;

- (void) setIndex: (uint32_t)index;

- (void) startEditing: (id) sender;
- (void) stopEditing: (BOOL) editing;
- (void) setEditingButtonState: (BOOL) editing;

- (void) serverDataAvailable;


@end

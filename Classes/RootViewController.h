//
//  RootViewController.h
//  UrTAdmin
//
//  Created by Alan Westbrook on 6/12/10.
//  Copyright Rockwood Software 2010. All rights reserved.
//

@class AddServerController;
@class ServerViewController;
@class EditServerViewController;

@interface RootViewController : UITableViewController <UINavigationControllerDelegate>
{
	AddServerController*        addServer;
    
    ServerViewController*       current;
    EditServerViewController*   editor;
}

@property (nonatomic) ServerViewController* current;

- (IBAction)    createNewServer:    (id) sender;

@end

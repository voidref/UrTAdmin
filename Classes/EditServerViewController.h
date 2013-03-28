//
//  EditServerViewController.h
//  UrTAdmin
//
//  Created by Alan Westbrook on 9/10/11.
//  Copyright (c) 2011 Voidref Software. All rights reserved.
//

#import "ServerViewController.h"

@interface EditServerViewController : UIViewController<ServerViewController>
{
	UITextField*		__weak serverName;
	UITextField*		__weak serverIP;
	UITextField*		__weak serverPort;
	UITextField*		__weak serverPassword;
	UIBarButtonItem*	__weak confirmButton;
    UIButton*           __weak deleteServer;

    id                  __weak delegate;
}


@property (weak) IBOutlet UITextField*		serverName;
@property (weak) IBOutlet UITextField*		serverIP;
@property (weak) IBOutlet UITextField*		serverPort;
@property (weak) IBOutlet UITextField*		serverPassword;
@property (weak) IBOutlet UIBarButtonItem*	confirmButton;
@property (weak) IBOutlet UIButton*         deleteServer;

@property (assign)        NSUInteger        serverIndex;
@property (weak)          id                delegate;

- (IBAction) deleteServer:      (id)sender_;
- (IBAction) confirmChanges:    (id)sender_;
- (IBAction) cancel:            (id)sender_;

@end


@protocol EditServerViewControllerDelegate <NSObject>

- (void) stopEditing;

@end 

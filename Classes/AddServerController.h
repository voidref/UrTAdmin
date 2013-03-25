//
//  AddServerController.h
//  UrTAdmin
//
//  Created by Alan Westbrook on 6/13/10.
//  Copyright 2010 Rockwood Software. All rights reserved.
//

#import "ServerConnection.h"

@interface AddServerController : UIViewController <UITextFieldDelegate, ServerConnectionDelegate> 
{
    ServerConnection*   conn;

	__weak IBOutlet UITextField*                serverName;
	__weak IBOutlet UITextField*                serverIP;
	__weak IBOutlet UITextField*                serverPort;
	__weak IBOutlet UITextField*                serverPassword;
	__weak IBOutlet UIBarButtonItem*            confirmButton;
    __weak IBOutlet UIActivityIndicatorView*    serverNameSpinner;
}

- (IBAction) cancelAdd: (id) sender_;
- (IBAction) confirmAdd: (id) sender_;

- (BOOL)textFieldShouldReturn:(UITextField *)textField;              // called when 'return' key pressed. return NO to ignore.
- (void)textFieldDidEndEditing:(UITextField *)textField;

@end

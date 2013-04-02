//
//  AddServerController.h
//  UrTAdmin
//
//  Created by Alan Westbrook on 6/13/10.
//  Copyright 2010 Rockwood Software. All rights reserved.
//

#import "ServerConnection.h"
#import "InlineEditTableViewCell.h"

@interface AddServerController : UIViewController <UITextFieldDelegate,
                                                   ServerConnectionDelegate,
                                                   InlineEditTableViewCellDelegate,
                                                   UITableViewDataSource>
{
    ServerConnection*                           _conn;

	__weak IBOutlet UIBarButtonItem*            _confirmButton;
    __strong        UIActivityIndicatorView*    _serverNameSpinner;
    __weak IBOutlet UITableView*                _tableView;
    
                    InlineEditTableViewCell*    _name;
                    InlineEditTableViewCell*    _address;
                    InlineEditTableViewCell*    _port;
                    InlineEditTableViewCell*    _password;
}

- (IBAction) cancelAdd:     (id) sender_;
- (IBAction) confirmAdd:    (id) sender_;

- (BOOL)textFieldShouldReturn:  (UITextField *) textField_;              // called when 'return' key pressed. return NO to ignore.

@end

//
//  EditServerViewController.h
//  UrTAdmin
//
//  Created by Alan Westbrook on 9/10/11.
//  Copyright (c) 2011 Voidref Software. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditServerViewController : UIViewController
{
	UITextField*		__weak serverName;
	UITextField*		__weak serverIP;
	UITextField*		__weak serverPort;
	UITextField*		__weak serverPassword;
	UIBarButtonItem*	__weak confirmButton;
    UIButton*           __weak deleteServer;

    uint32_t                   serverIndex;
    id                  __weak delegate;
}


@property (weak) IBOutlet UITextField*		serverName;
@property (weak) IBOutlet UITextField*		serverIP;
@property (weak) IBOutlet UITextField*		serverPort;
@property (weak) IBOutlet UITextField*		serverPassword;
@property (weak) IBOutlet UIBarButtonItem*	confirmButton;
@property (weak) IBOutlet UIButton*         deleteServer;

@property (assign)          uint32_t        serverIndex;
@property (weak)            id              delegate;

- (IBAction) deleteServer: (id)sender;
- (IBAction) confirmChanges: (id)sender;

@end


@protocol EditServerViewControllerDelegate <NSObject>

- (void) stopEditing: (BOOL) deleted;

@end 

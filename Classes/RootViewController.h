//
//  RootViewController.h
//  UrTAdmin
//
//  Created by Alan Westbrook on 6/12/10.
//  Copyright Rockwood Software 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AddServerController;
@class ServerViewController;

@interface RootViewController : UITableViewController <UINavigationControllerDelegate> {
	AddServerController*	addServer;
	int						serverCount;
    
    ServerViewController*   current;
}

@property (nonatomic) ServerViewController* current;

- (IBAction)    createNewServer:    (id) sender;

@end

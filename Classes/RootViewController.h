//
//  RootViewController.h
//  UrTAdmin
//
//  Created by Alan Westbrook on 6/12/10.
//  Copyright Rockwood Software 2010. All rights reserved.
//

@class AddServerController;
@class ServerActivityViewController;
@class EditServerViewController;

@interface RootViewController : UITableViewController <UINavigationControllerDelegate>
{
}

@property (nonatomic, retain) IBOutlet  UIView *                noServersView;
@property (nonatomic, retain) IBOutlet  UITableView*            cachedTV;
@end

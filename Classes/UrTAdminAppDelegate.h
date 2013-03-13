//
//  UrTAdminAppDelegate.h
//  UrTAdmin
//
//  Created by Alan Westbrook on 6/12/10.
//  Copyright Rockwood Software 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NewServerController;

@interface UrTAdminAppDelegate : NSObject <UIApplicationDelegate> {
    
    UIWindow *window;
    UINavigationController *navigationController;
	NewServerController* newServer;
}

@property (nonatomic, strong) IBOutlet UIWindow *window;
@property (nonatomic, strong) IBOutlet UINavigationController *navigationController;


@end


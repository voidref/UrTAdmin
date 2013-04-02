//
//  main.m
//  UrTAdmin
//
//  Created by Alan Westbrook on 6/12/10.
//  Copyright Rockwood Software 2010. All rights reserved.
//

#import "UrTAdminAppDelegate.h"

int main(int argc, char *argv[]) {
    
    @autoreleasepool
    {
        int retVal = 1;
        @try
        {
            retVal = UIApplicationMain(argc, argv, nil, NSStringFromClass([UrTAdminAppDelegate class]));
        }
        @catch (NSException* e_)
        {
            NSLog(@" ** Exception Thrown: %@", e_);
            NSLog(@"Stack: %@", [e_ callStackSymbols]);
        }
        
        return retVal;
    }
}

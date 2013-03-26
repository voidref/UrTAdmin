//
//  EditServerViewController.m
//  UrTAdmin
//
//  Created by Alan Westbrook on 9/10/11.
//  Copyright (c) 2011 Voidref Software. All rights reserved.
//

#import "EditServerViewController.h"
#import "ServerData.h"
#import "ServerViewController.h"

@implementation EditServerViewController

@synthesize serverName;
@synthesize serverIP;
@synthesize serverPort;
@synthesize serverPassword;
@synthesize confirmButton;
@synthesize deleteServer;

@synthesize serverIndex;
@synthesize delegate;



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.serverIndex = -1;
    }
    return self;
}



- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}



#pragma mark - View lifecycle

- (void)viewDidLoad
{
    NSAssert(self.serverIndex != -1, @"Must set server index before showing view.");

    [super viewDidLoad];
    
    [self.deleteServer setBackgroundImage:[[UIImage imageNamed:@"delete_button.png"]
                              stretchableImageWithLeftCapWidth:8
                                                  topCapHeight:8]
                                 forState:UIControlStateNormal];
    
    [self.deleteServer setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.deleteServer.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    self.deleteServer.titleLabel.shadowColor = [UIColor lightGrayColor];
    self.deleteServer.titleLabel.shadowOffset = CGSizeMake(0, -1);
    
    // Set all the current data from the server
    NSUserDefaults* defs = [NSUserDefaults standardUserDefaults];
    NSString* key = [NSString stringWithFormat:@"Server %d", serverIndex];
	NSArray* data = [defs stringArrayForKey: key];
	NSLog(@"Server %d", self.serverIndex);
    
    serverName.text = [NSString stringWithFormat:@"%@", [data objectAtIndex:0]];
    serverIP.text = [NSString stringWithFormat:@"%@", [data objectAtIndex:1]];
    serverPort.text = [NSString stringWithFormat:@"%@", [data objectAtIndex:2]];
    serverPassword.text = [NSString stringWithFormat:@"%@", [data objectAtIndex:3]];
}



- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
    self.deleteServer = nil;
    self.serverName = nil;
    self.serverIP = nil;
    self.serverPort = nil;
    self.serverPassword = nil;
    self.confirmButton = nil;
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}



- (IBAction) deleteServer:(id)sender
{
    [ServerData deleteServerAtIndex: self.serverIndex];

    [delegate stopEditing];
}


- (IBAction) confirmChanges:(id)sender
{
	NSArray* data = [NSArray arrayWithObjects:  self.serverName.text,
                                                self.serverIP.text,
                                                self.serverPort.text,
                                                self.serverPassword.text,
                                                nil];

    [ServerData setServerData: data 
                      atIndex: self.serverIndex];
    
    [delegate stopEditing];    
}

- (IBAction) cancel:(id)sender
{
    [delegate stopEditing];
}

@end

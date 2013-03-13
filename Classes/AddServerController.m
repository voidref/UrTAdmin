//
//  AddServerController.m
//  UrTAdmin
//
//  Created by Alan Westbrook on 6/13/10.
//  Copyright 2010 Rockwood Software. All rights reserved.
//

#import "AddServerController.h"
#import "ServerData.h"
 
@implementation AddServerController


//------------------------------------------------------------------------------------------------
// The designated initializer.  
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil 
{
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) 
	{
        // Custom initialization
        
        conn = nil;
    }
	
    return self;
}


/*
 // ------------------------------------------------------------------------------------------------
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/


// ------------------------------------------------------------------------------------------------
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad 
{
    [super viewDidLoad];
	
	serverName.delegate = self;
	serverIP.delegate = self;
	serverPort.delegate = self;
	serverPassword.delegate = self;
}


// ------------------------------------------------------------------------------------------------
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation 
{
    // Return YES for supported orientations
    return YES;
}

// ------------------------------------------------------------------------------------------------
- (void)didReceiveMemoryWarning 
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

// ------------------------------------------------------------------------------------------------
- (void)viewDidUnload 
{
    [super viewDidUnload];

    serverName = nil;
    serverIP = nil;
    serverPort = nil;
    serverPassword = nil;
    confirmButton = nil;
    
    conn = nil;
}


// ------------------------------------------------------------------------------------------------
- (void)dealloc 
{
    conn = nil;
    
}

// ------------------------------------------------------------------------------------------------
- (IBAction) cancelAdd
{
	[self dismissViewControllerAnimated:YES completion:nil];
}

// ------------------------------------------------------------------------------------------------
- (IBAction) confirmAdd
{
    [conn close];
    conn = nil;
    
	NSArray* array = [NSArray arrayWithObjects: serverName.text,
					                            serverIP.text,
												serverPort.text,
												serverPassword.text,
												nil];
	
    [ServerData addServer: array];
    
	[self dismissViewControllerAnimated:YES completion: nil];
}

// ------------------------------------------------------------------------------------------------
- (IBAction) verifyServer
{
	
}

// ------------------------------------------------------------------------------------------------
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	// What I want here is a switch, or a 'nextFocusObject' method I can use.
	if (serverName == textField)
	{
		[serverIP becomeFirstResponder];
	}
	else if (serverIP == textField)
	{
		[serverPort becomeFirstResponder];
	}
	else if (serverPort == textField)
	{
		[serverPassword becomeFirstResponder];
	}
	else 
	{
		[textField resignFirstResponder];
	}

	NSLog(@"Should return for %@", textField.text);
	
	return NO;
}

// ------------------------------------------------------------------------------------------------
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    NSLog(@"%s: %@", __PRETTY_FUNCTION__, textField.text);
	BOOL enabled = confirmButton.enabled;
    
	// It at least needs to look like an IP address
	if (serverIP == textField) 
	{
		NSString* ip = serverIP.text;
		if ([ip length] != 0 ) 
		{
			NSArray* components = [ip componentsSeparatedByString:@"."];
			int count = components.count;
			if (4 == count) 
			{
				enabled = YES;
				
				for (int i = 0; i < 4; ++i) 
				{
					if ([[components objectAtIndex:i] length] < 1) 
					{
						enabled = NO;
						break;
					}
				}
			}
		}
	}
    else if (serverPort == textField)
    {
        NSInteger port = [serverPort.text intValue];
    
        if ((port < 1) || (port > USHRT_MAX)) 
        {
            enabled = NO;
        }
        else
        {
            // Force a refresh
            serverName.text = @"";
        }
    }
	
	[confirmButton setEnabled:enabled];
	
	if ((YES == enabled) && (serverName.text.length < 1)) 
	{
        [serverNameSpinner startAnimating];
        [conn close];
        conn = [[ServerConnection alloc] initWithDelegate: self];
        [conn initNetworkCommunication:serverIP.text
                                  port:[serverPort.text intValue]
                              password:@""];
    }
}


#pragma mark -
#pragma mark SeverConnection Delegate

- (void) serverDataAvailable
{
    [serverNameSpinner stopAnimating];
    serverName.text = [conn getVar:@"sv_hostname"];
    
    [conn close];
    
    conn = nil;
}

@end

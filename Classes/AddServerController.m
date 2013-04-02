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

static const NSInteger skAddressRow     = 0;
static const NSInteger skPortRow        = 1;
static const NSInteger skPasswordRow    = 2;
static const NSInteger skNameRow        = 3;
static       NSString* skStandardCellId = @"Sandard";
static       NSString* skSpinnerCellId  = @"Spinner";

static       NSString* skAddressLabel   = @"Address";
static       NSString* skPortLabel      = @"Port";
static       NSString* skPasswordLabel  = @"Password";
static       NSString* skNameLabel      = @"Name";

static       NSString* skStandardPort   = @"27960";



//------------------------------------------------------------------------------------------------
// The designated initializer.  
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil 
{
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) 
	{
        // Custom initialization
        
        _conn = nil;
    }
	
    return self;
}


// ------------------------------------------------------------------------------------------------
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad 
{
    [super viewDidLoad];
	
	_name.editor.delegate = self;
	_address.editor.delegate = self;
	_port.editor.delegate = self;
	_password.editor.delegate = self;
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    _tableView.editing = YES;
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

    [_conn close];
}


// ------------------------------------------------------------------------------------------------
- (void)dealloc 
{
    [_conn close];
}

// ------------------------------------------------------------------------------------------------
- (IBAction) cancelAdd: (id) sender_
{
	[self dismissViewControllerAnimated:YES completion:nil];
}

// ------------------------------------------------------------------------------------------------
- (IBAction) confirmAdd: (id) sender_
{
    [_conn close];
    _conn = nil;
    
    if (nil == _password.textLabel.text)
    {
        _password.textLabel.text = @"";
    }
    
    if (0 == _name.textLabel.text.length)
    {
        _name.textLabel.text = _name.editor.text;
    }
    
	NSArray* array = [NSArray arrayWithObjects: _name.textLabel.text,
					                            _address.textLabel.text,
												_port.textLabel.text,
												_password.textLabel.text,
												nil];
	
    [ServerData addServer: array];
    
	[self dismissViewControllerAnimated:YES completion: nil];
}

// ------------------------------------------------------------------------------------------------
- (BOOL)textFieldShouldReturn:(UITextField *)textField_
{
    InlineEditTableViewCell* cell = nil;
    
	// What I want here is a switch, or a 'nextFocusObject' method I can use.
	if (_address.editor == textField_)
	{
		[_port.editor becomeFirstResponder];
        _address.textLabel.text = textField_.text;
    
        cell = _address;
	}
	else if (_port.editor == textField_)
	{
		[_password.editor becomeFirstResponder];
        _port.textLabel.text = textField_.text;
        
        cell = _port;
	}
    else if (_password.editor == textField_)
	{
		[_name.editor becomeFirstResponder];
        _password.textLabel.text = textField_.text;
        
        cell = _password;
	}
	else 
	{
        _name.textLabel.text = textField_.text;

        cell = _name;
        
        if (textField_.text.length > 0)
        {
            [textField_ resignFirstResponder];
            
            [self confirmAdd:nil];
        }
        else
        {
            [_address.editor becomeFirstResponder];
        }
	}

    // Bit of a hack
    [self inlineEditTableViewCell: cell
                  propertyUpdated: nil
                            value: textField_.text];

    
	return NO;
}

- (void) inlineEditTableViewCell: (InlineEditTableViewCell*) cell_
                 propertyUpdated: (NSString*)                property_
                           value: (NSString*)                value_
{
	BOOL enabled = _confirmButton.enabled;
    
	// It at least needs to look like an IP address
	if (_address == cell_)
	{
		NSString* ip = value_;
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
    else if (_port == cell_)
    {
        NSInteger port = [value_ intValue];
        
        if ((port < 1) || (port > USHRT_MAX))
        {
            enabled = NO;
        }
        else
        {
            // Force a refresh
            _name.editor.text = @"";
        }
    }
	
    if (_name.textLabel.text.length < 1)
    {
        enabled = NO;
    }
    
	[_confirmButton setEnabled:enabled];
	
	if ((YES == enabled) && (_name.editor.text.length < 1))
	{
        [_serverNameSpinner startAnimating];
        [_conn close];
        _conn = [[ServerConnection alloc] initWithDelegate: self];
        [_conn initNetworkCommunication: _address.editor.text
                                   port: [_port.editor.text intValue]
                               password:@""];
    }
}

- (InlineEditTableViewCell*) customizeCellWithIdentifier: (NSString*) cellId_
                                                   label: (NSString*) label_
{
    InlineEditTableViewCell* result = [_tableView dequeueReusableCellWithIdentifier:cellId_];

    if (nil == result)
    {
        // THere seems to be a bug when you have a UITableView in a storyboard without a UITableViewController
        // which breaks the dequeueResuableCellWithIdentifier call so that it NEVER works.
        
        result = [[InlineEditTableViewCell alloc] initWithStyle: UITableViewCellStyleDefault
                                                reuseIdentifier: cellId_];
    }
    
    result.editor.delegate      = self;
    result.editor.placeholder   = label_;
    
    return result;
}

#pragma mark -
#pragma mark SeverConnection Delegate

- (void) serverDataAvailable
{
    [_serverNameSpinner stopAnimating];
    _name.editor.text = [_conn getVar:@"sv_hostname"];
    _name.textLabel.text = _name.editor.text;
    
    [_conn close];
    
    _conn = nil;
}

#pragma mark - UITableViewDataSourceDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    InlineEditTableViewCell* result = nil;
    
    switch (indexPath.row)
    {
        case skAddressRow:
            result =
            _address = [self customizeCellWithIdentifier: skStandardCellId
                                                   label: skAddressLabel];
            break;

        case skPortRow:
            result =
            _port = [self customizeCellWithIdentifier: skStandardCellId
                                                label: skPortLabel];
            _port.textLabel.text = skStandardPort;
            break;

        case skPasswordRow:
            result =
            _password = [self customizeCellWithIdentifier: skStandardCellId
                                                    label: skPasswordLabel];
            break;

        case skNameRow:
            result =
            _name = [self customizeCellWithIdentifier: skSpinnerCellId
                                                label: skNameLabel];
            _serverNameSpinner = [UIActivityIndicatorView new];
            _name.accessoryView = _serverNameSpinner;
            break;

        default:
            break;
    }
    
    return result;
}

#pragma mark - Table View Delegte

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleNone;
}

@end

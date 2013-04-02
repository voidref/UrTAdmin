//
//  ServerConnection.cpp
//  
//
//  Created by Alan Westbrook on 9/6/11.
//  Copyright 2011 Rockwood Software. All rights reserved.
//

#import "ServerConnection.h"
#import "AsyncUdpSocket.h"

   
#pragma mark ServerConnection

@implementation ServerConnection

static const char*          skPrefix        = "\xff\xff\xff\xff";
static const long           skSocketTag     = 42;
static const NSTimeInterval skSocketTimeout = 100;


- (id) initWithDelegate: (id)delegate_
{
    if((self = [super init]))
	{
        _delegate = delegate_;
        _players = nil;
        _statusPoller = nil;
        _socket = nil;
    }
    
    return self;
}

- (void) dealloc
{
    [self close];
}

- (void) close
{
    _delegate = nil;
    [_statusPoller invalidate];
    _statusPoller = nil;
    [_socket close];
    _socket = nil;
}

- (void) initNetworkCommunication:(NSString*)host_
                             port:(UInt16)port_ 
                         password:(NSString*)password_ 
{
	NSLog(@"%s %@ host: %@, port %d", __PRETTY_FUNCTION__, self, host_, port_);

    self.password = password_;
    _socket = [[AsyncUdpSocket alloc] initWithDelegate:self];
    BOOL connected = 
    [_socket connectToHost: host_
                    onPort: port_
                     error: nil];
    
    
    NSLog(@"Setup done (%@)", connected ? @"YES" : @"NO");
    
    [self getStatus:nil];
    [self setupPoller];
}

- (void) setupPoller
{
	_statusPoller = [NSTimer scheduledTimerWithTimeInterval:10
													target:self
												  selector:@selector(getStatus:)
												  userInfo:nil
												   repeats:YES];
}

- (void) getStatus: (NSTimer*)theTimer
{
    [self sendMessage:@"getstatus"];
}

- (void) sendMessage : (NSString*)message_
{	
    NSLog(@"%@ Sending message: %@", self, message_);
	NSMutableData *data = [[NSMutableData alloc] initWithBytes:skPrefix 
                                                         length:sizeof(skPrefix)];
                           
    [data appendBytes:message_.UTF8String length:message_.length];
    
    BOOL result = 
    [_socket sendData: data
         withTimeout: skSocketTimeout
                 tag: skSocketTag];
    
    NSLog(@"Sent off request (%@)", result ? @"YES" : @"NO");
    
    [_socket receiveWithTimeout: skSocketTimeout
                           tag: skSocketTag];
}

- (void) rcon:(NSString *)command_
{
    NSString* message = [NSString stringWithFormat:@"rcon %@ %@", self.password, command_];
    
    [self sendMessage: message];
}

- (NSString*) getVar:(NSString*)name_
{
    NSUInteger index = [self.cvars indexOfObject:name_];
    NSString* result = [self cleanURTName:[self.cvars objectAtIndex:index + 1]];
    return result;
}

- (NSString*) getPlayerAttribute:(PlayerAttribute)attrib_
                         atIndex:(NSUInteger)index_
{
    return _players[index_][attrib_];   
}


- (BOOL)onUdpSocket: (AsyncUdpSocket *)sock 
     didReceiveData: (NSData *)data_ 
            withTag: (long)tag_ 
           fromHost: (NSString *)host_ 
               port: (UInt16)port_
{
    // The first 4 bytes are the magic number, which is MAXINT, so whack them off
    NSRange range;
    range.location = 4;
    range.length = data_.length - range.location - 1;
    
    NSString* response = [[NSString alloc] initWithBytes: ([data_ subdataWithRange:range].bytes)
                                                  length: range.length
                                                encoding: NSUTF8StringEncoding];
    
    // Eventually put a switch statement in here using the tag to process the responses appropriately
    
    NSArray* parts = [response componentsSeparatedByString:@"\n"];
    
    // The first part is always which response this is to, but we should know that from our tag anyway.
    self.cvars = [[parts objectAtIndex:1] componentsSeparatedByString:@"\\"];
    
    if (parts.count > 2)
    {
        NSRange range;
        range.location = 2;
        range.length = parts.count - range.location;
        
        _players = [NSMutableArray arrayWithCapacity: range.length];
        for (NSString* playerData in [parts subarrayWithRange:range])
        {
            NSMutableArray* playerArray = [NSMutableArray arrayWithCapacity: (NSUInteger)paEnd];
            NSString* name  = [playerData substringFromIndex:[playerData rangeOfString:@"\""].location];
            name            = [name substringToIndex: name.length - 1];
            [playerArray addObject: [self cleanURTName: name]];

            [playerArray addObject: [[playerData componentsSeparatedByString:@" "] objectAtIndex:0]];
            
            [_players addObject: playerArray];
        }
        
        [_players sortUsingComparator:^NSComparisonResult(NSArray* one_, NSArray* two_)
         {
             return [one_[paScore] compare:two_[paScore] options: NSNumericSearch];
         }];
    }
    else
    {
        // No players
        _players = nil;
    }
    
    if ([_delegate respondsToSelector:@selector(serverDataAvailable)])
    {
        [_delegate serverDataAvailable];
    }
    
    return YES;
}

/**
 * Called if an error occurs while trying to send a datagram.
 * This could be due to a timeout, or something more serious such as the data being too large to fit in a sigle packet.
 **/
- (void)            onUdpSocket: (AsyncUdpSocket *)sock 
          didNotSendDataWithTag: (long)tag_ 
                     dueToError: (NSError *)error_
{
    NSLog(@"Error sending: %@", [error_ localizedFailureReason]);
}


// This doesn't really belong here, but it's a convenient place for now
- (NSString*) cleanURTName:(NSString*)name_
{
    NSString* result = [name_ stringByReplacingOccurrencesOfString:@"\"" withString:@""];
    
    // Well, this is a little annoying
    static NSArray* colorTags = nil;
    if (nil == colorTags)
    {
        // cannot initialize statics with objc literals (yet?)
        colorTags = @[ @"^0", @"^1", @"^2", @"^3", @"^4", @"^5", @"^6", @"^7", @"^8", @"^9" ];
    }
    
    for (NSString* tag in colorTags)
    {
        result = [result stringByReplacingOccurrencesOfString:tag withString:@""];
    }
    
    return result;
}

- (NSArray*) players
{
    return _players;
}

@end
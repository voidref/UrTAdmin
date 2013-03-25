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

static const char* skPrefix = "\xff\xff\xff\xff";

@synthesize messages;
@synthesize password;
@synthesize cvars;
@synthesize players;

- (id) initWithDelegate: (id)delegate_
{
    if((self = [super init]))
	{
        delegate = delegate_;
        players = nil;
        statusPoller = nil;
        socket = nil;
    }
    
    return self;
}

- (void) dealloc
{
    NSLog(@"deallocing %@", self);
    [self close];

}

// I think ideally we would override release to free ourselves from being retained by the socket.
- (void) close
{
    delegate = nil;
    [statusPoller invalidate];
    statusPoller = nil;
    [socket close];
    socket = nil;
}

- (void) initNetworkCommunication:(NSString*)host_
                             port:(uint32_t)port_ 
                         password:(NSString*)password_ 
{
	NSLog(@"%s %@ host: %@, port %d", __PRETTY_FUNCTION__, self, host_, port_);

    self.password = password_;
    socket = [[AsyncUdpSocket alloc] initWithDelegate:self];
    BOOL connected = 
    [socket connectToHost: host_ 
                 onPort: port_
                  error: nil];
    
    
    NSLog(@"Setup done (%@)", connected ? @"YES" : @"NO");
    
    [self getStatus:nil];
    [self setupPoller];
}

- (void) setupPoller
{
	statusPoller = [NSTimer scheduledTimerWithTimeInterval:10
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
    [socket sendData:data 
         withTimeout:100 
                 tag:42];
    
    NSLog(@"Sent off request (%@)", result ? @"YES" : @"NO");
    
    [socket receiveWithTimeout:100 
                           tag:42];
}

- (void) rcon:(NSString *)command_
{
    NSString* message = [NSString stringWithFormat:@"rcon %@ %@", self.password, command_];
    
    [self sendMessage: message];
}

- (NSString*) getVar:(NSString*)name_
{
    NSUInteger index = [cvars indexOfObject:name_];
    NSString* result = [self cleanURTName:[cvars objectAtIndex:index + 1]];
    return result;
}

- (NSString*) getPlayerAtrib:(PlayerAttribute)attrib_
                       index:(uint32_t)index_
{
    NSString* playerdata = [players objectAtIndex:index_];
    
    NSString* result;
    
    switch(attrib_)
    {
        case paName:
            // Some names have spaced in them, so we grab the content between the quotes which go to the end of the data.
            result = [playerdata substringFromIndex:[playerdata rangeOfString:@"\""].location];
            result = [result substringToIndex:result.length - 1];
            result = [self cleanURTName:result];
            break;
            
        case paScore:
            result = [[playerdata componentsSeparatedByString:@" "] objectAtIndex:0];
            break;
    }
    
    return result;    
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
    
//    NSLog(@"Response: %@\n\n", response);
    
    NSArray* parts = [response componentsSeparatedByString:@"\n"];
    
    // The first part is always which response this is to, but we should know that from our tag anyway.
    self.cvars = [[parts objectAtIndex:1] componentsSeparatedByString:@"\\"];
    
    if (parts.count > 2) {
        NSRange range;
        range.location = 2;
        range.length = parts.count - range.location;
        self.players = [parts subarrayWithRange:range];
    }
    else
    {
        // No players
        self.players = nil;
    }
    
//    NSLog(@"players:\n%@", players);
    
    if ([delegate respondsToSelector:@selector(serverDataAvailable)])
    {
        [delegate serverDataAvailable];
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


// This doesn't really belong here, but it's a conveniant place for now
- (NSString*) cleanURTName:(NSString*)name_
{
    NSString* result = [name_ stringByReplacingOccurrencesOfString:@"\"" withString:@""];
    
    // We could do a for loop, but this is actually faster as we don't have to do any formatting
    result = [result stringByReplacingOccurrencesOfString:@"^1" withString:@""];
    result = [result stringByReplacingOccurrencesOfString:@"^2" withString:@""];
    result = [result stringByReplacingOccurrencesOfString:@"^3" withString:@""];
    result = [result stringByReplacingOccurrencesOfString:@"^4" withString:@""];
    result = [result stringByReplacingOccurrencesOfString:@"^5" withString:@""];
    result = [result stringByReplacingOccurrencesOfString:@"^6" withString:@""];
    result = [result stringByReplacingOccurrencesOfString:@"^7" withString:@""];
    result = [result stringByReplacingOccurrencesOfString:@"^8" withString:@""];
    
    return result;
}

@end
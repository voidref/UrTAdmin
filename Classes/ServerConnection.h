//
//  ServerConnection.h
//  
//
//  Created by Alan Westbrook on 9/6/11.
//  Copyright 2011 Rockwood Software. All rights reserved.
//

#ifndef _ServerConnection_h
#define _ServerConnection_h

#import "AsyncUdpSocket.h"


# pragma mark ServerConnection

enum PlayerAttribute 
{
    paName = 0,
    paScore,
    paEnd
};
typedef enum PlayerAttribute PlayerAttribute;

@interface ServerConnection : NSObject <AsyncUdpSocketDelegate>
{
                NSMutableArray*     _messages;
                AsyncUdpSocket*     _socket;
                NSString*           _password;
                NSArray*            _cvars;
    __strong    NSMutableArray*     _players;
                NSTimer*            _statusPoller;
                id                  _delegate;
	
}


@property (nonatomic, strong) NSMutableArray*   messages;
@property (nonatomic, strong) NSString*         password;
@property (nonatomic, strong) NSArray*          cvars;
@property (nonatomic, readonly) NSArray*          players;

- (id) initWithDelegate: (id)delegate_;
- (void) dealloc;
- (void) close;

- (void) initNetworkCommunication:(NSString*)   host_
                             port:(UInt16)      port_
                         password:(NSString*)   password_;
- (void) setupPoller;
- (void) getStatus: (NSTimer*)                  timer_;

- (void) sendMessage:(NSString*)                message_;

- (void) rcon:(NSString*)                       command_;

- (NSString*) getVar:(NSString*)                name_;
- (NSString*) cleanURTName:(NSString*)          name_;

- (NSString*) getPlayerAttribute:(PlayerAttribute)  attrib_
                         atIndex:(NSUInteger)       index_;

/**
 * Called when the socket has received the requested datagram.
 * 
 * Due to the nature of UDP, you may occasionally receive undesired packets.
 * These may be rogue UDP packets from unknown hosts,
 * or they may be delayed packets arriving after retransmissions have already occurred.
 * It's important these packets are properly ignored, while not interfering with the flow of your implementation.
 * As an aid, this delegate method has a boolean return value.
 * If you ever need to ignore a received packet, simply return NO,
 * and AsyncUdpSocket will continue as if the packet never arrived.
 * That is, the original receive request will still be queued, and will still timeout as usual if a timeout was set.
 * For example, say you requested to receive data, and you set a timeout of 500 milliseconds, using a tag of 15.
 * If rogue data arrives after 250 milliseconds, this delegate method would be invoked, and you could simply return NO.
 * If the expected data then arrives within the next 250 milliseconds,
 * this delegate method will be invoked, with a tag of 15, just as if the rogue data never appeared.
 * 
 * Under normal circumstances, you simply return YES from this method.
 **/
- (BOOL)onUdpSocket:(AsyncUdpSocket *)sock
     didReceiveData:(NSData *)data
            withTag:(long)tag
           fromHost:(NSString *)host
               port:(UInt16)port;

/**
 * Called if an error occurs while trying to send a datagram.
 * This could be due to a timeout, or something more serious such as the data being too large to fit in a sigle packet.
 **/
- (void)    onUdpSocket:(AsyncUdpSocket *)sock
  didNotSendDataWithTag:(long)tag
             dueToError:(NSError *)error;

@end

@protocol ServerConnectionDelegate

- (void) serverDataAvailable;

@end

#endif

//
//  SocketSvc.h
//  msse652
//
//  Created by echolush on 7/30/14.
//  Copyright (c) 2014 Matt Ozer. All rights reserved.
//

#import <Foundation/Foundation.h>
@class SocketSvc;

/**
 Protocol to retrieve sent messages
 */
@protocol SocketSvcDelegate <NSObject>
@optional
/**
 To get server received message
 */
- (void)gotMessage:(NSString *)msg;
@end

/**
 SocketSvc class - Connects to server using NSStream
 */
@interface SocketSvc : NSObject <NSStreamDelegate>

/** holds server's ip address */
@property (strong, nonatomic) NSString *host;
/** holds server's port */
@property (assign, nonatomic) int port;

/**
 * Delegate object for SocketSvcDelegate
 */
@property (nonatomic, unsafe_unretained) id <SocketSvcDelegate> delegate;
/**
 Connects to server
 */
- (void)connect;
/**
 Sends message
 @param msg
        message to send
 */
- (void)send:(NSString *)msg;
/**
 Retrieves data from connection and writes to string
 */
- (void)retrieve;
/**
 Closes connection and removes delegates
 */
- (void)disconnect;

@end

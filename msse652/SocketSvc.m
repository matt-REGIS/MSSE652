//
//  SocketSvc.m
//  msse652
//
//  Created by echolush on 7/30/14.
//  Copyright (c) 2014 Matt Ozer. All rights reserved.
//

#import "SocketSvc.h"

@interface SocketSvc()
// To retain input stream
@property (strong, nonatomic) NSInputStream *inputStream;
// To retain output stream
@property (strong, nonatomic) NSOutputStream *outputStream;
@end

@implementation SocketSvc

- (void)connect
{
    //readable stream object
    CFReadStreamRef readStream;
    //writable stream object
    CFWriteStreamRef writeStream;
    //Create the readable and writable stream connected to a particular host on given port
    CFStreamCreatePairWithSocketToHost(NULL, (__bridge CFStringRef)self.host, self.port, &readStream, &writeStream);
    //cast CFReadStreamRef to NSInputStream
    self.inputStream = (__bridge_transfer NSInputStream *)readStream;
    //cast CFWriteStreamRef to NSOutputStream
    self.outputStream = (__bridge_transfer NSOutputStream *)writeStream;

    //set delegates for NSStreamDelegate
    [self.inputStream setDelegate:self];
    [self.outputStream setDelegate:self];
    
    //Run-loop scheduling ensures that to get notifications when something happens on the stream.
    [self.inputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [self.outputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    //Open input stream
    [self.inputStream open];
    //Open output stream
    [self.outputStream open];
}

- (void)joinChat:(NSString *)name
{
    //Format string to tell server that it is a join command
    NSString *response  = [NSString stringWithFormat:@"iam:%@", name];
    //Create a data object initialized with strings contents
	NSData *data = [[NSData alloc] initWithData:[response dataUsingEncoding:NSASCIIStringEncoding]];
    //Write the contents of the data to buffer
	[self.outputStream write:[data bytes] maxLength:[data length]];
}

- (void)send:(NSString *)msg
{
    //Format string to tell server that it is a message command
    NSString *response  = [NSString stringWithFormat:@"msg:%@", msg];
    //Create a data object initialized with strings contents
	NSData *data = [[NSData alloc] initWithData:[response dataUsingEncoding:NSASCIIStringEncoding]];
    //Write the contents of the data to buffer
	[self.outputStream write:[data bytes] maxLength:[data length]];
}

- (void)retrieve
{
    //declares a buffer of a 1024 bytes in size
    //and . If the read operation successfully fetched bytes from the stream, the delegate appends these bytes to the NSMutableData object.
    uint8_t buffer[1024];
    //holds number of bytes received
    NSInteger len;
    //while input stream has bytes available to read
    while ([self.inputStream hasBytesAvailable]) {
        //invoke the input stream's to fill up the buffer with the specified number of bytes
        len = [self.inputStream read:buffer maxLength:sizeof(buffer)];
        //if bytes read is bigger than zero
        if (len > 0) {
            //create string from containing the bytes from the buffer with given encoding
            NSString *msg = [[NSString alloc] initWithBytes:buffer length:len encoding:NSASCIIStringEncoding];
            //if msg is not nil
            if (msg) {
                //check if delegate responds to - (void)gotMessage:(NSString *)msg; method and call it
                if([self.delegate respondsToSelector:@selector(gotMessage:)])
                    [self.delegate gotMessage:msg];
            }
        }
    }
}

- (void)disconnect
{
    NSLog(@"Disconnect");
    //close input stream
    [_inputStream close];
    //close output stream
    [_outputStream close];
    //remove from input stream from current thread
    [_inputStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    //remove output stream from current thread
    [_outputStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    //remove delegate for input stream
    [_inputStream setDelegate:nil];
    //remove delegate for output stream
    [_outputStream setDelegate:nil];
    
    //set input and output to nil
    _inputStream = nil;
    _outputStream = nil;
}

#pragma mark - NSStreamDelegate Method
- (void)stream:(NSStream *)aStream handleEvent:(NSStreamEvent)eventCode
{
    //switch statement to identify the passed-in NSStreamEvent constant
    switch(eventCode) {
        case NSStreamEventOpenCompleted:
            NSLog(@"Stream is opened");
            break;
        case NSStreamEventEndEncountered:
            //if error close connection and remove from loop from current thread
            [aStream close];
            [aStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
            break;
        case NSStreamEventHasBytesAvailable:
        {
            NSLog(@"NSStreamEventHasBytesAvailable");
            //if input then retrieve data
            if(aStream == self.inputStream)
                [self retrieve];
            break;
        }
        case NSStreamEventErrorOccurred:
        {
            //NSError object encapsulating information about any error that took place
            NSError *theError = [aStream streamError];
            //Create the alert to present to user
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error reading stream!" message:[NSString stringWithFormat:@"Error %@: description: %@", @([theError code]), [theError localizedDescription]] delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
            //Show alert
            [alert show];
            //Close connection
            [aStream close];
            break;
        }
        case NSStreamEventNone:
            NSLog(@"No Event");
            break;
        default:
            NSLog(@"Unknown event");
            break;
    }
}
#pragma mark -

@end

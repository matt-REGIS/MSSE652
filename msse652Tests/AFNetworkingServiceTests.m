//
//  NSURLSessionServiceTests.m
//  msse652
//
//  Created by echolush on 7/14/14.
//  Copyright (c) 2014 Matt Ozer. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "AFNetworking.h"
#import "AFNetworkingServiceTests.m"

@interface AFNetworkingServiceTests : XCTestCase

@end

@implementation AFNetworkingServiceTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testDownloadPrograms
{
    NSLog(@"*** Starting %s ***", __PRETTY_FUNCTION__);
    NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    sessionConfig.allowsCellularAccess = YES;
    [sessionConfig setHTTPAdditionalHeaders: @{@"Accept": @"application/json"}];
    sessionConfig.timeoutIntervalForRequest = 30.0;
    sessionConfig.timeoutIntervalForResource = 60.0;
    sessionConfig.HTTPMaximumConnectionsPerHost = 1;
    AFURLSessionManager *session = [[AFURLSessionManager alloc] initWithSessionConfiguration:sessionConfig];
    
    // Configure Manager
    [session setResponseSerializer:[AFJSONResponseSerializer serializer]];
    
    hxRunInMainLoop(^(BOOL *done) {
        // Send Request
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:kProgramLocationURL]];
        [[session dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
            XCTAssertNotNil(responseObject, @"No data for courses");
            *done = YES;
        }] resume];
    });
    
    NSLog(@"Ending %s", __PRETTY_FUNCTION__);
}

- (void)testDownloadCourses
{
    NSLog(@"*** Starting %s ***", __PRETTY_FUNCTION__);
    NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    sessionConfig.allowsCellularAccess = YES;
    [sessionConfig setHTTPAdditionalHeaders: @{@"Accept": @"application/json"}];
    sessionConfig.timeoutIntervalForRequest = 30.0;
    sessionConfig.timeoutIntervalForResource = 60.0;
    sessionConfig.HTTPMaximumConnectionsPerHost = 1;
    
    
    AFURLSessionManager *session = [[AFURLSessionManager alloc] initWithSessionConfiguration:sessionConfig];
    
    // Configure Manager
    [session setResponseSerializer:[AFJSONResponseSerializer serializer]];
    
    hxRunInMainLoop(^(BOOL *done) {
        // Send Request
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:kCourseLocationURL]];
        [[session dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
            XCTAssertNotNil(responseObject, @"No data for courses");
            *done = YES;
        }] resume];
    });
    
    NSLog(@"Ending %s", __PRETTY_FUNCTION__);
}

static inline void hxRunInMainLoop(void(^block)(BOOL *done)) {
    __block BOOL done = NO;
    block(&done);
    while (!done) {
        [[NSRunLoop mainRunLoop] runUntilDate:
         [NSDate dateWithTimeIntervalSinceNow:.1]];
    }
}

@end

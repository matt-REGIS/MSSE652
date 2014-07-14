//
//  msse652Tests.m
//  msse652Tests
//
//  Created by echolush on 6/29/14.
//  Copyright (c) 2014 Matt Ozer. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "NSURLSessionService.h"

@interface NSURLSessionServiceTests : XCTestCase

@end

@implementation NSURLSessionServiceTests

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
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfig];
    
    hxRunInMainLoop(^(BOOL *done) {
        [[session dataTaskWithURL:[NSURL URLWithString:kProgramLocationURL]
                completionHandler:^(NSData *data, NSURLResponse *response,
                                    NSError *error) {
                    XCTAssertNotNil(data, @"No data for programs");
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
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfig];
    
    hxRunInMainLoop(^(BOOL *done) {
        [[session dataTaskWithURL:[NSURL URLWithString:kCourseLocationURL]
                completionHandler:^(NSData *data, NSURLResponse *response,
                                    NSError *error) {
                    XCTAssertNotNil(data, @"No data for courses");
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

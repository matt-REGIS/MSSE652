//
//  NSURLSessionService.m
//  msse652
//
//  Created by echolush on 7/4/14.
//  Copyright (c) 2014 Matt Ozer. All rights reserved.
//

#import "NSURLSessionService.h"

@implementation NSURLSessionService

// Lazy instantiate arrayPrograms
- (NSMutableArray *)arrayPrograms
{
    if(!_arrayPrograms)
        _arrayPrograms = [NSMutableArray array];
    return _arrayPrograms;
}

- (void)downloadProgramsWithCoursesForTableView:(UITableView *)tableView
{
    //create a session config
    NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    //enable cellular access, it is on by default as well
    sessionConfig.allowsCellularAccess = YES;
    //set access headers for json reqiest
    [sessionConfig setHTTPAdditionalHeaders: @{@"Accept": @"application/json"}];
    //time between requests
    sessionConfig.timeoutIntervalForRequest = 30.0;
    //timThe maximum amount of time a resource request should take
    sessionConfig.timeoutIntervalForResource = 60.0;
    //The max number of simultaneous connections to make to a given host
    sessionConfig.HTTPMaximumConnectionsPerHost = 1;
    //create session to download content over HTTP
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfig];
    //Create an HTTP GET request and call the handler upon completion
    [[session dataTaskWithURL:[NSURL URLWithString:kProgramLocationURL]
            completionHandler:^(NSData *data, NSURLResponse *response,
                                NSError *error) {
                // handle response
                NSArray *json = [NSJSONSerialization
                                      JSONObjectWithData:data
                                      options:kNilOptions
                                      error:&error];
                for(id item in json) {
                    NSString *pId = [item objectForKey:@"id"];
                    NSString *pName = [item objectForKey:@"name"];
                    Program *program = [[Program alloc] initWithId:pId andName:pName];
                    [self.arrayPrograms addObject:program];
                }
                [self getCourses:session];
                [tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];

            }] resume];
}

- (void)getCourses:(NSURLSession *)session
{
    [[session dataTaskWithURL:[NSURL URLWithString:kCourseLocationURL]
            completionHandler:^(NSData *data, NSURLResponse *response,
                                NSError *error) {
                // handle response
                NSArray *json = [NSJSONSerialization
                                 JSONObjectWithData:data
                                 options:kNilOptions
                                 error:&error];
                for(id item in json) {
                    NSString *cId = [item objectForKey:@"id"];
                    NSString *cName = [item objectForKey:@"name"];
                    NSDictionary *coursePId = [item objectForKey:@"pid"];
                    Course *course = [[Course alloc] initWithId:cId andName:cName];
                    for(Program *program in self.arrayPrograms) {
                        if([(NSNumber *)[coursePId objectForKey:@"id"] integerValue] == [program.pId integerValue]) {
                            [program.pCourses addObject:course];
                        }
                    }
                }
            }] resume];
}

- (NSArray *)retrieveAllPrograms
{
    return [NSArray arrayWithArray:self.arrayPrograms];
}

@end

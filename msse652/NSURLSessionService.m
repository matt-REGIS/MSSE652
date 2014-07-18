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
                //iterate through the json array
                for(id item in json) {
                    //get the id
                    NSString *pId = [item objectForKey:@"id"];
                    // get the name
                    NSString *pName = [item objectForKey:@"name"];
                    //Create a program object
                    Program *program = [[Program alloc] initWithId:pId andName:pName];
                    //add to array
                    [self.arrayPrograms addObject:program];
                }
                //Get courses
                [self getCourses:session];
                //Reload tableview with new data
                [tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];

            }] resume];
}

//Download courses
- (void)getCourses:(NSURLSession *)session
{
    //Create an HTTP GET request and call the handler upon completion
    [[session dataTaskWithURL:[NSURL URLWithString:kCourseLocationURL]
            completionHandler:^(NSData *data, NSURLResponse *response,
                                NSError *error) {
                // handle response
                NSArray *json = [NSJSONSerialization
                                 JSONObjectWithData:data
                                 options:kNilOptions
                                 error:&error];
                //iterate through the json array
                for(id item in json) {
                    //get course id
                    NSString *cId = [item objectForKey:@"id"];
                    //get course name
                    NSString *cName = [item objectForKey:@"name"];
                    //get course's program
                    NSDictionary *coursePId = [item objectForKey:@"pid"];
                    //create a course
                    Course *course = [[Course alloc] initWithId:cId andName:cName];
                    //iterate through all programs
                    for(Program *program in self.arrayPrograms) {
                        //add course to program's courses if id's match
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

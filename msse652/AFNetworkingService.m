//
//  AFNetworkingService.m
//  msse652
//
//  Created by echolush on 7/14/14.
//  Copyright (c) 2014 Matt Ozer. All rights reserved.
//

#import "AFNetworkingService.h"
#import "AFNetworking.h"

@implementation AFNetworkingService

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
    
    //create a session from the session config
    AFURLSessionManager *session = [[AFURLSessionManager alloc] initWithSessionConfiguration:sessionConfig];
    
    // Configure Manager
    [session setResponseSerializer:[AFJSONResponseSerializer serializer]];
    
    // Send Request
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:kProgramLocationURL]];
    //download data with completion block
    [[session dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        // Process Response Object
        for(id item in responseObject) {
            //get id
            NSString *pId = [item objectForKey:@"id"];
            //get name
            NSString *pName = [item objectForKey:@"name"];
            //create a program
            Program *program = [[Program alloc] initWithId:pId andName:pName];
            //add program to array
            [self.arrayPrograms addObject:program];
        }
        //get courses
        [self getCourses:session];
        //refresh table view with new data
        [tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
    }] resume];
}

//Download courses
- (void)getCourses:(AFURLSessionManager *)session
{
    //Request for courses
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:kCourseLocationURL]];
    //download data with completion block
    [[session dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        // Process Response Object
        for(id item in responseObject) {
            //get course id
            NSString *cId = [item objectForKey:@"id"];
            //get course name
            NSString *cName = [item objectForKey:@"name"];
            //get course's program id
            NSDictionary *coursePId = [item objectForKey:@"pid"];
            //create a course
            Course *course = [[Course alloc] initWithId:cId andName:cName];
            //iterate through all programs
            for(Program *program in self.arrayPrograms) {
                //add course to program if ids match
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

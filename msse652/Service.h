//
//  Service.h
//  msse652
//
//  Created by echolush on 7/4/14.
//  Copyright (c) 2014 Matt Ozer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Program.h"
#import "Course.h"

/**
 Protocol definition for service
*/
@protocol Service <NSObject>

/**
 Downloads SCIS Programs with courses from course provided URL and reloads tableView
 @param tableView
        tableView to be reloaded after download
*/
- (void)downloadProgramsWithCoursesForTableView:(UITableView *)tableView;

/**
 Gets all downloaded programs
 @return an array of programs
*/
- (NSArray *)retrieveAllPrograms;

@end
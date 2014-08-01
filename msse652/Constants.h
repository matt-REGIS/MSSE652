//
//  Constants.h
//  msse652
//
//  Created by echolush on 7/14/14.
//  Copyright (c) 2014 Matt Ozer. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 Constants class - Holds global constants
 */
@interface Constants : NSObject

/** Program URL to course provided link */
extern NSString *const kProgramLocationURL;
/** Course URL to course provided link */
extern NSString *const kCourseLocationURL;
/** To use in iCloud sync */
extern NSString *const kTasks;
/** To use for iCloud sync */
extern NSString *const kNewNote;
/** To use for host name for chat server */
extern NSString *const kHost;
/** To use for port number for chat server */
extern int const kPort;

@end

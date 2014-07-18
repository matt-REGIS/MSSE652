//
//  NSURLSessionService.h
//  msse652
//
//  Created by echolush on 7/4/14.
//  Copyright (c) 2014 Matt Ozer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Service.h"

/**
 NSURLSessionService - Service to get programs and courses
 */
@interface NSURLSessionService : NSObject <Service>

/**Holds Programs*/
@property (strong, nonatomic) NSMutableArray *arrayPrograms;
@end

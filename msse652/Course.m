//
//  Course.m
//  msse652
//
//  Created by echolush on 7/13/14.
//  Copyright (c) 2014 Matt Ozer. All rights reserved.
//

#import "Course.h"

@implementation Course

- (Course *)initWithId:(NSString *)cId andName:(NSString *)cName
{
    self.cId = cId;
    self.cName = cName;
    return self;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"Course ID: %@ withName: %@", self.cId, self.cName];
}

@end

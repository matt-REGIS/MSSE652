//
//  Program.m
//  msse652
//
//  Created by echolush on 7/10/14.
//  Copyright (c) 2014 Matt Ozer. All rights reserved.
//

#import "Program.h"

@implementation Program

- (Program *)initWithId:(NSString *)pId andName:(NSString *)pName
{
    self.pId = pId;
    self.pName = pName;
    return self;
}

- (NSMutableArray *)pCourses
{
    if(!_pCourses)
        _pCourses = [NSMutableArray array];
    return _pCourses;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"Program ID: %@ withName: %@ withCourses: %@", self.pId, self.pName, self.pCourses];
}

@end

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

- (NSString *)description
{
    return [NSString stringWithFormat:@"Program ID: %@ withName: %@", self.pId, self.pName];
}

@end

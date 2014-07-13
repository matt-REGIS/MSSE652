//
//  Course.h
//  msse652
//
//  Created by echolush on 7/13/14.
//  Copyright (c) 2014 Matt Ozer. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 SCIS Course
 */
@interface Course : NSObject

/** Holds course Id */
@property (strong, nonatomic) NSString *cId;
/** Holds course name */
@property (strong, nonatomic) NSString *cName;

/**
 Inits course with Id and name
 @param pID
 The Course Id
 @param pName
 The Course name
 @return Program
 */
- (Course *)initWithId:(NSString *)cId andName:(NSString *)cName;

@end

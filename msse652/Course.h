//
//  Course.h
//  msse652
//
//  Created by echolush on 7/17/14.
//  Copyright (c) 2014 Matt Ozer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

/**
 Course class
 */
@interface Course : NSManagedObject

/** Course Id*/
@property (nonatomic, retain) NSNumber * id;
/** Course name*/
@property (nonatomic, retain) NSString * name;
/** Course related program Id*/
@property (nonatomic, retain) NSNumber * pId;
/** Course related program name*/
@property (nonatomic, retain) NSString * pName;

@end

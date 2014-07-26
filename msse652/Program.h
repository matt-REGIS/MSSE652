//
//  Program.h
//  msse652
//
//  Created by echolush on 7/17/14.
//  Copyright (c) 2014 Matt Ozer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

/** Program class*/
@interface Program : NSManagedObject

/** Program Id*/
@property (nonatomic, retain) NSNumber * id;
/** Program name*/
@property (nonatomic, retain) NSString * name;

@end

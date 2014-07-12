//
//  Program.h
//  msse652
//
//  Created by echolush on 7/10/14.
//  Copyright (c) 2014 Matt Ozer. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 SCIS Programs
*/
@interface Program : NSObject

/** Holds program Id */
@property (strong, nonatomic) NSString *pId;
/** Holds program name */
@property (strong, nonatomic) NSString *pName;

/**
 Inits program with Id and name
 @param pID 
        The Program Id
 @param pName 
        The Program name
 @return Program
*/
- (Program *)initWithId:(NSString *)pId andName:(NSString *)pName;

@end

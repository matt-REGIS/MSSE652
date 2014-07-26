//
//  SCISCoursesTableViewController.h
//  msse652
//
//  Created by echolush on 7/2/14.
//  Copyright (c) 2014 Matt Ozer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Program.h"
#import "Course.h"

/**
 SCISCoursesTableViewController - Shows SCIS courses in table view
 */
@interface SCISCoursesTableViewController : UITableViewController

/**
 Holds the program that was sent when cell did select from
 SCISProgramsTableViewController
 */
@property (strong, nonatomic) Program *program;

@end

//
//  FirstViewController.h
//  msse652
//
//  Created by echolush on 6/29/14.
//  Copyright (c) 2014 Matt Ozer. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 UIViewController for first view
 Demonstrates presenting second view controller modally
 */
@interface FirstViewController : UIViewController

/**
 Exit method for Second View Controller
 @param sender
        Associated segue from the storyboard
 */
- (IBAction)exitHere:(UIStoryboardSegue *)sender;

@end

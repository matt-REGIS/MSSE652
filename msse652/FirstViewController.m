//
//  FirstViewController.m
//  msse652
//
//  Created by echolush on 6/29/14.
//  Copyright (c) 2014 Matt Ozer. All rights reserved.
//

#import "FirstViewController.h"

@interface FirstViewController ()

@end

@implementation FirstViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)exitHere:(UIStoryboardSegue *)sender
{
    NSLog(@"Exited Second View Controller");
}

@end

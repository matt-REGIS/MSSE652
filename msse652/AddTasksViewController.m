//
//  AddTasksViewController.m
//  msse652
//
//  Created by echolush on 7/29/14.
//  Copyright (c) 2014 Matt Ozer. All rights reserved.
//

#import "AddTasksViewController.h"

@interface AddTasksViewController ()
@property (weak, nonatomic) IBOutlet UITextView *textViewNote;
@end

@implementation AddTasksViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)actionSave:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kNewNote object:self userInfo:[NSDictionary dictionaryWithObject:self.textViewNote.text forKey:kTasks]];
    [self dismissViewControllerAnimated:YES completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
//
//  TasksViewController.m
//  msse652
//
//  Created by echolush on 7/2/14.
//  Copyright (c) 2014 Matt Ozer. All rights reserved.
//

#import "TasksViewController.h"

@interface TasksViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *arrayNotes;
@end

@implementation TasksViewController

#pragma mark  - Lazy Intantiations
- (NSMutableArray *)arrayNotes
{
    if(!_arrayNotes) {
        _arrayNotes = [NSMutableArray array];
    }
    return _arrayNotes;
}

#pragma mark -

- (void)viewDidLoad
{
    [super viewDidLoad];
    //Get the iCloud key-value store
    NSUbiquitousKeyValueStore *store = [NSUbiquitousKeyValueStore defaultStore];
    //Make self an observer for NSUbiquitousKeyValueStoreDidChangeExternallyNotification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(storeDidChange:) name:NSUbiquitousKeyValueStoreDidChangeExternallyNotification object:store];
    //Save in-memory keys and values
    [store synchronize];
    //Make self an observer for kNewNote, when a new note is added
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didAddNewNote:) name:kNewNote object:nil];
    //populate array from iCloud
    self.arrayNotes = [NSMutableArray arrayWithArray:[store arrayForKey:kTasks]];
    //refresh table view with new data
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)didAddNewNote:(NSNotification *)notification
{
    //get dictionary associated with the receiver
    NSDictionary *userInfo = [notification userInfo];
    //get the task
    NSString *taskStr = [userInfo valueForKey:kTasks];
    //add the task
    [self.arrayNotes addObject:taskStr];
    //Get the iCloud key-value store
    NSUbiquitousKeyValueStore *store = [NSUbiquitousKeyValueStore defaultStore];
    //if store is available, set the array as a value and kTasks as key
    if (store)
        [store setObject:self.arrayNotes forKey:kTasks];
    //Save in-memory keys and values
    [store synchronize];
    //refresh table view with new data
    [self.tableView reloadData];
}

- (void)storeDidChange:(NSNotification *)notification
{
    //get dictionary associated with the receiver
    NSDictionary *userInfo = [notification userInfo];
    //get the reason
    //NSUbiquitousKeyValueStoreServerChange: this value indicates that the key-value store has changed in the cloud most likely because another device has sent a new value.
    //NSUbiquitousKeyValueStoreInitialSyncChange: this value occurs the first time the app runs and has yet to be synced with iCloud.
    NSNumber *reason = [userInfo
                        objectForKey:NSUbiquitousKeyValueStoreChangeReasonKey];
    
    if (reason) {
        NSInteger reasonValue = [reason integerValue];
        //if reasonValue is what we are looking for
        if ((reasonValue == NSUbiquitousKeyValueStoreServerChange) ||
            (reasonValue == NSUbiquitousKeyValueStoreInitialSyncChange)) {
            //Get the iCloud key-value store
            NSUbiquitousKeyValueStore *store = [NSUbiquitousKeyValueStore defaultStore];
            //if store, populate array from store
            if (store)
                self.arrayNotes = [NSMutableArray arrayWithArray:[store arrayForKey:kTasks]];
            //refresh table view with new data
            [self.tableView reloadData];
        }
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.arrayNotes.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //A string identifying the cell object to be reused
    static NSString *CELLIDENTIFIER = @"CELLIDENTIFIER";
    //Returns a reusable table-view cell object for the specified reuse identifier
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELLIDENTIFIER forIndexPath:indexPath];
    
    // Configure the cell if nil
    if(cell==nil) {
        //Initializes a table cell with a subtitle style and a reuse identifier
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELLIDENTIFIER];
    }
    
    //Set the label for the cell to program name
    cell.textLabel.text = [self.arrayNotes objectAtIndex:indexPath.row];
    return cell;
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

 // Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [self.arrayNotes removeObjectAtIndex:indexPath.row];
        //Delete the rows specified by an array of index paths, with UITableViewRowAnimationFade option to animate the deletion
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        //Set the store with new array as a value and kTasks as key
        [[NSUbiquitousKeyValueStore defaultStore] setArray:self.arrayNotes forKey:kTasks];
    }
}

#pragma mark -

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Segue identifier is FromTasksToAddNote if needs to be added
 //Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end

//
//  SCISCoursesTableViewController.m
//  msse652
//
//  Created by echolush on 7/2/14.
//  Copyright (c) 2014 Matt Ozer. All rights reserved.
//

#import "SCISCoursesTableViewController.h"
#import <RestKit/RestKit.h>

@interface SCISCoursesTableViewController ()
//Fetched results controller for retrieving objects from core data
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsControllerCourse;
@end

@implementation SCISCoursesTableViewController

#pragma mark - Lazy Instantiations
- (NSFetchedResultsController *)fetchedResultsControllerCourse
{
    //if not instantiate fetched results controller
    if(!_fetchedResultsControllerCourse) {
        //Returns a fetch request configured with a Program entity
        NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([Course class])];
        //Creates and returns a new predicate with a given format
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"pId == %@", self.program.id];
        fetchRequest.predicate = predicate;
        //Describe how to order objects
        fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]];
        //init
        self.fetchedResultsControllerCourse = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:[RKManagedObjectStore defaultStore].mainQueueManagedObjectContext sectionNameKeyPath:@"name" cacheName:@"Course"];
        //For error information
        NSError *error;
        //Access the fetched objects
        [self.fetchedResultsControllerCourse performFetch:&error];
        //Generate an assertion for a given condition
        NSAssert(!error, @"Error performing fetch request: %@", error);
    }
    return _fetchedResultsControllerCourse;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    return self.fetchedResultsControllerCourse.fetchedObjects.count;
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
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CELLIDENTIFIER];
    }
    
    //Get the course for the cell
    Course *course = [self.fetchedResultsControllerCourse.fetchedObjects objectAtIndex:indexPath.row];
    //Set the cell's label text to course name
    cell.textLabel.text = course.name;
    //Set the number of lines in cell's label into one in order to use size to fit function
    cell.textLabel.numberOfLines = 1;
    //Enable adjusts to font size for the cell label
    cell.textLabel.adjustsFontSizeToFitWidth = YES;
    //Resize the cell's label so that it uses the most appropriate amount of space
    [cell.textLabel sizeToFit];
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

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

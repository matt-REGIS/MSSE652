//
//  SCISProgramsTableViewController.m
//  msse652
//
//  Created by echolush on 7/2/14.
//  Copyright (c) 2014 Matt Ozer. All rights reserved.
//

#import "SCISProgramsTableViewController.h"
#import "SCISCoursesTableViewController.h"
#import <RestKit/RestKit.h>
#import "Program.h"

@interface SCISProgramsTableViewController ()
//Fetched results controller for retrieving objects from core data
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsControllerProgram;
@end

@implementation SCISProgramsTableViewController

#pragma mark - Lazy Instantiations
- (NSFetchedResultsController *)fetchedResultsControllerProgram
{
    //if not instantiate fetched results controller
    if(!_fetchedResultsControllerProgram) {
        //Returns a fetch request configured with a Program entity
        NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([Program class])];
        //Describe how to order objects
        fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]];
        //init
        self.fetchedResultsControllerProgram = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:[RKManagedObjectStore defaultStore].mainQueueManagedObjectContext sectionNameKeyPath:@"name" cacheName:@"Program"];
        //For error information
        NSError *error;
        //Access the fetched objects
        [self.fetchedResultsControllerProgram performFetch:&error];
        //Generate an assertion for a given condition
        NSAssert(!error, @"Error performing fetch request: %@", error);
    }
    return _fetchedResultsControllerProgram;
}

#pragma mark -

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
    return self.fetchedResultsControllerProgram.fetchedObjects.count;
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
    
    //Get the program for the cell
    Program *program = (Program *)[[self.fetchedResultsControllerProgram fetchedObjects] objectAtIndex:indexPath.row];
    //Set the label for the cell to program name
    cell.textLabel.text = program.name;
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


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    //if the identifier for the segue object is FromProgramsToCourses
    if([segue.identifier isEqualToString:@"FromProgramsToCourses"]) {
        // Get the new view controller using [segue destinationViewController].
        SCISCoursesTableViewController *vc = (SCISCoursesTableViewController *)[segue destinationViewController];
        //Get the clicked cell from sender
        UITableViewCell *cell = (UITableViewCell*)sender;
        //Find the indexpath of the clicked cell
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        // Pass the selected program to SCISCoursesTableViewController
        Program *program = [[self.fetchedResultsControllerProgram fetchedObjects] objectAtIndex:indexPath.row];
        vc.program = program;
    }
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    // The fetch controller is about to start sending change notifications, so prepare the table view for updates.
    [self.tableView beginUpdates];
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    // The fetch controller has sent all current change notifications, so tell the table view to process all updates.
    [self.tableView endUpdates];
}

@end

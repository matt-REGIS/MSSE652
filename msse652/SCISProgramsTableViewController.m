//
//  SCISProgramsTableViewController.m
//  msse652
//
//  Created by echolush on 7/2/14.
//  Copyright (c) 2014 Matt Ozer. All rights reserved.
//

#import "SCISProgramsTableViewController.h"
#import "NSURLSessionService.h"
#import "SCISCoursesTableViewController.h"

@interface SCISProgramsTableViewController ()
@property (strong, nonatomic) NSURLSessionService *service;
@property (strong, nonatomic) NSArray *arrayPrograms;
@end

@implementation SCISProgramsTableViewController

#pragma mark - Lazy Instantiations
- (NSURLSessionService *)service
{
    if(!_service)
        _service = [[NSURLSessionService alloc] init];
    return _service;
}

- (NSArray *)arrayPrograms
{
    if(!_arrayPrograms) {
        _arrayPrograms = [NSArray array];
    }
    return _arrayPrograms;
}
#pragma mark -

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.service downloadProgramsWithCoursesForTableView:self.tableView];
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
    return [[self.service retrieveAllPrograms] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CELLIDENTIFIER = @"CELLIDENTIFIER";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELLIDENTIFIER forIndexPath:indexPath];
    
    // Configure the cell...
    if(cell==nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CELLIDENTIFIER];
    }
    
    Program *program = [[self.service retrieveAllPrograms] objectAtIndex:indexPath.row];
    cell.textLabel.text = program.pName;
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
    if([segue.identifier isEqualToString:@"FromProgramsToCourses"]) {
        // Get the new view controller using [segue destinationViewController].
        SCISCoursesTableViewController *vc = (SCISCoursesTableViewController *)[segue destinationViewController];
        UITableViewCell *cell = (UITableViewCell*)sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        // Pass the selected object to the new view controller.
        Program *program = [[self.service retrieveAllPrograms] objectAtIndex:indexPath.row];
        vc.program = program;
    }
}


@end

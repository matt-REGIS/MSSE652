//
//  MessageViewController.m
//  msse652
//
//  Created by echolush on 7/30/14.
//  Copyright (c) 2014 Matt Ozer. All rights reserved.
//

#import "MessageViewController.h"
#import "SocketSvc.h"

@interface MessageViewController () <SocketSvcDelegate, UITextFieldDelegate>
//tableView outlet
@property (weak, nonatomic) IBOutlet UITableView *tableView;
//textView outlet
@property (weak, nonatomic) IBOutlet UITextField *outletTextField;
//Socket service
@property (strong, nonatomic) SocketSvc *service;
//Array to hold messages
@property (strong, nonatomic) NSMutableArray *arrayMessages;
//Right bar button outlet to send messages
@property (weak, nonatomic) IBOutlet UIBarButtonItem *outletBtnSend;
@end

@implementation MessageViewController

#pragma mark - Lazy Instantiations
- (SocketSvc *)service
{
    if(!_service) {
        _service = [[SocketSvc alloc] init];
    }
    return _service;
}

- (NSMutableArray *)arrayMessages
{
    if(!_arrayMessages) {
        _arrayMessages = [[NSMutableArray alloc] init];
    }
    return _arrayMessages;
}
#pragma mark -

- (void)viewDidLoad
{
    [super viewDidLoad];
    //set textView delegate to self
    self.outletTextField.delegate = self;
    //set service delegate to self
    self.service.delegate = self;
    //set service variables from Constants.h
    self.service.host = kHost;
    self.service.port = kPort;
    //connect to chat server
	[self.service connect];
    //Join chat with device name
    [self.service joinChat:[[UIDevice currentDevice] name]];
    //add observer for textfield's text did change to enable and disable send button
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textFieldChanged)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:self.outletTextField];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //remove all observers
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    //disconnect from chat server
    [self.service disconnect];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)actionSend:(UIBarButtonItem *)sender
{
    //send text fields text to server
    [self.service send:self.outletTextField.text];
    //clear text field
    self.outletTextField.text = @"";
    //disable send button
    self.outletBtnSend.enabled = NO;
}

- (void)textFieldChanged
{
    //if no text then disable send button
    if(![self.outletTextField.text isEqualToString:@""]) {
        self.outletBtnSend.enabled = YES;
    }
    else {
        self.outletBtnSend.enabled = NO;
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
    return self.arrayMessages.count;
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
    
    //Set the label for the cell to message
    cell.textLabel.text = [self.arrayMessages objectAtIndex:indexPath.row];
    return cell;
}

#pragma mark - SocketSvcDelegate Method
-(void)gotMessage:(NSString *)msg
{
    //add incoming message to array
    [self.arrayMessages addObject:msg];
    //refresh table view
    [self.tableView reloadData];
    //check if count is 0 before getting the index path to not get array out of index
    if(self.arrayMessages.count != 0) {
        //get top index path
        NSIndexPath *topIndexPath =
        [NSIndexPath indexPathForRow:self.arrayMessages.count-1
                           inSection:0];
        //scroll tableview so that messages don't hide behind the keyboard
        [self.tableView scrollToRowAtIndexPath:topIndexPath
                              atScrollPosition:UITableViewScrollPositionMiddle
                                      animated:YES];
    }
}
#pragma mark -

#pragma mark - TextFieldDelegate Methods
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    //call send button when keyboard's return button is touch
    [self actionSend:nil];
    return YES;
}
#pragma mark -

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

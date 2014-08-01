//
//  MessageViewController.m
//  msse652
//
//  Created by echolush on 7/30/14.
//  Copyright (c) 2014 Matt Ozer. All rights reserved.
//

#import "MessageViewController.h"
#import "SRWebSocket.h"

@interface MessageViewController () <UITextFieldDelegate, SRWebSocketDelegate>
//tableView outlet
@property (weak, nonatomic) IBOutlet UITableView *tableView;
//textView outlet
@property (weak, nonatomic) IBOutlet UITextField *outletTextField;
//Array to hold messages
@property (strong, nonatomic) NSMutableArray *arrayMessages;
//webSocket variable for SocketRocket
@property (strong, nonatomic) SRWebSocket *webSocket;
//Right bar button outlet to send messages
@property (weak, nonatomic) IBOutlet UIBarButtonItem *outletBtnSend;
@end

@implementation MessageViewController

#pragma mark - Lazy Instantiations
- (NSMutableArray *)arrayMessages
{
    if(!_arrayMessages) {
        _arrayMessages = [[NSMutableArray alloc] init];
    }
    return _arrayMessages;
}

- (SRWebSocket *)webSocket
{
    if(!_webSocket) {
        //set the server url with app name
        NSString *url = [kHost stringByAppendingString:[[NSString stringWithFormat:@":%@", @(kPort)] stringByAppendingString:@"/chat"]];
        //init webSocker
        _webSocket = [[SRWebSocket alloc] initWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
        //set delegate
        _webSocket.delegate = self;
    }
    return _webSocket;
}
#pragma mark -

- (void)viewDidLoad
{
    [super viewDidLoad];
    //set textView delegate to self
    self.outletTextField.delegate = self;
    
    //add observer for textfield's text did change to enable and disable send button
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textFieldChanged)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:self.outletTextField];
    
    [self.webSocket open];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //remove all observers
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    //close connection
    [self.webSocket close];
    _webSocket = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)actionSend:(UIBarButtonItem *)sender
{
    //send text fields text to server
    NSString *msgToSend = [[[[UIDevice currentDevice] name] stringByAppendingString:@":"] stringByAppendingString:self.outletTextField.text];
    [self.webSocket send:msgToSend];
    //clear text field
    self.outletTextField.text = @"";
    //disable send button
    self.outletBtnSend.enabled = NO;
    [self addMessage:msgToSend];
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

-(void)addMessage:(NSString *)msg
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

#pragma mark - TextFieldDelegate Methods
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    //call send button when keyboard's return button is touch
    [self actionSend:nil];
    return YES;
}
#pragma mark -

#pragma mark - SRWebSocketDelegate Methods
- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message
{
    NSLog(@"Received msg: %@", message);
    [self addMessage:message];
}

- (void)webSocketDidOpen:(SRWebSocket *)webSocket
{
    NSLog(@"Connected");
}

- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error
{
    //Create the alert to present to user
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error in stream!" message:[NSString stringWithFormat:@"Error %@: description: %@", @([error code]), [error localizedDescription]] delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
    //Show alert
    [alert show];
}

- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean
{
    NSLog(@"WebSocket closed");
    //set to nil
    _webSocket = nil;
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

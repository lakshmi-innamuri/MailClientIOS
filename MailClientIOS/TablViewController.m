//
//  TablViewController.m
//  MailClientIOS
//
//  Created by Lakshmi Kollapudi on 5/25/15.
//  Copyright (c) 2015 myOrg. All rights reserved.
//

#import "TablViewController.h"
#import "MailItemTableViewCell.h"
#import "Mail.h"
#import "TFHpple.h"

@interface TablViewController ()

@end

@implementation TablViewController
static NSString* cellIdentifier = @"CellIdentifier";
@synthesize user = _user;
@synthesize sender = _sender;
@synthesize sender_id = _sender_id;
@synthesize tableView;
NSMutableArray *tableData;
NSMutableArray *tableDate;
NSMutableArray *tableSubject;
NSMutableArray *allMails;
NSMutableArray *allCheckedMails;
NSMutableSet *mailboxSet;


- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.userInteractionEnabled = YES;
    
    [tableView registerClass:[MailItemTableViewCell class] forCellReuseIdentifier:cellIdentifier];
    
    tableData = [[NSMutableArray alloc] init];
    tableDate = [[NSMutableArray alloc] init];
    tableSubject = [[NSMutableArray alloc] init];
    allMails = [[NSMutableArray alloc] init];
    allCheckedMails = [[NSMutableArray alloc] init];
    mailboxSet = [[NSMutableSet alloc] init];

    [self retrieveUnsubscribeEmails];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [allMails count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MailItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
//    if (cell == nil) {
//        cell = [[UITableViewCell alloc]
//                initWithStyle:UITableViewCellStyleSubtitle
//                reuseIdentifier:CellIdentifier];
//    }
    
    cell.accessoryView = [[UISwitch alloc] initWithFrame:CGRectZero];
    
    //TODO: sort mail list display
    //so unsubscribe=true displays on top
    //TODO: change switch UI
    
    UISwitch * mySwitch = [[UISwitch alloc] initWithFrame:CGRectZero];
    cell.accessoryView = mySwitch;
    [mySwitch addTarget:self action:@selector(updateSwitchAtIndexPath:) forControlEvents:UIControlEventValueChanged];
    mySwitch.tag = [indexPath row];

    
    Mail *mailForCell = [allMails objectAtIndex:[indexPath row]];
    if(mailForCell.unsubscribed == true)
        cell.color = [UIColor colorWithRed:0 green:1 blue:0 alpha:1];
    else if(mailForCell.unsubscribed == false)
        cell.color = [UIColor colorWithRed:1 green:0 blue:0 alpha:1];
    [cell setSubject:mailForCell.mailbox ];
    

   return cell;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)updateSwitchAtIndexPath:(UISwitch*)sender {
    
   
    //TODO: check if its selected or destelected
    NSLog(@"updated %ld",(long)sender.tag);
    if([sender isOn]){
        NSLog(@"on");
    Mail * thisMail = [allMails objectAtIndex:sender.tag];
    thisMail.checked = true;
    [allCheckedMails addObject: thisMail];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)unsubscribeEmails:(id)sender {

    [self unsubscribe];

}


- (IBAction)unsubscribeAll:(id)sender {
    
    //TODO: add select all
    //update all ui switch to seelcted
    
    NSBlockOperation *eezyBlockOperation = [NSBlockOperation blockOperationWithBlock:^{
        [allCheckedMails removeAllObjects];
        allCheckedMails = [allMails mutableCopy];
        [self unsubscribe];
        [allCheckedMails removeAllObjects];
        
    }];

    NSOperationQueue *operationQueue = [[NSOperationQueue alloc]init];
    [operationQueue addOperation:eezyBlockOperation];
    


}

-(void) unsubscribe{
    for (Mail *email in allCheckedMails) {
        
        NSURLRequest * urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:email.unsubscribe_url]];
        NSHTTPURLResponse * response = nil;
        NSError * error = nil;
        NSData * data = [NSURLConnection sendSynchronousRequest:urlRequest
                                              returningResponse:&response
                                                          error:&error];
        
        if (error == nil)
        {
            NSLog(@"status %ld",(long)[response statusCode]);
            if ([response statusCode] == 200) {
                email.unsubscribed = true;
                NSLog(@"positive \n%@ , \n%@",email.mailbox,email.unsubscribe_url);
            }
        }else{
            email.unsubscribed = false;
            NSLog(@"negative \n%@ , \n%@",email.mailbox,email.unsubscribe_url);
        }
        [tableView reloadData];
    }
}

- (void) retrieveUnsubscribeEmails{
    // TODO: move common code to IAMP.m
    
    NSLog(@"here here");
    
    MCOIMAPSession *session = [[MCOIMAPSession alloc] init];
    session.hostname = @"imap.gmail.com";
    session.port = 993;
    session.username = [self.user getUid];
    session.password = [self.user getPwd];
    session.connectionType = MCOConnectionTypeTLS;
    
    
    //[MCOIMAPSearchExpression searchHeader:@"Message-ID" value:@"themessage@id"]
    __block MCOIMAPFetchMessagesOperation *fetch;
    Mail* m =  [[Mail alloc] init];
    
    m = [mailboxSet anyObject];
    // FIXME: message ID
    //uint64_t mid = (m.message_id);
    //NSLog(@"after %ld",(unsigned long)[mailboxSet count]);
    MCOIMAPMessagesRequestKind requestKind = MCOIMAPMessagesRequestKindFullHeaders;
    
    MCOIMAPSearchExpression * expr = [MCOIMAPSearchExpression searchGmailRaw:@"unsubscribe"];
    MCOIMAPSearchOperation* searchOperation = [session searchExpressionOperationWithFolder:@"INBOX" expression: expr];
    [tableSubject removeAllObjects];
    [tableDate removeAllObjects];
    //pull message id or uid ,
    //extract body
    //parse to get unsubscribe url
    //invoke the url
    //verify for 200
    
    // FIXME: fetchMessages deprecated
    // TODO: retrieve in descending order of date
    // TODO: pull emails from all folders
    NSBlockOperation *eezyBlockOperation = [NSBlockOperation blockOperationWithBlock:^{

    
    [searchOperation start:^(NSError *err, MCOIndexSet *searchResult) {
        
        
        fetch =
        [session fetchMessagesByUIDOperationWithFolder:@"INBOX"
                                           requestKind:requestKind
                                                  uids:searchResult];
        [fetch start:^(NSError *err, NSArray *msgs, MCOIndexSet *vanished) {
            
            //NSLog(@"msg count %lu",(unsigned long)[msgs count]);
            for (int i = 0; i < [msgs count]; i++) {
                MCOIMAPMessage *m = msgs[i];
                NSString* mailbox = m.header.from.mailbox;
                //TODO: verify for unique unsubscribe url
                //emails from different mailbox may have same unsubscribe url
                // picasa is an example
                // <picasaweb-noreply@google.com>
                //
                if (![mailboxSet containsObject:mailbox]) {
                    //NSLog(@"%@",mailbox);
                    [mailboxSet addObject:mailbox];
                    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                    [dateFormatter setDateFormat:@"MM-dd-YY HH:mm"];
                    NSString *dateString = [dateFormatter stringFromDate:m.header.date];
                    Mail *email = [[Mail alloc]
                                   initWithSubject:(NSString*)m.header.subject
                                   Date:(NSString*)dateString
                                   msgID :(uint64_t) [m gmailMessageID]];
                    email.mailbox = mailbox;
                    
                    MCOIMAPFetchContentOperation *operation = [session fetchMessageByUIDOperationWithFolder:@"INBOX" uid:m.uid];
                    
                    if(i > -1){
                        [operation start:^(NSError *error, NSData *data) {
                            
                            MCOMessageParser *messageParser = [[MCOMessageParser alloc] initWithData:data];
                            
                            TFHpple *tutorialsParser = [TFHpple hppleWithHTMLData:data];
                            NSString *tutorialsXpathQueryString = @"//a";
                            NSArray *tutorialsNodes = [tutorialsParser searchWithXPathQuery:tutorialsXpathQueryString];
                            
                            for (TFHppleElement *element in tutorialsNodes) {
                                
                                NSString *linkText = [[[element firstChild] content] lowercaseString];
                                if([linkText isEqualToString:@"unsubscribe"]){
                                  //  NSLog(@" first child %@",[[element firstChild] content]);
                                    NSString * url = [element objectForKey:@"href"];
                                    //NSLog(@"%@",url);
                                    email.unsubscribe_url = url;
                                }
                            }
                        }];
                    }
                    [allMails addObject:email];
                    [tableView reloadData];
                }
                
            }
        }];
    }]; //close of nsop start
        
    }];
    NSLog(@"before block");
    
    NSOperationQueue *operationQueue = [[NSOperationQueue alloc]init];
    [operationQueue addOperation:eezyBlockOperation];
    NSLog(@"after block");
    
}


@end

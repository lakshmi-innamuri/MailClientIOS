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

    [self retrieveAll];
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
    
    UISwitch * mySwitch = [[UISwitch alloc] initWithFrame:CGRectZero];
    cell.accessoryView = mySwitch;
    [mySwitch addTarget:self action:@selector(updateSwitchAtIndexPath:) forControlEvents:UIControlEventValueChanged];
    mySwitch.tag = [indexPath row];
    
//    [cell setSentDate:[tableDate objectAtIndex:[indexPath row]]];
//    [cell setSubject:[tableSubject objectAtIndex: [indexPath row]]];
//    

    Mail *mailForCell = [allMails objectAtIndex:[indexPath row]];
    [cell setSentDate:mailForCell.date ];
    [cell setSubject:mailForCell.subject ];

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
    
    NSLog(@"updated %ld",sender.tag);
    Mail * thisMail = [allMails objectAtIndex:sender.tag];
    thisMail.checked = true;
    [allCheckedMails addObject: thisMail];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)unsubscribeEmails:(id)sender {

    for(int i=0; i< allCheckedMails.count ; i++){
        
        Mail *thisMail = allMails[i];
        NSString* url = thisMail.unsubscribe_url;
        NSURLRequest * urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
        NSHTTPURLResponse * response = nil;
        NSError * error = nil;
        NSData * data = [NSURLConnection sendSynchronousRequest:urlRequest
                                              returningResponse:&response
                                                          error:&error];
        
        if (error == nil)
        {
            NSLog(@"unsubscribed %@   %ld",url,[response statusCode]);
            if ([response statusCode] == 200) {
                thisMail.unsubscribed = true;
            }
        }else{
            NSLog(@"in else %ld",[response statusCode]);
        }
        
                }
                [tableView reloadData];

}


- (IBAction)unsubscribeAll:(id)sender {
    
    MCOIMAPSession *session = [[MCOIMAPSession alloc] init];
    session.hostname = @"imap.gmail.com";
    session.port = 993;
    session.username = [self.user getUid];
    session.password = [self.user getPwd];
    session.connectionType = MCOConnectionTypeTLS;
    
    //[MCOIMAPSearchExpression searchHeader:@"Message-ID" value:@"themessage@id"]
    __block MCOIMAPFetchMessagesOperation *fetch;
    
    //NSLog(@"imap id%@, pwd %@", user.getUid, user.getPwd);
    MCOIMAPMessagesRequestKind requestKind = MCOIMAPMessagesRequestKindFullHeaders;
    MCOIMAPSearchExpression * expr = [MCOIMAPSearchExpression searchGmailRaw:@"unsubscribe"];
    MCOIMAPSearchOperation* searchOperation = [session searchExpressionOperationWithFolder:@"INBOX" expression: expr];
    [tableSubject removeAllObjects];
    [tableDate removeAllObjects];
    [searchOperation start:^(NSError *err, MCOIndexSet *searchResult) {
        fetch =
        [session fetchMessagesByUIDOperationWithFolder:@"INBOX"
                                           requestKind:requestKind
                                                  uids:searchResult];
        [fetch start:^(NSError *err, NSArray *msgs, MCOIndexSet *vanished) {
            
            NSLog(@"msg count %lu",[msgs count]);
            for (int i = 0; i < [msgs count]; i++) {
                MCOIMAPMessage *m = msgs[i];
                NSString* mailbox = m.header.from.mailbox;
                if (![mailboxSet containsObject:mailbox]) {
                    NSLog(@"%@",mailbox);
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
                                    NSLog(@" first child %@",[[element firstChild] content]);
                                    NSString * url = [element objectForKey:@"href"];
                                    NSLog(@"%@",url);
                                    email.unsubscribe_url = url;
                                    
                                    
                                    NSURLRequest * urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
                                    NSHTTPURLResponse * response = nil;
                                    NSError * error = nil;
                                    NSData * data = [NSURLConnection sendSynchronousRequest:urlRequest
                                                                          returningResponse:&response
                                                                                      error:&error];
                                    
                                    if (error == nil)
                                    {
                                        NSLog(@"in if %ld",[response statusCode]);
                                        if ([response statusCode] == 200) {
                                            email.unsubscribed = true;
                                        }
                                    }else{
                                        NSLog(@"in else %ld",[response statusCode]);
                                    }
                                }
                            }
                        }];}
                    [allMails addObject:email];
                }
                [tableView reloadData];
            }
        }];
    }];
}


- (void) retrieveAll{
    
    
    
    MCOIMAPSession *session = [[MCOIMAPSession alloc] init];
    session.hostname = @"imap.gmail.com";
    session.port = 993;
    session.username = [self.user getUid];
    session.password = [self.user getPwd];
    session.connectionType = MCOConnectionTypeTLS;
    
    
    //[MCOIMAPSearchExpression searchHeader:@"Message-ID" value:@"themessage@id"]
    __block MCOIMAPFetchMessagesOperation *fetch;
    NSLog(@"%ld",[mailboxSet count]);
    Mail* m =  [[Mail alloc] init];
    
    m = [mailboxSet anyObject];
    
    uint64_t mid = (m.message_id);
    NSLog(@"after %ld",[mailboxSet count]);
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
    
    [searchOperation start:^(NSError *err, MCOIndexSet *searchResult) {
        fetch =
        [session fetchMessagesByUIDOperationWithFolder:@"INBOX"
                                           requestKind:requestKind
                                                  uids:searchResult];
        [fetch start:^(NSError *err, NSArray *msgs, MCOIndexSet *vanished) {
            
            NSLog(@"msg count %lu",[msgs count]);
            for (int i = 0; i < [msgs count]; i++) {
                MCOIMAPMessage *m = msgs[i];
                NSString* mailbox = m.header.from.mailbox;
                if (![mailboxSet containsObject:mailbox]) {
                    NSLog(@"%@",mailbox);
                    [mailboxSet addObject:mailbox];
                    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                    [dateFormatter setDateFormat:@"MM-dd-YY HH:mm"];
                    NSString *dateString = [dateFormatter stringFromDate:m.header.date];
                    Mail *email = [[Mail alloc]
                                   initWithSubject:(NSString*)m.header.subject
                                   Date:(NSString*)dateString
                                   msgID :(uint64_t) [m gmailMessageID]];
                    email.mailbox = mailbox;
                    
                    [allMails addObject:email];
                }
                [tableView reloadData];
            }
        }];
    }];

    
}


@end

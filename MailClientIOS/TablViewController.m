//
//  TablViewController.m
//  MailClientIOS
//
//  Created by Lakshmi Kollapudi on 5/25/15.
//  Copyright (c) 2015 myOrg. All rights reserved.
//

#import "TablViewController.h"

@interface TablViewController ()

@end

@implementation TablViewController
@synthesize user = _user;
@synthesize sender = _sender;
@synthesize sender_id = _sender_id;
@synthesize tableView;
NSMutableArray *tableData;
NSMutableArray *tableDate;;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.userInteractionEnabled = YES;
    tableData = [[NSMutableArray alloc] init];
    tableDate = [[NSMutableArray alloc] init];
    //NSLog(@"cred%@, %@",[self.user getUid], [self.user getPwd]);
    [self retrieveUnsubscribe];
    
//    switch (self.sender_id) {
//        case 0:
//            [self retrieveAll];
//            break;
//        case 1:
//            [self retrieveUnsubscribe];
//            break;
//        default:
//            break;
//    }
    
   
    
}

-(void) retrieveAll{
    IMAP *  imap_channel = [[IMAP alloc] init];
    MCOIMAPFetchMessagesOperation * fOp = [imap_channel retrieveUnsubscribeHeaderOp: self.user];
    [fOp start:^(NSError *err, NSArray *msgs, MCOIndexSet *vanished) {
        NSLog(@"count %lu",[msgs count]);
        for (int i = 0; i < [msgs count]; i++) {
            MCOIMAPMessage *m = msgs[i];
            if (m.header.subject != nil) {
                NSString *dateString = [NSDateFormatter localizedStringFromDate:m.header.date
                                                                      dateStyle:NSDateFormatterShortStyle
                                                                      timeStyle:NSDateFormatterFullStyle];
                NSString *header = [m.header.subject stringByAppendingString:dateString];
                [tableData addObject:header];
                [tableDate addObject:m.header.sender.displayName];
                NSLog(@"%@",header);
            }
            [tableView reloadData];
            
            //  MCOIMAPFetchContentOperation *operation = [session fetchMessageByUIDOperationWithFolder:@"INBOX"uid:m.uid];
            //            [operation start:^(NSError *error, NSData *data) {
            //                MCOMessageParser *messageParser = [[MCOMessageParser alloc] initWithData:data];
            //                NSString *msgHTMLBody = [messageParser ];
            //                NSLog(@"%@", m.header.subject);
            //            }];
        }
    }];
}

- (void) retrieveUnsubscribe{
    
    MCOIMAPSession *session = [[MCOIMAPSession alloc] init];
    session.hostname = @"imap.gmail.com";
    session.port = 993;
    session.username = [self.user getUid];
    session.password = [self.user getPwd];
    session.connectionType = MCOConnectionTypeTLS;
    
    __block MCOIMAPFetchMessagesOperation *fetch;
    
    //NSLog(@"imap id%@, pwd %@", user.getUid, user.getPwd);
    MCOIMAPMessagesRequestKind requestKind = MCOIMAPMessagesRequestKindFullHeaders;
    MCOIMAPSearchExpression * expr = [MCOIMAPSearchExpression searchGmailRaw:@"unsubscribe"];
    MCOIMAPSearchOperation* searchOperation = [session searchExpressionOperationWithFolder:@"INBOX" expression: expr];
    [searchOperation start:^(NSError *err, MCOIndexSet *searchResult) {
        fetch =
        [session fetchMessagesByUIDOperationWithFolder:@"INBOX"
                                           requestKind:requestKind
                                                  uids:searchResult];
        [fetch start:^(NSError *err, NSArray *msgs, MCOIndexSet *vanished) {
            
            NSLog(@"msg count %lu",[msgs count]);
            for (int i = 0; i < [msgs count]; i++) {
                MCOIMAPMessage *m = msgs[i];
                if (m.header.subject != nil) {
                    NSString *dateString = [NSDateFormatter localizedStringFromDate:m.header.date
                                                                          dateStyle:NSDateFormatterShortStyle
                                                                          timeStyle:NSDateFormatterFullStyle];
                    NSString *header = [m.header.subject stringByAppendingString:dateString];
                   // NSLog(@"%@",header);
                    [tableData addObject:header];
                    [tableView reloadData];
                }
            }
        }];
    }];
    

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [tableData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleSubtitle
                reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.text = [tableData objectAtIndex: [indexPath row]];
 
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

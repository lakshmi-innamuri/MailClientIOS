//
//  IMAP.m
//  MailClientIOS
//
//  Created by Lakshmi Kollapudi on 5/25/15.
//  Copyright (c) 2015 myOrg. All rights reserved.
//

#import "IMAP.h"

@implementation IMAP

@synthesize session = _session;
@synthesize fetchOp = _fetchOp;

- (BOOL) authenticateId: (NSString*) uid password: (NSString*) pwd{
    
    __block BOOL valid;
 /*   @try {
    MCOAccountValidator *validate = [[MCOAccountValidator alloc]init];
    [validate imapStart:^(NSError *err) {
        NSLog(@"error %@",err);
        NSLog(@"ID %@, PWD %@",uid,pwd);
        if(err == nil){
            valid = true;
        }
    }];
    } @catch (NSException* e) {
 
    }
 */
    return valid;
}


- (MCOIMAPFetchMessagesOperation*) retrieveHeaders: (User*) user{
    
    //return fetch op ; table view controller starts the operation
    
    MCOIMAPSession *session = [[MCOIMAPSession alloc] init];
    session.hostname = @"imap.gmail.com";
    session.port = 993;
    session.username = user.getUid;
    session.password = user.getPwd;
    session.connectionType = MCOConnectionTypeTLS;
    MCOIndexSet *uidSet = [MCOIndexSet indexSetWithRange:MCORangeMake(1,UINT64_MAX)];
    MCOIMAPMessagesRequestKind requestKind = MCOIMAPMessagesRequestKindFullHeaders | MCOIMAPMessagesRequestKindInternalDate;
    MCOIMAPFetchMessagesOperation *fetchOp =
    [session fetchMessagesByUIDOperationWithFolder:@"INBOX"
                                       requestKind:requestKind
                                              uids:uidSet];
    
    return fetchOp;
}

- (MCOIMAPFetchMessagesOperation*) retrieveUnsubscribeHeaderOp:(User *)user{

    //return search based fetch op ; controller starts operation
    
    MCOIMAPSession *session = [[MCOIMAPSession alloc] init];
    session.hostname = @"imap.gmail.com";
    session.port = 993;
    session.username = user.getUid;
    session.password = user.getPwd;
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
    }];
    
    return fetch;
}

-(void) retrieveAll{
    IMAP *  imap_channel = [[IMAP alloc] init];
    User* user;
    MCOIMAPFetchMessagesOperation * fOp = [imap_channel retrieveUnsubscribeHeaderOp: user];
    [fOp start:^(NSError *err, NSArray *msgs, MCOIndexSet *vanished) {
        NSLog(@"count %lu",[msgs count]);
        for (int i = 0; i < [msgs count]; i++) {
            MCOIMAPMessage *m = msgs[i];
            if (m.header.subject != nil) {
                NSString *dateString = [NSDateFormatter localizedStringFromDate:m.header.date
                                                                      dateStyle:NSDateFormatterShortStyle
                                                                      timeStyle:NSDateFormatterFullStyle];
                NSString *header = [m.header.subject stringByAppendingString:dateString];
                NSLog(@"%@",header);
//                [tableSubject addObject:m.header.subject];
//                [tableDate addObject:dateString];
//                [tableData addObject:m.header.sender.displayName];

            }
//            [tableView reloadData];
            
            //  MCOIMAPFetchContentOperation *operation = [session fetchMessageByUIDOperationWithFolder:@"INBOX"uid:m.uid];
            //            [operation start:^(NSError *error, NSData *data) {
            //                MCOMessageParser *messageParser = [[MCOMessageParser alloc] initWithData:data];
            //                NSString *msgHTMLBody = [messageParser ];
            //                NSLog(@"%@", m.header.subject);
            //            }];
        }
    }];
}

//- (void) retrieveUnsubscribe{
//    
//    MCOIMAPSession *session = [[MCOIMAPSession alloc] init];
//    session.hostname = @"imap.gmail.com";
//    session.port = 993;
//    session.username = [self.user getUid];
//    session.password = [self.user getPwd];
//    session.connectionType = MCOConnectionTypeTLS;
//    
//    __block MCOIMAPFetchMessagesOperation *fetch;
//    
//    //NSLog(@"imap id%@, pwd %@", user.getUid, user.getPwd);
//    MCOIMAPMessagesRequestKind requestKind = MCOIMAPMessagesRequestKindFullHeaders;
//    MCOIndexSet *uidSet = [MCOIndexSet indexSetWithRange:MCORangeMake(1,UINT64_MAX)];
//    //    MCOIMAPSearchExpression * expr = [MCOIMAPSearchExpression searchGmailRaw:@"unsubscribe"];
//    //    MCOIMAPSearchOperation* searchOperation = [session searchExpressionOperationWithFolder:@"INBOX" expression: expr];
//    //    [searchOperation start:^(NSError *err, MCOIndexSet *searchResult) {
//    fetch =
//    [session fetchMessagesByUIDOperationWithFolder:@"INBOX"
//                                       requestKind:requestKind
//                                              uids:uidSet];
//    [fetch start:^(NSError *err, NSArray *msgs, MCOIndexSet *vanished) {
//        
//        NSLog(@"msg count %lu",[msgs count]);
//        for (int i = 0; i < [msgs count]; i++) {
//            MCOIMAPMessage *m = msgs[i];
//            if (m.header.subject != nil) {
//                
//                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//                [dateFormatter setDateFormat:@"MM-dd-YY HH:mm"];
//                NSString *dateString = [dateFormatter stringFromDate:m.header.date];
//                NSLog(@"%@",dateString);
//                
//                [tableSubject addObject:m.header.subject];
//                [tableDate addObject:dateString];
//                //[tableData addObject:m.header.sender.displayName];
//            }
//            [tableView reloadData];
//        }
//    }];
//    
//}

@end

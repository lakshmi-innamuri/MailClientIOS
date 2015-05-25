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
    
    MCOIMAPSession *session = [[MCOIMAPSession alloc] init];
    session.hostname = @"imap.gmail.com";
    session.port = 993;
    session.username = user.getUid;
    session.password = user.getPwd;
    session.connectionType = MCOConnectionTypeTLS;
    
    MCOIndexSet *uidSet = [MCOIndexSet indexSetWithRange:MCORangeMake(1,UINT64_MAX)];
    MCOIMAPMessagesRequestKind requestKind = MCOIMAPMessagesRequestKindFullHeaders;
    
    MCOIMAPFetchMessagesOperation *fetchOp =
    [session fetchMessagesByUIDOperationWithFolder:@"INBOX"
                                       requestKind:requestKind
                                              uids:uidSet];
    [fetchOp start:^(NSError *err, NSArray *msgs, MCOIndexSet *vanished) {
    }];

    return fetchOp;
}
@end

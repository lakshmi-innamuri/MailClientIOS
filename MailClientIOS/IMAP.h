//
//  IMAP.h
//  MailClientIOS
//
//  Created by Lakshmi Kollapudi on 5/25/15.
//  Copyright (c) 2015 myOrg. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <MailCore/MailCore.h>
#include "User.h"
@interface IMAP : NSObject

@property (nonatomic) MCOIMAPSession *session;
@property (nonatomic) MCOIMAPFetchMessagesOperation *fetchOp;


- (BOOL) authenticateId: (NSString*) uid password: (NSString*) pwd;
- (MCOIMAPFetchMessagesOperation*) retrieveHeaders: (User*) user;

@end

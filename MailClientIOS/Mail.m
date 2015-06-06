//
//  Mail.m
//  MailClientIOS
//
//  Created by Lakshmi Kollapudi on 6/3/15.
//  Copyright (c) 2015 myOrg. All rights reserved.
//

#import "Mail.h"

@implementation Mail
- (Mail*)initWithSubject:(NSString*)subject Date:(NSString*)date msgID :(uint64_t) msg_id{
    self.subject = subject;
    self.date = date;
    self.message_id = (msg_id);
    
    return self;
}

@end

//
//  Mail.h
//  MailClientIOS
//
//  Created by Lakshmi Kollapudi on 6/3/15.
//  Copyright (c) 2015 myOrg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Mail : NSObject

@property(nonatomic) NSString* subject;
@property(nonatomic) NSString* mailbox;
@property(nonatomic) NSString* date;
@property(nonatomic) uint64_t message_id;
- (Mail*)initWithSubject:(NSString*)subject Date:(NSString*)date msgID :(uint64_t) msg_id;
@end



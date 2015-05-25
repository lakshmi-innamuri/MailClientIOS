//
//  User.m
//  MailClientIOS
//
//  Created by Lakshmi Kollapudi on 5/25/15.
//  Copyright (c) 2015 myOrg. All rights reserved.
//

#import "User.h"

@implementation User

@synthesize uid = _uid;
@synthesize pwd = _pwd;

-(void) setUid: (NSString*) uid{
    _uid = uid;
}

-(void) setPwd: (NSString*) pwd{
    _pwd = pwd;
}

-(NSString*) getUid{
    return _uid;
}

-(NSString*) getPwd{
    return _pwd;
}
@end

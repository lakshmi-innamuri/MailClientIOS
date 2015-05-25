//
//  User.h
//  MailClientIOS
//
//  Created by Lakshmi Kollapudi on 5/25/15.
//  Copyright (c) 2015 myOrg. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface User : NSObject

@property (nonatomic) NSString* uid;
@property (nonatomic) NSString* pwd;

-(void) setUid: (NSString*) uidd;
-(void) setPwd: (NSString*)pwdd;

-(NSString*) getUid;
-(NSString*) getPwd;


@end

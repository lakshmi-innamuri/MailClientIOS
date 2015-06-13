//
//  TablViewController.h
//  MailClientIOS
//
//  Created by Lakshmi Kollapudi on 5/25/15.
//  Copyright (c) 2015 myOrg. All rights reserved.
//

#import <UIKit/UIKit.h>
#include <MailCore/MailCore.h>
#import "User.h"
#import "IMAP.h"


@interface TablViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>{
    
}
- (IBAction)unsubscribeEmails:(id)sender;
- (void) retrieveAll;
- (void) unsubscribe;
//- (void) retrieveUnsubscribe;
- (IBAction)unsubscribeAll:(id)sender;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic) User* user;
@property(nonatomic) NSString* sender;
@property(nonatomic) int sender_id;


@end

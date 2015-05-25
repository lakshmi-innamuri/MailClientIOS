//
//  ViewController.m
//  MailClientIOS
//
//  Created by Lakshmi Kollapudi on 5/24/15.
//  Copyright (c) 2015 myOrg. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()


@end

@implementation ViewController

@synthesize id_user;
@synthesize pwd_user;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)retrieve {
    
    [[NSUserDefaults standardUserDefaults] setObject:id_user.text forKey:@"pref_id"];
    [[NSUserDefaults standardUserDefaults] setObject:pwd_user.text forKey:@"pref_pwd"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    //call user.authenticate
    User *  user = [[User alloc] init];
    [user setUid:id_user.text];
    [user setPwd:pwd_user.text];
    
    IMAP *  imap_channel = [[IMAP alloc] init];
    NSLog(@"id:%@ pwd:%@ ",[user getUid],[user getPwd]);
    MCOIMAPFetchMessagesOperation * fOp = [imap_channel retrieveHeaders: user];
        [fOp start:^(NSError *err, NSArray *msgs, MCOIndexSet *vanished) {
    
            for (int i = 0; i < [msgs count]; i++) {
                MCOIMAPMessage *m = msgs[i];
                            NSLog(@"%@", m.header.subject);
                            NSLog(@"%@", m.header.sender);
//                if (m.header.subject != nil) {
//                    [tableData addObject:m.header.subject];
//                }
//                [self.tabView reloadData];
    
                //            MCOIMAPFetchContentOperation *operation = [session fetchMessageByUIDOperationWithFolder:@"INBOX" uid:m.uid];
                //
                //            [operation start:^(NSError *error, NSData *data) {
                //                MCOMessageParser *messageParser = [[MCOMessageParser alloc] initWithData:data];
                //
                //              //  NSString *msgHTMLBody = [messageParser ];
                //                NSLog(@"%@", m.header.subject);
                //            }];
            }
            //NSLog(@"COunt in init %lu",[tableData count]);
            
            
        }];
    
    
//    if ([imap_channel authenticateId:[user getUid] password: [user getPwd]]) {
//        NSLog(@"valid");
//            //navigate to tab view - tab view did load calls user.retrieveMails
//    }else
//        NSLog(@"invalid");

}
@end

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
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{

    if ([[segue identifier] isEqualToString:@"retrieve_segue"]) {
        User *  user = [[User alloc] init];
        [user setUid:id_user.text];
        [user setPwd:pwd_user.text];
        //NSLog(@"segue id%@, pwd %@", user.getUid, user.getPwd);
        TablViewController *table = segue.destinationViewController;
        table.user = user;
        table.sender_id = 0;
    }
}

@end

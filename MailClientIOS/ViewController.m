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
    //navigate to tab view - tab view did load calls user.retrieveMails
}
@end

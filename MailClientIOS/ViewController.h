//
//  ViewController.h
//  MailClientIOS
//
//  Created by Lakshmi Kollapudi on 5/24/15.
//  Copyright (c) 2015 myOrg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IMAP.h"
#import "User.h"

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *id_user;
@property (weak, nonatomic) IBOutlet UITextField *pwd_user;
- (IBAction)retrieve;

@end


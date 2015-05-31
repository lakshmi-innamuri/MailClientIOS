//
//  MailItemTableViewCell.h
//  MailClientIOS
//
//  Created by Lakshmi Kollapudi on 5/29/15.
//  Copyright (c) 2015 myOrg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MailItemTableViewCell : UITableViewCell

@property (copy,nonatomic) NSString* senderName;
@property (copy,nonatomic) NSString* subject;
@property (copy,nonatomic) NSString* sentDate;


-(void) setSender:(NSString*) s;
@end

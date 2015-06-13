//
//  MailItemTableViewCell.m
//  MailClientIOS
//
//  Created by Lakshmi Kollapudi on 5/29/15.
//  Copyright (c) 2015 myOrg. All rights reserved.
//

#import "MailItemTableViewCell.h"

@implementation MailItemTableViewCell{
    UILabel* _senderValue;
    UILabel* _subjectValue;
    UILabel* _sentDateLabel;
}

- (void)awakeFromNib {
    // Initialization code
}

-(id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
//        CGRect labelRectange = CGRectMake(0,5,50,30);
//        UILabel *senderLabel = [[UILabel alloc] initWithFrame:labelRectange];
//        senderLabel.textAlignment = NSTextAlignmentCenter;
//        senderLabel.text = _senderValue;
//        [self.contentView addSubview:senderLabel];
        
        //TODO: cell relative positioning
        //use autolayout through code

        
        
        CGRect labelRectange = CGRectMake(10,5,100,15);
        _senderValue = [[UILabel alloc] initWithFrame:labelRectange];
        [self.contentView addSubview:_senderValue];
     
        CGRect labelRectange1 = CGRectMake(10,25,300,15);
        _subjectValue = [[UILabel alloc] initWithFrame:labelRectange1];
        [self.contentView addSubview:_subjectValue];
        
        CGRect labelRectange2 = CGRectMake(300,25,100,15);
        _sentDateLabel = [[UILabel alloc] initWithFrame:labelRectange2];
        [self.contentView addSubview:_sentDateLabel];
    }
    return self;
}

-(void) setSender:(NSString*) s{
    if(![s isEqualToString:_senderName]){
        _senderName = [s copy];
        _senderValue.text = _senderName;
    }
}

-(void) setSubject:(NSString*) sub{
    if(![sub isEqualToString:_subject]){
        _subject = [sub copy];
        _subjectValue.text = _subject;
    }
}

-(void) setSentDate:(NSString*) sDate{
    if(![sDate isEqualToString:_sentDate]){
        _sentDate = [sDate copy];
        _sentDateLabel.text = _sentDate;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

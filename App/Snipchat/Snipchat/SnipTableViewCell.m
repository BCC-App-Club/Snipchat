//
//  SnipTableViewCell.m
//  Snipchat
//
//  Created by Ari Fiorino on 11/20/17.
//  Copyright © 2017 Azul Engineering. All rights reserved.
//

#import "SnipTableViewCell.h"

@implementation SnipTableViewCell

-(void)configureFromSnip:(Snip*)snip{
    _delegate=(AppDelegate*)[[UIApplication sharedApplication] delegate];
    _snip=snip;
    
    if ([snip.fromUsername isEqualToString:_delegate.username]){ //Sent
        if (snip.seen){
            _sentRecievedImageView.image=[UIImage imageNamed:@"Sent Seen.png"];
        }else{
            _sentRecievedImageView.image=[UIImage imageNamed:@"Sent Not Seen.png"];
        }
        _usernameLabel.text=[NSString stringWithFormat:@"%@ (%@)",snip.toUsername, snip.filename];
    }else{ //Recieved
        if (snip.seen){
            _sentRecievedImageView.image=[UIImage imageNamed:@"Recieved Seen.png"];
        }else{
            _sentRecievedImageView.image=[UIImage imageNamed:@"Recieved Not Seen.png"];
        }
        _usernameLabel.text=[NSString stringWithFormat:@"%@ (%@)",snip.fromUsername, snip.filename];

    }
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

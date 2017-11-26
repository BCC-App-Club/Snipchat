//
//  SnipTableViewCell.h
//  Snipchat
//
//  Created by Ari Fiorino on 11/20/17.
//  Copyright © 2017 Azul Engineering. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "Snip.h"

@interface SnipTableViewCell : UITableViewCell

@property AppDelegate* delegate;
@property Snip* snip;
@property IBOutlet UILabel* usernameLabel;
@property IBOutlet UIImageView* sentRecievedImageView;

-(void)configureFromSnip:(Snip*)snip;
@end

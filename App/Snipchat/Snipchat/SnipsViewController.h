//
//  SnipsViewController.h
//  Snipchat
//
//  Created by Ari Fiorino on 11/20/17.
//  Copyright © 2017 Azul Engineering. All rights reserved.
//

#import "AppDelegate.h"
#import <UIKit/UIKit.h>

@interface SnipsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property AppDelegate* delegate;
@property IBOutlet UIActivityIndicatorView* loadingIndicator;
@property IBOutlet UITableView* snipsTableView;
@property IBOutlet UIImageView* viewSnipImageView;

-(IBAction)tapScreen:(id)sender;

@end

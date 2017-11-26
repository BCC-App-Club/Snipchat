//
//  SendSnipViewController.h
//  Snipchat
//
//  Created by Ari Fiorino on 11/20/17.
//  Copyright © 2017 Azul Engineering. All rights reserved.
//

#import "AppDelegate.h"
#import <UIKit/UIKit.h>

@interface SendSnipViewController : UIViewController

@property AppDelegate* delegate;
@property IBOutlet UIActivityIndicatorView* loadingIndicator;
@property IBOutlet UITextField* toTextField;
@property IBOutlet UILabel* errorLabel;
@property IBOutlet UIButton* sendButton;
@property NSData* sendImageData;

-(IBAction)closeKeyboard:(id)sender;
-(IBAction)send:(id)sender;

@end

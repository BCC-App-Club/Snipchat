//
//  ViewController.h
//  Snipchat
//
//  Created by Ari Fiorino on 10/8/17.
//  Copyright © 2017 Azul Engineering. All rights reserved.
//

#import "AppDelegate.h"
#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController

@property AppDelegate* delegate;
@property IBOutlet UILabel* errorLabel;
@property IBOutlet UITextField* usernameTextField;
@property IBOutlet UITextField* passwordTextField;
@property IBOutlet UIActivityIndicatorView* loadingIndicator;
@property IBOutlet UIButton* loginButton;

-(IBAction)login:(id)sender;



@end


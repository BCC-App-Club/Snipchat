//
//  ViewController.h
//  Snipchat
//
//  Created by Ari Fiorino on 10/8/17.
//  Copyright © 2017 Azul Engineering. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property IBOutlet UITextField* usernameTextField;
@property IBOutlet UITextField* passwordTextField;
@property IBOutlet UIButton* loginButton;

-(IBAction)login:(id)sender;



@end


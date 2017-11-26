//
//  ViewController.m
//  Snipchat
//
//  Created by Ari Fiorino on 10/8/17.
//  Copyright © 2017 Azul Engineering. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _delegate=(AppDelegate*)[[UIApplication sharedApplication] delegate];
    _delegate.urlSession=[NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    _usernameTextField.text=@"arifiorino";
    _passwordTextField.text=@"123";
}


-(IBAction)login:(id)sender{
    [_loadingIndicator startAnimating];
    [_loginButton setTitle:@"" forState:UIControlStateNormal];
    [_loginButton setEnabled:NO];
    
    _delegate.username=[_usernameTextField.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];

    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://192.168.2.134:8080/login?username=%@&password=%@", _delegate.username, _passwordTextField.text]]];
    [request setHTTPMethod:@"GET"];

    
    [[_delegate.urlSession dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [_loadingIndicator stopAnimating];
            [_loginButton setTitle:@"Login" forState:UIControlStateNormal];
            [_loginButton setEnabled:YES];
            
            if (error){
                NSLog(@"Error: %@",error.localizedDescription);
                    _errorLabel.text=error.localizedDescription;
                return;
            }
            NSDictionary* responseDict=[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
            if (((NSHTTPURLResponse *)response).statusCode==404){
                NSLog(@"Error: 404 %@",[responseDict objectForKey:@"reason"]);
                
                    _errorLabel.text=[responseDict objectForKey:@"reason"];
                return;
            }
            
            
            _delegate.sessionId=[responseDict objectForKey:@"sessionId"];
            [self performSegueWithIdentifier:@"showCameraFromLogin" sender:self];
        });
    }] resume];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

//
//  SendSnipViewController.m
//  Snipchat
//
//  Created by Ari Fiorino on 11/20/17.
//  Copyright © 2017 Azul Engineering. All rights reserved.
//

#import "SendSnipViewController.h"

@interface SendSnipViewController ()

@end

@implementation SendSnipViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _delegate=(AppDelegate*)[[UIApplication sharedApplication] delegate];
}

-(IBAction)closeKeyboard:(id)sender{
    [_toTextField resignFirstResponder];
}

-(IBAction)send:(id)sender{
    [_sendButton setEnabled:NO];
    [_loadingIndicator startAnimating];
    
    NSString *BoundaryConstant = @"----------V2ymHFg03ehbqgZCaKO6jy";
    NSString* FileParamConstant = @"snip";
    
    UIImage *snipImage=[UIImage imageWithData:_sendImageData];
    _sendImageData=UIImageJPEGRepresentation(snipImage, .2);
    
    NSString* toUsername= [_toTextField.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://192.168.2.134:8080/sendSnip?sessionId=%@&toUsername=%@", _delegate.sessionId, toUsername]]];
    [request setHTTPMethod:@"POST"];
    
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", BoundaryConstant];
    [request setValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    NSMutableData *body = [NSMutableData data];
    
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", BoundaryConstant] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"image.jpg\"\r\n", FileParamConstant] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Type: image/jpeg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:_sendImageData];
    [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];

    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", BoundaryConstant] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [request setHTTPBody:body];
    
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[body length]];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    
    [[_delegate.urlSession dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [_loadingIndicator stopAnimating];
            [_sendButton setEnabled:YES];
        });
        if (error){
            NSLog(@"Error: %@",error.localizedDescription);
            return;
        }
        if (((NSHTTPURLResponse *)response).statusCode==404){
            NSDictionary* responseDict=[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
            NSLog(@"Error: 404 %@",[responseDict objectForKey:@"reason"]);
            dispatch_async(dispatch_get_main_queue(), ^{
                _errorLabel.text=[responseDict objectForKey:@"reason"];
            });
            return;
        }
        
        [self performSegueWithIdentifier:@"showCameraFromSend" sender:self];
    }] resume];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

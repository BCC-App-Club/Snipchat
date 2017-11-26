//
//  SnipsViewController.m
//  Snipchat
//
//  Created by Ari Fiorino on 11/20/17.
//  Copyright © 2017 Azul Engineering. All rights reserved.
//

#import "SnipsViewController.h"
#import "SnipTableViewCell.h"

@interface SnipsViewController ()

@end

@implementation SnipsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _delegate=(AppDelegate*)[[UIApplication sharedApplication] delegate];

}

-(void)viewDidAppear:(BOOL)animated{
    _delegate.snips=[[NSMutableArray alloc] init];
    [_snipsTableView reloadData];
    [_loadingIndicator startAnimating];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://192.168.2.134:8080/getSnips?sessionId=%@", _delegate.sessionId]]];
    [request setHTTPMethod:@"GET"];
    
    [[_delegate.urlSession dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error){
            NSLog(@"Error: %@",error.localizedDescription);
        }
        _delegate.snips=[[NSMutableArray alloc] init];
        NSArray* responseDict=[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        for (NSDictionary* snipDict in responseDict){
            [_delegate.snips addObject:[[Snip alloc] init]];
            [[_delegate.snips lastObject] initWithDictionary:snipDict];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [_loadingIndicator stopAnimating];
            [_snipsTableView reloadData];
        });
    }] resume];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_delegate.snips count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SnipTableViewCell* cell=[tableView dequeueReusableCellWithIdentifier:@"snipCell" forIndexPath:indexPath];
    int index=(int)[indexPath row];
    [cell configureFromSnip:[_delegate.snips objectAtIndex:index]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    int index=(int)[indexPath row];
    Snip* snip=[_delegate.snips objectAtIndex:index];
    if (!snip.seen && [snip.toUsername isEqualToString:_delegate.username]){
        [_loadingIndicator startAnimating];
        
        NSURL* url=[NSURL URLWithString:[NSString stringWithFormat:@"http://192.168.2.134:8080/viewSnip?sessionId=%@&filename=%@", _delegate.sessionId, snip.filename]];
        
        [[_delegate.urlSession downloadTaskWithURL:url completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
            if (error){
                NSLog(@"Error: %@",error.localizedDescription);
            }
            snip.seen=true;
            dispatch_async(dispatch_get_main_queue(), ^{
                _viewSnipImageView.image= [UIImage imageWithData: [NSData dataWithContentsOfURL:location]];
                _viewSnipImageView.hidden=NO;
                [_loadingIndicator stopAnimating];
                [_snipsTableView reloadData];
            });
        }] resume];
    }
}

-(IBAction)tapScreen:(id)sender{
    if (!_viewSnipImageView.hidden)
        _viewSnipImageView.hidden=YES;
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

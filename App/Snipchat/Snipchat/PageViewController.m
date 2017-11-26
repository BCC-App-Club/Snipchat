//
//  PageViewController.m
//  Snipchat
//
//  Created by Ari Fiorino on 11/20/17.
//  Copyright © 2017 Azul Engineering. All rights reserved.
//

#import "PageViewController.h"
#import "CameraViewController.h"
#import "SnipsViewController.h"

@interface PageViewController ()

@end

@implementation PageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.dataSource = self;
    
    [self setViewControllers:@[[self.storyboard instantiateViewControllerWithIdentifier:@"camera"]] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController{
    
    if ([viewController isKindOfClass:[SnipsViewController class]])
        return nil;
    
    return [self.storyboard instantiateViewControllerWithIdentifier:@"snips"];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController{
    
    if ([viewController isKindOfClass:[CameraViewController class]])
        return nil;
    
    return [self.storyboard instantiateViewControllerWithIdentifier:@"camera"];
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

//
//  BaseViewController.m
//  TCC
//
//  Created by Thiago Dorneles on 11/5/13.
//  Copyright (c) 2013 Thiago Dorneles. All rights reserved.
//

#import "BaseViewController.h"
#import "NewViewController.h"
#import "LoginViewController.h"

@interface BaseViewController () <UITabBarDelegate, UITabBarControllerDelegate>

@end

@implementation BaseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.view.tintColor = [UIColor redColor];
        // Custom initialization
    }
    return self;
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
//    if ([item.title isEqualToString:@"Novo"]) {
//        NewViewController *newViewController  = [NewViewController new];
//        [self presentViewController:newViewController animated:YES completion:nil];
//    }
    NSLog(@"selecionou");
}
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    NSLog(@"bbb");
    return YES;
}
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    NSLog(@"aaaa");
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	[[UITabBar appearance] setTintColor:[UIColor redColor]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Custom TabBar

// Create a view controller and setup it's tab bar item with a title and image
-(UIViewController*) viewControllerWithTabTitle:(NSString*)title image:(UIImage*)image
{
    UIViewController* viewController = [UIViewController new];
    viewController.tabBarItem = [[UITabBarItem new] initWithTitle:title image:image tag:0];
    return viewController;
}

// Create a custom UIButton and add it to the center of our tab bar
-(void) addCenterButtonWithImage:(UIImage*)buttonImage highlightImage:(UIImage*)highlightImage
{
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.autoresizingMask = UIViewAutoresizingFlexibleRightMargin |
                            UIViewAutoresizingFlexibleLeftMargin |
                            UIViewAutoresizingFlexibleBottomMargin |
                            UIViewAutoresizingFlexibleTopMargin;
    
    button.frame = CGRectMake(0.0, 0.0, buttonImage.size.width, buttonImage.size.height);
    [button setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [button setBackgroundImage:highlightImage forState:UIControlStateHighlighted];
    
    CGFloat heightDifference = buttonImage.size.height - self.tabBar.frame.size.height;
    if (heightDifference < 0)
        button.center = self.tabBar.center;
    else
    {
        CGPoint center = self.tabBar.center;
        center.y = center.y - heightDifference/2.0;
        button.center = center;
    }
    
    [self.view addSubview:button];
    
}

@end

//
//  BaseViewController.h
//  TCC
//
//  Created by Thiago Dorneles on 11/5/13.
//  Copyright (c) 2013 Thiago Dorneles. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UITabBarController

// Create a view controller and setup it's tab bar item with a title and image
-(UIViewController*) viewControllerWithTabTitle:(NSString*)title image:(UIImage*)image;

// Create a custom UIButton and add it to the center of our tab bar
-(void) addCenterButtonWithImage:(UIImage*)buttonImage highlightImage:(UIImage*)highlightImage;

@end

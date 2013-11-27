//
//  TDAppDelegate.m
//  TCC
//
//  Created by Thiago Dorneles on 9/22/13.
//  Copyright (c) 2013 Thiago Dorneles. All rights reserved.
//

#import "TDAppDelegate.h"
#import "Publish.h"
#import "User.h"
#import "BaseRequest.h"
#import "constants.h"
#import <RestKit/RestKit.h>

@implementation TDAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    [[UITabBar appearance] setTintColor:[UIColor redColor]];
    [[UIBarButtonItem appearance] setTintColor:[UIColor redColor]];
    
//    // Inicializando objeto User
//    User *user = [User new];
//    user.pk = 1;
//    user.name = @"Thiago Dorneles";
    
    
    // Initialize RestKit
    RKObjectManager *objectManager = [RKObjectManager managerWithBaseURLString:URL_SERVER];
    
    // Enable automatic network activity indicator management
    objectManager.client.requestQueue.showsNetworkActivityIndicatorWhenBusy = YES;
    
    // Setup our object mappings
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
//    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    [dateFormatter setDateFormat:@"YYYY-MM-DDTHH:mm:ss.sssZ"];
    [RKObjectMapping addDefaultDateFormatter:dateFormatter];
    
    RKObjectMapping *publishMapping = [RKObjectMapping mappingForClass:[Publish class]];
    [publishMapping mapKeyPath:@"title" toAttribute:@"title"];
    [publishMapping mapKeyPath:@"description" toAttribute:@"description"];
    [publishMapping mapKeyPath:@"location" toAttribute:@"location"];
    [publishMapping mapKeyPath:@"city" toAttribute:@"city"];
    [publishMapping mapKeyPath:@"quant_views" toAttribute:@"quant_views"];
    [publishMapping mapKeyPath:@"quant_blocks" toAttribute:@"quant_blocks"];
    [publishMapping mapKeyPath:@"user" toAttribute:@"user"];
    [publishMapping mapKeyPath:@"user_name" toAttribute:@"user_name"];
    [publishMapping mapKeyPath:@"tags" toAttribute:@"tags"];
    [publishMapping mapKeyPath:@"created_at" toAttribute:@"date"];
    [objectManager.mappingProvider setMapping:publishMapping forKeyPath:@"results"];
    [objectManager.router routeClass:[Publish class] toResourcePath:@"/publishs/"];
    [objectManager.router routeClass:[Publish class] toResourcePath:@"/publishs/" forMethod:RKRequestMethodPOST];
    
    RKObjectMapping *requestMapping = [RKObjectMapping mappingForClass:[BaseRequest class]];
    [requestMapping mapKeyPath:@"count" toAttribute:@"count"];
    [requestMapping mapKeyPath:@"next" toAttribute:@"next"];
    [objectManager.mappingProvider setMapping:requestMapping forKeyPath:@""];
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end

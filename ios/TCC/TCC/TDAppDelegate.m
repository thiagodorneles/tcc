//
//  TDAppDelegate.m
//  TCC
//
//  Created by Thiago Dorneles on 9/22/13.
//  Copyright (c) 2013 Thiago Dorneles. All rights reserved.
//

#import "TDAppDelegate.h"
#import "Publish.h"
#import "BaseRequest.h"
#import "constants.h"
#import <RestKit/RestKit.h>

@implementation TDAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    [[UITabBar appearance] setTintColor:[UIColor redColor]];
    [[UIBarButtonItem appearance] setTintColor:[UIColor redColor]];
    
    // Initialize RestKit
    RKObjectManager *objectManager = [RKObjectManager managerWithBaseURLString:@"http://192.168.1.20:8000/api/"];
    
    // Enable automatic network activity indicator management
    objectManager.client.requestQueue.showsNetworkActivityIndicatorWhenBusy = YES;
    
    // Setup our object mappings
    RKObjectMapping *imovelMapping = [RKObjectMapping mappingForClass:[Publish class]];
    [imovelMapping mapKeyPath:@"title" toAttribute:@"title"];
    [imovelMapping mapKeyPath:@"description" toAttribute:@"description"];
    [imovelMapping mapKeyPath:@"location" toAttribute:@"location"];
    [imovelMapping mapKeyPath:@"city" toAttribute:@"city"];
    [imovelMapping mapKeyPath:@"quant_views" toAttribute:@"quant_views"];
    [imovelMapping mapKeyPath:@"quant_blocks" toAttribute:@"quant_blocks"];
    [imovelMapping mapKeyPath:@"user" toAttribute:@"user"];
    [imovelMapping mapKeyPath:@"tags" toAttribute:@"tags"];
    [imovelMapping mapKeyPath:@"created_at" toAttribute:@"created_at"];
    
    [objectManager.mappingProvider setMapping:imovelMapping forKeyPath:@"results"];
    
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

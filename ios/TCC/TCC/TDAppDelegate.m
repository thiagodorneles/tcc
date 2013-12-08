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
#import "LoginViewController.h"

@implementation TDAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    [[UITabBar appearance] setTintColor:[UIColor redColor]];
    [[UIBarButtonItem appearance] setTintColor:[UIColor redColor]];
    
//    LoginViewController *loginVC = [LoginViewController new];
//    self.window.rootViewController = loginVC;
//    [self.window makeKeyAndVisible];
//    return YES;
    
//    [User removeLocal];
    
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:@"YYYY-MM-DDTHH:mm:ss.sssZ"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];

    // -------------------------------------------------------------------------------------
    // Initialize RestKit
    // -------------------------------------------------------------------------------------
    RKObjectManager *objectManager = [RKObjectManager managerWithBaseURLString:URL_SERVER];
    [RKObjectMapping addDefaultDateFormatter:dateFormatter];
    objectManager.client.requestQueue.showsNetworkActivityIndicatorWhenBusy = YES;
    
    // -------------------------------------------------------------------------------------
    // Mapeamento do objeto de Publish
    // -------------------------------------------------------------------------------------
    RKObjectMapping *publishMapping = [RKObjectMapping mappingForClass:[Publish class]];
    [publishMapping mapKeyPath:@"id" toAttribute:@"pk"];
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
    
    // -------------------------------------------------------------------------------------
    // Mapeamento do objeto de BaseRequest
    // -------------------------------------------------------------------------------------
    RKObjectMapping *requestMapping = [RKObjectMapping mappingForClass:[BaseRequest class]];
    [requestMapping mapKeyPath:@"count" toAttribute:@"count"];
    [requestMapping mapKeyPath:@"next" toAttribute:@"next"];
    [objectManager.mappingProvider setMapping:requestMapping forKeyPath:@""];
    
    // -------------------------------------------------------------------------------------
    // Mapeamento do objeto de User
    // -------------------------------------------------------------------------------------
    RKObjectMapping *userMapping = [RKObjectMapping mappingForClass:[User class]];
    [userMapping mapKeyPath:@"id" toAttribute:@"pk"];
    [userMapping mapKeyPath:@"name" toAttribute:@"name"];
    [userMapping mapKeyPath:@"email" toAttribute:@"email"];
    [userMapping mapKeyPath:@"created_at" toAttribute:@"created_at"];
    [userMapping mapKeyPath:@"image_url" toAttribute:@"image_url"];
    [userMapping mapKeyPath:@"twitter_id" toAttribute:@"twitter_id"];
    [userMapping mapKeyPath:@"twitter_user" toAttribute:@"twitter_user"];
    [userMapping mapKeyPath:@"twitter_token" toAttribute:@"twitter_token"];
    [userMapping mapKeyPath:@"facebook_id" toAttribute:@"facebook_id"];
    [userMapping mapKeyPath:@"facebook_user" toAttribute:@"facebook_user"];
    [userMapping mapKeyPath:@"facebook_token" toAttribute:@"facebook_token"];
    [userMapping mapKeyPath:@"publishs" toRelationship:@"publishs" withMapping:publishMapping];
    [objectManager.mappingProvider setMapping:userMapping forKeyPath:@""];

    RKObjectMapping *userSerializar = [userMapping inverseMapping];
    [objectManager.mappingProvider setSerializationMapping:userSerializar forClass:[User class]];
    
    [objectManager.router routeClass:[User class] toResourcePath:@"/users/"];
    [objectManager.router routeClass:[User class] toResourcePath:@"/users/" forMethod:RKRequestMethodPOST];
    

    
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

#pragma mark - Custom Methods

- (void)saveCustomObject:(User *)object key:(NSString *)key {
    NSData *encodedObject = [NSKeyedArchiver archivedDataWithRootObject:object];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:encodedObject forKey:key];
    [defaults synchronize];
    
}

- (User *)loadCustomObjectWithKey:(NSString *)key {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *encodedObject = [defaults objectForKey:key];
    User *object = [NSKeyedUnarchiver unarchiveObjectWithData:encodedObject];
    return object;
}

-(void)removeCustomObject:(NSString *)key
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:key];
    [defaults synchronize];
}

@end

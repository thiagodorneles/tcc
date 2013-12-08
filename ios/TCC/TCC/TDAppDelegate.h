//
//  TDAppDelegate.h
//  TCC
//
//  Created by Thiago Dorneles on 9/22/13.
//  Copyright (c) 2013 Thiago Dorneles. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

@interface TDAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

- (void)saveCustomObject:(User *)object key:(NSString *)key;
- (User *)loadCustomObjectWithKey:(NSString *)key;
- (void)removeCustomObject:(NSString *)key;

@end

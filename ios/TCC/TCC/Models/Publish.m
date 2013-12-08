//
//  Publish.m
//  TCC
//
//  Created by Thiago Dorneles on 11/23/13.
//  Copyright (c) 2013 Thiago Dorneles. All rights reserved.
//

#import "Publish.h"

@implementation Publish

@synthesize pk, title, description, created_at, date, location, city, user, tags, quant_views, quant_blocks;

- (id)activityViewControllerPlaceholderItem:(UIActivityViewController *)activityViewController;
{
    return self.title;
}
// called to determine data type. only the class of the return type is consulted. it should match what -itemForActivityType: returns later
- (id)activityViewController:(UIActivityViewController *)activityViewController itemForActivityType:(NSString *)activityType
{
    return self.title;
}
// called to fetch data after an activity is selected. you can return nil.



@end

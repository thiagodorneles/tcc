//
//  User.m
//  TCC
//
//  Created by Thiago Dorneles on 11/26/13.
//  Copyright (c) 2013 Thiago Dorneles. All rights reserved.
//

#import "User.h"
#import "TDAppDelegate.h"

#define USER_KEY @"user"
#define USER_KEY_PK @"user_pk"
#define USER_KEY_NAME @"user_name"
#define USER_KEY_EMAIL @"user_email"
#define USER_KEY_CREATED_AT @"user_created_at"
#define USER_KEY_TWITTER_ID @"user_twitter_id"
#define USER_KEY_TWITTER_TOKEN @"user_twitter_token"
#define USER_KEY_TWITTER_USER @"user_twitter_user"
#define USER_KEY_FACEBOOK_ID @"user_facebook_id"
#define USER_KEY_FACEBOOK_TOKEN @"user_facebook_token"
#define USER_KEY_FACEBOOK_USER @"user_facebook_user"
#define USER_KEY_PUBLISHS @"user_publishs"


@implementation User

@synthesize pk, name, email, created_at, twitter_id, twitter_token, twitter_user, facebook_id, facebook_token, facebook_user, publishs;


- (id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    if(self) {
        self.pk = [decoder decodeIntegerForKey:USER_KEY_PK];
        self.name = [decoder decodeObjectForKey:USER_KEY_NAME];
        self.created_at = [decoder decodeObjectForKey:USER_KEY_CREATED_AT];
        self.email = [decoder decodeObjectForKey:USER_KEY_EMAIL];
        self.twitter_id = [decoder decodeObjectForKey:USER_KEY_TWITTER_ID];
        self.twitter_token = [decoder decodeObjectForKey:USER_KEY_TWITTER_TOKEN];
        self.twitter_user = [decoder decodeObjectForKey:USER_KEY_TWITTER_USER];
        self.facebook_id = [decoder decodeObjectForKey:USER_KEY_FACEBOOK_ID];
        self.facebook_token = [decoder decodeObjectForKey:USER_KEY_FACEBOOK_TOKEN];
        self.facebook_user = [decoder decodeObjectForKey:USER_KEY_FACEBOOK_USER];
        self.publishs = [decoder decodeObjectForKey:USER_KEY_PUBLISHS];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeInt:self.pk forKey:USER_KEY_PK];
    [encoder encodeObject:self.name forKey:USER_KEY_NAME];
    [encoder encodeObject:self.created_at forKey:USER_KEY_CREATED_AT];
    [encoder encodeObject:self forKey:USER_KEY_EMAIL];
    [encoder encodeObject:self forKey:USER_KEY_TWITTER_ID];
    [encoder encodeObject:self forKey:USER_KEY_TWITTER_TOKEN];
    [encoder encodeObject:self forKey:USER_KEY_TWITTER_USER];
    [encoder encodeObject:self forKey:USER_KEY_FACEBOOK_ID];
    [encoder encodeObject:self forKey:USER_KEY_FACEBOOK_TOKEN];
    [encoder encodeObject:self forKey:USER_KEY_FACEBOOK_USER];
    [encoder encodeObject:self forKey:USER_KEY_PUBLISHS];
}

+(User *)getUser
{
    TDAppDelegate* appDelegate = (TDAppDelegate*)[[UIApplication sharedApplication] delegate];
    NSObject *user = [appDelegate loadCustomObjectWithKey:USER_KEY];
    if (user != nil) {
        return (User*)user;
    }
    return nil;
}

+(void)removeLocal
{
    TDAppDelegate* appDelegate = (TDAppDelegate*)[[UIApplication sharedApplication] delegate];
    [appDelegate removeCustomObject:USER_KEY];
}

-(void)saveLocal
{
    TDAppDelegate* appDelegate = (TDAppDelegate*)[[UIApplication sharedApplication] delegate];
    [appDelegate saveCustomObject:self key:USER_KEY];
}

@end

//
//  User.m
//  TCC
//
//  Created by Thiago Dorneles on 11/26/13.
//  Copyright (c) 2013 Thiago Dorneles. All rights reserved.
//

#import "User.h"

@implementation User

@synthesize pk, name, email, created_at, twitter_id, twitter_token,twitter_user, publishs;


- (id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    if(self) {
        self.pk = [decoder decodeIntegerForKey:@"user_pk"];
        self.name = [decoder decodeObjectForKey:@"user_name"];
        self.created_at = [decoder decodeObjectForKey:@"user_created_at"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeInt:self.pk forKey:@"user_pk"];
    [encoder encodeObject:self.name forKey:@"user_name"];
    [encoder encodeObject:self.created_at forKey:@"user_created_at"];
}

@end

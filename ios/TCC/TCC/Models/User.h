//
//  User.h
//  TCC
//
//  Created by Thiago Dorneles on 11/26/13.
//  Copyright (c) 2013 Thiago Dorneles. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject <NSCoding> {}

@property NSInteger pk;
@property NSString *name;
@property NSString *email;
@property NSDate *created_at;
@property NSString *image_url;
@property NSString *twitter_id;
@property NSString *twitter_token;
@property NSString *twitter_user;
@property NSString *facebook_id;
@property NSString *facebook_token;
@property NSString *facebook_user;
@property NSMutableArray *publishs;

+(User *)getUser;
-(void)saveLocal;
+(void)removeLocal;

@end

//
//  ProfileViewController.h
//  TCC
//
//  Created by Thiago Dorneles on 11/24/13.
//  Copyright (c) 2013 Thiago Dorneles. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfileViewController : UITableViewController
@property (weak, nonatomic) IBOutlet UILabel *labelUserName;
@property (weak, nonatomic) IBOutlet UILabel *labelUserCreated;
@property (weak, nonatomic) IBOutlet UILabel *labelTotalPublishs;
@property (weak, nonatomic) IBOutlet UIImageView *imageUser;

@end

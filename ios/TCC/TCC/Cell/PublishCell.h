//
//  PublishCell.h
//  TCC
//
//  Created by Thiago Dorneles on 11/24/13.
//  Copyright (c) 2013 Thiago Dorneles. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PublishCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *labelTitle;
@property (strong, nonatomic) IBOutlet UILabel *labelTags;
@property (strong, nonatomic) IBOutlet UILabel *labelUser;
@property (strong, nonatomic) IBOutlet UILabel *labelDate;
@property (strong, nonatomic) IBOutlet UIImageView *image;

@end

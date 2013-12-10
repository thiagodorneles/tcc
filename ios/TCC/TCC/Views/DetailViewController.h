//
//  DetailViewController.h
//  TCC
//
//  Created by Thiago Dorneles on 11/24/13.
//  Copyright (c) 2013 Thiago Dorneles. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Publish.h"

@interface DetailViewController : UITableViewController <UITableViewDataSource, UIActionSheetDelegate>

@property Publish *publish;

@end

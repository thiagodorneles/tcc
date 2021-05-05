//
//  ConfigNewViewController.h
//  TCC
//
//  Created by Thiago Dorneles on 12/10/13.
//  Copyright (c) 2013 Thiago Dorneles. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ConfigNewViewController : UITableViewController
- (IBAction)switchCamera:(id)sender;
@property (weak, nonatomic) IBOutlet UISwitch *switchCameraOption;

@end

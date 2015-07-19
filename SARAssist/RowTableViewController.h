//
//  RowTableViewController.h
//  SARAssist
//
//  Created by V-FEXrt on 7/18/15.
//  Copyright (c) 2015 V-FEXrt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface RowTableViewController : UITableViewController

@property (nonatomic, strong)PFObject *selectedArea;

@end

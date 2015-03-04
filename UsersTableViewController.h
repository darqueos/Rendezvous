//
//  UsersTableViewController.h
//  Rendezvous
//
//  Created by Cauê Silva on 03/03/15.
//  Copyright (c) 2015 Eduardo Quadros. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UsersTableViewController : UITableViewController

@property NSMutableArray *users;

@property (strong, nonatomic) IBOutlet UITableView *usersTableView;

@end

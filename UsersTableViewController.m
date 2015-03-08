//
//  UsersTableViewController.m
//  Rendezvous
//
//  Created by Cauê Silva on 03/03/15.
//  Copyright (c) 2015 Eduardo Quadros. All rights reserved.
//

#import "UsersTableViewController.h"
#import "ConfigurationViewController.h"
#import <Parse/Parse.h>
#import <ParseFacebookUtils/PFFacebookUtils.h>

@interface UsersTableViewController ()

@property NSString *currentUserID;

@end

@implementation UsersTableViewController

//==============================================================================
#pragma mark - Infos dos Users
//==============================================================================

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _users = [[NSMutableArray alloc]init];
    
    _currentUserID = [NSString stringWithFormat:@"%@", [[PFUser currentUser] objectId]];
    
    if (![_currentUserID isEqualToString:@"2hwTl1INIu"]) {
            [_users addObject:@{@"nome" : @"Aleph", @"foto" : @"aleph.jpg"}];
    }
    
    [_users addObject:@{@"nome" : @"Caue", @"foto" : @"caue.jpg"}];
    
    if (![_currentUserID isEqualToString:@"oEHf9XXQGq"]) {
        [_users addObject:@{@"nome" : @"Eduardo", @"foto" : @"eduardo.jpg"}];
    }

    if([PFFacebookUtils isLinkedWithUser:[PFUser currentUser]]){
        FBRequest *request = [FBRequest requestForMe];
        [request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
            if (!error) {
                // result is a dictionary with the user's Facebook data
                NSDictionary *userData = (NSDictionary *)result;
                NSString *name = userData[@"name"];
                NSLog(@"%@", name);
            }
        }];
    }
    
//    PFQuery *query = [PFQuery queryWithClassName:@"_User"];
//    [query setLimit:20];
//    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error){
//        if (!error) {
//            
//            NSLog(@"Objects: %lu", objects.count);
//            
//            NSLog(@"%@", [objects firstObject]);
//
//        } else {
//            NSLog(@"Error: %@ %@", error, [error userInfo]);
//        }
//    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

//==============================================================================


//==============================================================================
#pragma mark - Configuracao da Table View
//==============================================================================

// num de secoes
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{ return 1; }

// qtd de celulas
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{ return _users.count; }

//esconder barra de status
//-(BOOL) prefersStatusBarHidden { return YES; }

//==============================================================================


//==============================================================================
#pragma mark - Carregar Informacoes nas Células
//==============================================================================

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"userCell" forIndexPath:indexPath];
    
    // carregar contatos com fotos
    cell.textLabel.text = [[_users objectAtIndex:indexPath.row]objectForKey:@"nome"];
    cell.imageView.image = [UIImage imageNamed:[[_users objectAtIndex:indexPath.row]objectForKey:@"foto"]];
    
    return cell;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    ConfigurationViewController *vc = [segue destinationViewController];
    vc.userName = _users[_usersTableView.indexPathForSelectedRow.row][@"nome"];
    
}

@end

//==========================================================================================================================

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/




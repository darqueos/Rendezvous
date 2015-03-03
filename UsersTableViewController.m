//
//  UsersTableViewController.m
//  Rendezvous
//
//  Created by Cauê Silva on 03/03/15.
//  Copyright (c) 2015 Eduardo Quadros. All rights reserved.
//

#import "UsersTableViewController.h"

@interface UsersTableViewController ()

@end

@implementation UsersTableViewController

//==============================================================================
#pragma mark - Infos dos Users
//==============================================================================

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _users = @[@"Aleph Retamal", @"Caue Alves", @"Eduardo Quadros"];
    _numbers = @[@"(11)99973-7772", @"(11)96089-1415", @"(11)96318-2002"];
    _photos = @[@"aleph.jpg", @"caue.jpg", @"eduardo.jpg"];
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
-(BOOL) prefersStatusBarHidden { return YES; }

//==============================================================================


//==============================================================================
#pragma mark - Carregar Informacoes nas Células
//==============================================================================

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"userCell" forIndexPath:indexPath];
    
    //nomes
    cell.textLabel.text = _users[indexPath.row];
    
    return cell;
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/



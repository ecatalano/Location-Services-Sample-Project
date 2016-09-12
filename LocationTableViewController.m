//
//  LocationTableViewController.m
//  LostMans
//
//  Created by Elliot Catalano on 8/31/16.
//  Copyright © 2016 Elliot Catalano. All rights reserved.
//

#import "LocationTableViewController.h"
#import "LocationTableViewCell.h"
#import "LocationDetailViewController.h"
#import "LocationModel.h"
#import "URLServiceModel.h"

@interface LocationTableViewController ()

@property NSArray *locationItems;
@property LocationModel *selectedLocation;

@end

@implementation LocationTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNeedsStatusBarAppearanceUpdate];
    
    self.navigationItem.title = @"BU Night Life";
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    [self tableView].delegate = self;
    [self tableView].dataSource = self;
    
    URLServiceModel *model = [[URLServiceModel alloc]init];
    model.delegate = self;
    [model downloadItems];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self locationItems] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

-(void)itemsDownloadedWithItems:(NSArray *)items
{
    self.locationItems = items;
    [[self tableView] reloadData];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LocationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LocationTableViewCell" forIndexPath:indexPath];
    
    LocationModel *location = [self locationItems][indexPath.row];
    // Get references to labels of cell
    [cell nameLabel].text = location.name;
    if(location.name.length == 0){
        cell.nameLabel.text = location.fullName;
    }
    NSUInteger addressLength = [location.address length] - 22;
    [cell addressLabel].text = [location.address substringToIndex:addressLength];
    cell.addressLabel.adjustsFontSizeToFitWidth = YES;

    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self displayActionSheetForIndexPath:indexPath];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)displayActionSheetForIndexPath: (NSIndexPath *)indexPath {
    
    LocationModel *location = [self locationItems][indexPath.row];
    NSString *name;
    if(location.name.length!=0){
        name = location.name;
    }
    else{
        name = location.fullName;
    }
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil
                                                                   message:nil
                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *mapAction = [UIAlertAction actionWithTitle:@"Show on Map"
                                                           style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                               NSLog(@"Show on Map");
                                                           }];
    UIAlertAction *detailAction = [UIAlertAction actionWithTitle:@"More Details"
                                                           style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                               [self didTapLocationCellAtIndexPath:indexPath];
                                                           }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    
    [alert addAction:mapAction];
    [alert addAction:detailAction];
    [alert addAction:cancelAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}
-(void)didTapLocationCellAtIndexPath:(NSIndexPath *)indexPath
{
    LocationDetailViewController *detailViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"locationDetailViewController"];
    detailViewController.location = [[self locationItems]objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:detailViewController animated:YES];
}

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

@end

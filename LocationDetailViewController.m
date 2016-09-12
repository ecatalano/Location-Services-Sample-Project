//
//  LocationDetailViewController.m
//  LostMans
//
//  Created by Elliot Catalano on 9/5/16.
//  Copyright © 2016 Elliot Catalano. All rights reserved.
//

#import "LocationDetailViewController.h"

@interface LocationDetailViewController ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@end

@implementation LocationDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self nameLabel].text = [self location].fullName;
    self.addressLabel.text = [self location].address;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

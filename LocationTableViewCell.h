//
//  LocationTableViewCell.h
//  LostMans
//
//  Created by Elliot Catalano on 8/31/16.
//  Copyright © 2016 Elliot Catalano. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LocationTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@end

//
//  LocationTableViewController.h
//  LostMans
//
//  Created by Elliot Catalano on 8/31/16.
//  Copyright © 2016 Elliot Catalano. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "URLServiceModel.h"

@interface LocationTableViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate, URLServiceModelProtocol>

@end

//
//  URLServiceModel.h
//  LostMans
//
//  Created by Elliot Catalano on 8/31/16.
//  Copyright © 2016 Elliot Catalano. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol URLServiceModelProtocol;

@interface URLServiceModel : NSObject <NSURLSessionDataDelegate>

@property (nonatomic, weak) id<URLServiceModelProtocol> delegate;
@property NSMutableData *data;
-(void)downloadItems;

@end

@protocol URLServiceModelProtocol

@required
-(void)itemsDownloadedWithItems:(NSArray *)items;

@end

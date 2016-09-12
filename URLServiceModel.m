//
//  URLServiceModel.m
//  LostMans
//
//  Created by Elliot Catalano on 8/31/16.
//  Copyright © 2016 Elliot Catalano. All rights reserved.
//

#import "URLServiceModel.h"
#import "LocationModel.h"

@implementation URLServiceModel

-(void)downloadItems
{
    NSURL *url = [NSURL URLWithString:@"http://ecatalano.site88.net/service.php"];
    NSURLSession *session = [[NSURLSession alloc]init];
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
    
    if(self.data == nil){
        self.data = [[NSMutableData alloc]init];
    }
    
    NSURLSessionDataTask *task = [session dataTaskWithURL:url];
    [task resume];
}

-(void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data
{
    if(data!=nil){
        [self.data appendData:data];
    }
}

-(void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
{
    if (error != nil)
    {
        NSLog(@"Failed to download data");
    }
    else
    {
        NSLog(@"Data downloaded");
        [self parseJSON];
    }
}
-(void)parseJSON
{
    NSMutableArray *jsonResult = [[NSMutableArray alloc]init];
    jsonResult = [NSJSONSerialization JSONObjectWithData:self.data options:NSJSONReadingAllowFragments error:nil];
    NSDictionary *jsonElement;
    NSMutableArray *locations = [[NSMutableArray alloc]init];
    for(int i = 0; i < jsonResult.count; i++)
    {
        jsonElement = (NSDictionary *)jsonResult[i];
        
        LocationModel *location = [[LocationModel alloc]init];
        
        if(![jsonElement[@"Name"] isEqual:@""])
        {
            location.name = jsonElement[@"Name"];
        }
        if(![jsonElement[@"Full Name"] isEqual:@""])
        {
            location.fullName = jsonElement[@"Full Name"];
        }
        if(![jsonElement[@"Address"] isEqual:@""])
        {
            location.address = jsonElement[@"Address"];
        }
        if(![jsonElement[@"Latitude"] isEqual:@""])
        {
            location.latitude = jsonElement[@"Latitude"];
        }
        if(![jsonElement[@"Longitude"] isEqual:@""])
        {
            location.longitude = jsonElement[@"Longitude"];
        }
        if(![jsonElement[@"OpenDate"] isEqual:@""])
        {
            location.openDate = jsonElement[@"OpenDate"];
        }
        if(![jsonElement[@"OpenTime"] isEqual:@""])
        {
            location.openTime = jsonElement[@"OpenTime"];
        }
        [locations addObject:location];
    }
    dispatch_async(dispatch_get_main_queue(), ^(void){
        
        [self.delegate itemsDownloadedWithItems:locations];
    });
}


@end

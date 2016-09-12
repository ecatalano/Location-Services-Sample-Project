//
//  LocationMapViewController.m
//  LostMans
//
//  Created by Elliot Catalano on 8/31/16.
//  Copyright © 2016 Elliot Catalano. All rights reserved.
//

#import "LocationMapViewController.h"
#import "LocationDetailViewController.h"
#import "URLServiceModel.h"
#import "LocationModel.h"
#import <MapKit/MapKit.h>



@interface LocationMapViewController ()

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UIView *statusBar;
@property NSArray *locationItems;

@end

@implementation LocationMapViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.statusBar.backgroundColor = [UIColor colorWithRed:0.0 green:0.35 blue:0.26 alpha:.97];

    self.manager = [[CLLocationManager alloc]init];
    if([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined)
    {
        [self.manager requestWhenInUseAuthorization];
    }
    self.mapView.delegate = self;
    self.mapView.showsUserLocation = YES;
    self.mapView.showsBuildings = YES;
    [self.mapView setMapType:MKMapTypeStandard];
        
    [self createRegionForLocation];
    [self.manager startUpdatingLocation];
    
    URLServiceModel *model = [[URLServiceModel alloc]init];
    
    model.delegate = self;
    [model downloadItems];
}

-(void)viewDidAppear:(BOOL)animated
{
    [self centerRegionForLocation];
    [self setPins];
}

-(void)itemsDownloadedWithItems:(NSArray *)items
{
    self.locationItems = items;
    [self setPins];
}

-(void)setPins
{
    for(int i = 0; i < [self.locationItems count]; i++)
    {
        LocationModel *location = [[self locationItems] objectAtIndex:i];
        if(location.longitude.length!=0 && location.latitude.length!=0)
        {
            MKPointAnnotation *locationPoint = [[MKPointAnnotation alloc]init];
            CLLocationCoordinate2D  locationCoord = CLLocationCoordinate2DMake([location.latitude doubleValue], [location.longitude doubleValue]);
            
            locationPoint.coordinate = locationCoord;
            locationPoint.title = location.name;
            NSUInteger addressLength = [location.address length] - 22;
            locationPoint.subtitle = [location.address substringToIndex:addressLength];
            
            [self.mapView addAnnotation:locationPoint];
        }
    }
}

-(void)createRegionForLocation
{
    [self.mapView setUserTrackingMode:MKUserTrackingModeFollow animated:YES];
    CLLocation *location = [self.manager location];
    CLLocationCoordinate2D  coordinate = [location coordinate];
    _mapView.region = MKCoordinateRegionMakeWithDistance(coordinate, 250, 250);
}

-(void)centerRegionForLocation
{
    self.mapView.centerCoordinate = self.mapView.userLocation.location.coordinate;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (MKAnnotationView *)mapView:(MKMapView*)mapView
            viewForAnnotation:(id <MKAnnotation>)annotation
{
    if(annotation == mapView.userLocation){
        return nil;
    }
    
    MKPinAnnotationView *annotationView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"String"];
    if(!annotationView) {
        annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"String"];
        annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    }
    annotationView.enabled = YES;
    annotationView.canShowCallout = YES;
    
    return annotationView;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    
    LocationDetailViewController *detailViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"locationDetailViewController"];
    detailViewController.location = [self findLocationWithName:view.annotation.title];
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:detailViewController];
    
    detailViewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(dismissModalViewController)];
    
    [self presentViewController:navigationController animated:YES completion:nil];
}

-(void)dismissModalViewController
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(LocationModel *)findLocationWithName: (NSString *) name
{
    LocationModel *location = nil;
    for(int i = 0; i < [self.locationItems count]; i++)
    {
        location = [self.locationItems objectAtIndex:i];
        if(location.name == name)
        {
            return location;
        }
    }
    return location;
}

@end

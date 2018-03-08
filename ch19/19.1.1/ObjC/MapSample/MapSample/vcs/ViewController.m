#import "ViewController.h"
#import <MapKit/MapKit.h>

@interface ViewController ()

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end

@implementation ViewController

/***
 * 视图出现
 ****/
- (void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear: animated];
    
    //默认为标准地图
    self.mapView.mapType = MKMapTypeStandard;

    //实例化坐标位置
    CLLocation *location = [[CLLocation alloc] initWithLatitude:40.002240
                                                      longitude:116.323328];
    //调整地图位置和缩放比例
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, 10000, 10000);
    self.mapView.region = viewRegion;

}



- (IBAction)selectMapViewType:(id)sender
{
    UISegmentedControl* sc = (UISegmentedControl*)sender;
    
    switch (sc.selectedSegmentIndex)
    {
        case 1:
            self.mapView.mapType = MKMapTypeSatellite;//卫星地图
            break;
        case 2:
            self.mapView.mapType = MKMapTypeHybrid;//混合地图
            break;
        default:
            self.mapView.mapType = MKMapTypeHybridFlyover; //飞行模式混合地图
    }
}

@end

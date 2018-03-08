#import "ViewController.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface ViewController () <MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property(nonatomic, strong) CLLocationManager *locationManager;

@end

@implementation ViewController

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear: animated];
    
    self.mapView.mapType = MKMapTypeStandard;

    CLLocation *location = [[CLLocation alloc] initWithLatitude:40.002240 longitude:116.323328];
    //调整地图位置和缩放比例
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, 10000, 10000);
    self.mapView.region = viewRegion;
    
    //授权
    self.locationManager = [[CLLocationManager alloc] init];
    [self.locationManager requestWhenInUseAuthorization]; //请求使用时
    [self.locationManager requestAlwaysAuthorization];//请求每时

    self.mapView.showsUserLocation = TRUE; //显示用户位置
    self.mapView.userLocation.title = @"我在这里！"; //用户位置注释标题
    self.mapView.delegate = self;
    
}


- (IBAction)selectMapViewType:(id)sender {
    
    UISegmentedControl* sc = (UISegmentedControl*)sender;
    
    switch (sc.selectedSegmentIndex) {
        case 1:
            self.mapView.mapType = MKMapTypeSatellite;
            break;
        case 2:
            self.mapView.mapType = MKMapTypeHybrid;
            break;
        default:
            self.mapView.mapType = MKMapTypeStandard;
    }
}

#pragma mark --实现MKMapViewDelegate协议
/***
 * 地图加载完成回调
 ****/
- (void)mapViewDidFinishLoadingMap:(MKMapView *)mapView
{
    //开启用户追踪模式
    mapView.userTrackingMode =  MKUserTrackingModeFollowWithHeading;
}

@end

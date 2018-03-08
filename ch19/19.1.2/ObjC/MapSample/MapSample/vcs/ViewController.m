#import "ViewController.h"
#import <MapKit/MapKit.h>

@interface ViewController ()

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end

@implementation ViewController

- (void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear: animated];
    
    self.mapView.mapType = MKMapTypeStandard;

    [self placeCamera];
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
    
    [self placeCamera];
}

/***
 * 设置巡航相机
 ****/
-(void) placeCamera
{
    //设置3D相机
    MKMapCamera* mapCamera = [MKMapCamera camera];
    //2d坐标
    mapCamera.centerCoordinate = CLLocationCoordinate2DMake(40.002240, 116.323328);
    mapCamera.pitch = 60; //缩放比例
    mapCamera.altitude = 1000; //高度
    mapCamera.heading = 45;//视角
    
    //设置地图视图的camera属性
    self.mapView.camera = mapCamera;
}

@end

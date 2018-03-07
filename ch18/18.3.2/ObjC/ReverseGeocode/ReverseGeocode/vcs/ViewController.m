#import "ViewController.h"
#import <CoreLocation/CoreLocation.h>

@interface ViewController () <CLLocationManagerDelegate>

//经度
@property(weak, nonatomic) IBOutlet UITextField *txtLng;
//纬度
@property(weak, nonatomic) IBOutlet UITextField *txtLat;
//高度
@property(weak, nonatomic) IBOutlet UITextField *txtAlt;

@property(weak, nonatomic) IBOutlet UITextView *txtView;

@property(nonatomic, strong) CLLocationManager *locationManager;

@property(nonatomic, strong) CLLocation *currLocation;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.txtView.text = @"";

    //定位服务管理对象初始化
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.distanceFilter = 1000.0f;

    [self.locationManager requestWhenInUseAuthorization];
    [self.locationManager requestAlwaysAuthorization];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //开始定位
    [self.locationManager startUpdatingLocation];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    //停止定位
    [self.locationManager stopUpdatingLocation];
}

/***
 * 反编码
 ****/
- (IBAction)reverseGeocode:(id)sender
{
    //实例化地理位置编码/解码器
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];

    //反编码完成回调
    id onFinished=^(NSArray<CLPlacemark *> *placemarks, NSError *error)
    {
        if (error)
        {
            NSLog(@"Error is %@",error.localizedDescription);
        } else if ([placemarks count] > 0) //查找到地标
        {
            CLPlacemark *placemark = placemarks[0];
            NSString *name = placemark.name;//地标名
            
            self.txtView.text = name;
        }
    };
    //反编码地理位置
    [geocoder reverseGeocodeLocation:self.currLocation
                   completionHandler:onFinished];
}

#pragma mark -- Core Location委托方法用于实现位置的更新

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {

    self.currLocation = [locations lastObject];
    self.txtLat.text = [NSString stringWithFormat:@"%3.5f", self.currLocation.coordinate.latitude];
    self.txtLng.text = [NSString stringWithFormat:@"%3.5f", self.currLocation.coordinate.longitude];
    self.txtAlt.text = [NSString stringWithFormat:@"%3.5f", self.currLocation.altitude];

}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"error: %@", error);
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {

    if (status == kCLAuthorizationStatusAuthorizedAlways) {
        NSLog(@"已经授权");
    } else if (status == kCLAuthorizationStatusAuthorizedWhenInUse) {
        NSLog(@"当使用时候授权");
    } else if (status == kCLAuthorizationStatusDenied) {
        NSLog(@"拒绝");
    } else if (status == kCLAuthorizationStatusRestricted) {
        NSLog(@"受限");
    } else if (status == kCLAuthorizationStatusNotDetermined) {
        NSLog(@"用户还没有确定");
    }
}


@end

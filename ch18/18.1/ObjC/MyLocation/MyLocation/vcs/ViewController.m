#import "ViewController.h"
#import <CoreLocation/CoreLocation.h>

@interface ViewController () <CLLocationManagerDelegate>

//经度
@property (weak, nonatomic) IBOutlet UITextField *txtLng;
//纬度
@property (weak, nonatomic) IBOutlet UITextField *txtLat;
//高度
@property (weak, nonatomic) IBOutlet UITextField *txtAlt;

@property(nonatomic, strong) CLLocationManager *locationManager;

@end

@implementation ViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //初始化定位服务
    [self initLocServ];
}

/***
 * 视图将要出现的时候启动定位
 ****/
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //开始定位
    [self.locationManager startUpdatingLocation];
    NSLog(@"开始定位");
}

/***
 * 视图将要消失的时候结束定位
 ****/
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:<#animated#>];
    
    //停止定位
    [self.locationManager stopUpdatingLocation];
}

#pragma mark --  【定位】
/***
 * 初始化定位服务
 ****/
- (void)initLocServ
{
    //定位管理器
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;//最优节能与精度的定位
    self.locationManager.distanceFilter = 1000.0f;//有效距离过滤器1km
    self.locationManager.delegate = self;
    
    //使用时请求授权
    [self.locationManager requestWhenInUseAuthorization];
    //总是请求授权
    [self.locationManager requestAlwaysAuthorization];
}

#pragma mark -- Core Location委托方法用于实现位置的更新
/***
 * 更新位置
 ****/
- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations
{
    //当前最新定位
    CLLocation *currLocation = [locations lastObject];
    
    //纬度
    self.txtLat.text = [NSString stringWithFormat:@"%3.5f",
                        currLocation.coordinate.latitude];
    //精度
    self.txtLng.text = [NSString stringWithFormat:@"%3.5f",
                        currLocation.coordinate.longitude];
    //高度
    self.txtAlt.text = [NSString stringWithFormat:@"%3.5f",
                        currLocation.altitude];
    
}

/***
 * 定位失败
 ****/
- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
    NSLog(@"error: %@",error);
}

/***
 * 授权改变
 ****/
- (void)locationManager:(CLLocationManager *)manager
didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    
    if (status == kCLAuthorizationStatusAuthorizedAlways)
    {
        NSLog(@"已经授权");
    } else if (status == kCLAuthorizationStatusAuthorizedWhenInUse)
    {
        NSLog(@"当使用时候授权");
    } else if (status == kCLAuthorizationStatusDenied)
    {
        NSLog(@"拒绝");
    } else if (status == kCLAuthorizationStatusRestricted)
    {
        NSLog(@"受限");
    } else if (status == kCLAuthorizationStatusNotDetermined)
    {
        NSLog(@"用户还没有确定");
    }
}

@end

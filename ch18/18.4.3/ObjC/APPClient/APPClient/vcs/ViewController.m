#import "ViewController.h"
#import <CoreBluetooth/CoreBluetooth.h>
#import <CoreLocation/CoreLocation.h>

#define kUUID @"533F8EF4-EED2-4FEC-8566-84C242B0C636"
#define kID   @"com.51work6.AirLocate"

@interface ViewController () <CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *lblRegion;
@property (weak, nonatomic) IBOutlet UILabel *lblRanging;

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLBeaconRegion *region;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    
    [self.locationManager requestAlwaysAuthorization];
    
    //实例化ibeacon围栏客户端
    NSUUID* uuid = [[NSUUID alloc] initWithUUIDString: kUUID];
    self.region = [[CLBeaconRegion alloc] initWithProximityUUID:uuid identifier:kID];
    
    self.lblRegion.text = @"";
    self.lblRanging.text = @"";
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
    //开启区域（或围栏）监视
    [self.locationManager startMonitoringForRegion:self.region];
    //开启Beacon距离检测
    [self.locationManager startRangingBeaconsInRegion:self.region];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    //停止区域（或围栏）监视
    [self.locationManager stopMonitoringForRegion:self.region];
    //停止Beacon距离检测
    [self.locationManager stopRangingBeaconsInRegion:self.region];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma --实现CLLocationManagerDelegate委托协议
/***
 * 定位改变了围栏状态
 ****/
- (void)locationManager:(CLLocationManager *)manager
      didDetermineState:(CLRegionState)state //与围栏之间的状态
              forRegion:(CLRegion *)region//围栏
{
    
    switch (state) {
        case CLRegionStateInside:
            self.lblRegion.text = @"围栏内";
            break;
        case CLRegionStateOutside:
            self.lblRegion.text = @"围栏外";
            break;
        case CLRegionStateUnknown:
            self.lblRegion.text = @"未知";
    }
}

/***
 * 进入围栏
 ****/
- (void)locationManager:(CLLocationManager *)manager
         didEnterRegion:(CLRegion *)region
{
    self.lblRegion.text = @"进入围栏外";
}

/***
 * 退出围栏
 ****/
- (void)locationManager:(CLLocationManager *)manager
          didExitRegion:(CLRegion *)region
{
    self.lblRegion.text = @"退出围栏";
}

/***
 * 与围栏间的距离
 ****/
- (void)locationManager:(CLLocationManager *)manager
        didRangeBeacons:(NSArray<CLBeacon *> *)aryBeacons
               inRegion:(CLBeaconRegion *)region
{
    //建言过滤
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"proximity = %d", CLProximityUnknown];
    NSArray *unknownBeacons = [aryBeacons filteredArrayUsingPredicate:predicate];
    if (unknownBeacons.count > 0)
    {
        self.lblRanging.text = @"未检测到";
    }
    
    predicate = [NSPredicate predicateWithFormat:@"proximity = %d", CLProximityImmediate];
    NSArray *immediateBeacons = [aryBeacons filteredArrayUsingPredicate:predicate];
    if (immediateBeacons.count > 0)
    {
        self.lblRanging.text = @"最接近";
    }
    
    predicate = [NSPredicate predicateWithFormat:@"proximity = %d", CLProximityNear];
    NSArray *nearBeacons = [aryBeacons filteredArrayUsingPredicate:predicate];
    if (nearBeacons.count > 0) {
        self.lblRanging.text = @"近距离";
    }
    
    predicate = [NSPredicate predicateWithFormat:@"proximity = %d", CLProximityFar];
    NSArray *farBeacons = [aryBeacons filteredArrayUsingPredicate:predicate];
    if (farBeacons.count > 0) {
        self.lblRanging.text = @"远距离";
    }
}


@end

#import "ViewController.h"
#import <CoreBluetooth/CoreBluetooth.h>
#import <CoreLocation/CoreLocation.h>

#define kUUID   @"533F8EF4-EED2-4FEC-8566-84C242B0C636"
#define kID     @"com.51work6.AirLocate"
#define kPower  @-59   //采用字面量表示NSNumber对象

@interface ViewController () <CBPeripheralManagerDelegate>//beacon外设管理器代理

@property(nonatomic, strong) CBPeripheralManager* peripheralManager; //beacon外设管理器

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化微定位外设管理器
    self.peripheralManager = [[CBPeripheralManager alloc] initWithDelegate:self queue:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma --实现CBPeripheralManagerDelegate协议
/***
 * 微服务外设状态发生变化
 ****/
- (void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral
{
    NSLog(@"外设状态变化");
}

- (IBAction)valueChanged:(id)sender
{
    UISwitch* swc =  (UISwitch*)sender;
    
    if (swc.on)
    {
        //实例化uuid
        NSUUID* uuid = [[NSUUID alloc] initWithUUIDString: kUUID];
        //实例化微服务围栏
        CLBeaconRegion* region = [[CLBeaconRegion alloc] initWithProximityUUID:uuid
                                                                    identifier:kID];
        //围栏内广播数据
        NSDictionary* peripheralData = [region peripheralDataWithMeasuredPower:kPower];

        [self.peripheralManager startAdvertising:peripheralData];
        
    } else
    {
        [self.peripheralManager stopAdvertising];
    }
}

@end

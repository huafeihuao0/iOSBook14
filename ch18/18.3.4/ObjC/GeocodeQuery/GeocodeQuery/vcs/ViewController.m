#import "ViewController.h"
#import <CoreLocation/CoreLocation.h>

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITextView *txtView;
@property (weak, nonatomic) IBOutlet UITextField *txtQueryKey;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.txtView.text = @"";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)geocodeQuery:(id)sender {
    
    if (self.txtQueryKey.text == nil) {
        return;
    }
    
    //地理编码/解码器
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    id onQueryFinished=^(NSArray<CLPlacemark *> * placemarks, NSError * error)
    {
        if (error)
        {
            NSLog(@"Error is %@",error.localizedDescription);
        } else if ([placemarks count] > 0)
        {
            
            CLPlacemark* placemark = placemarks[0];
            
            NSString* name = placemark.name;
            
            CLLocation *location = placemark.location;
            
            double lng = location.coordinate.longitude;
            double lat = location.coordinate.latitude;
            
            self.txtView.text = [NSString stringWithFormat:@"经度：%3.5f \n纬度：%3.5f \n%@", lng, lat, name];
        }
    };
    
    //查询地址字符串的对应的地理编码
    [geocoder geocodeAddressString:self.txtQueryKey.text
                 completionHandler:onQueryFinished];
    //关闭键盘
    [self.txtQueryKey resignFirstResponder];

//    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
//    CLLocation *location = [[CLLocation alloc] initWithLatitude:40.002240 longitude:116.323328];
//    
//    CLCircularRegion* region = [[CLCircularRegion alloc] initWithCenter:location.coordinate radius:5000 identifier:@"GeocodeRegion"];
//    
//    [geocoder geocodeAddressString:self.txtQueryKey.text inRegion:region completionHandler:^(NSArray<CLPlacemark *> * placemarks, NSError * error) {
//        //TODO
//    }];
    

}

@end

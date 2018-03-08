#import "ViewController.h"
#import <MapKit/MapKit.h>
#import "MyAnnotation.h"

@interface ViewController () <MKMapViewDelegate>

@property(weak, nonatomic) IBOutlet MKMapView *mapView;
@property(weak, nonatomic) IBOutlet UITextField *txtQueryKey;
@property(weak, nonatomic) IBOutlet UITextView *txtView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.mapView.mapType = MKMapTypeStandard;
    self.mapView.delegate = self;
}

- (IBAction)geocodeQuery:(id)sender {
    
    if (self.txtQueryKey.text == nil || [self.txtQueryKey.text length] == 0) {
        return;
    }

    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    
    //编码成功后回调
    id onCodeFinshed=^(NSArray *placemarks, NSError *error)
    {
        
        NSLog(@"查询记录数：%lu", [placemarks count]);
        [self.mapView removeAnnotations:self.mapView.annotations];
        
        for (CLPlacemark *placemark in placemarks) //遍历地标
        {
            //实例化自定义的注解
            MyAnnotation *annotation = [[MyAnnotation alloc] initWithCoordinate:placemark.location.coordinate];
            annotation.streetAddress = placemark.thoroughfare;
            annotation.city = placemark.locality;
            annotation.state = placemark.administrativeArea;
            annotation.zip = placemark.postalCode;
            
            //添加注释
            [self.mapView addAnnotation:annotation];
        }
        
        if ([placemarks count] > 0)
        {
            //取出最后一个地标点
            MKPlacemark *lastPlacemark = placemarks.lastObject;
            //调整地图位置和缩放比例
            MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(lastPlacemark.location.coordinate, 10000, 10000);
            [self.mapView setRegion:viewRegion animated:TRUE];
        }
        
        //关闭键盘
        [_txtQueryKey resignFirstResponder];
    };
    
    //查询地理编码
    [geocoder geocodeAddressString:_txtQueryKey.text
                 completionHandler:onCodeFinshed];
}

#pragma mark --实现MKMapViewDelegate协议
/***
 * 添加注释后回调，提供注释视图
 ****/
- (MKAnnotationView *)mapView:(MKMapView *)theMapView
            viewForAnnotation:(id <MKAnnotation>)annotation
{
    //大头针式
    MKPinAnnotationView *annotationView = (MKPinAnnotationView *) [self.mapView dequeueReusableAnnotationViewWithIdentifier:@"PIN_ANNOTATION"]; //使用可复用的视图
    if (annotationView == nil)
    {
        //第一次使用时候，使用可复用的视图
        annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"PIN_ANNOTATION"];
    }
    
    annotationView.pinTintColor = [UIColor redColor]; //针头颜色
    annotationView.animatesDrop = TRUE;//动态
    annotationView.canShowCallout = TRUE; //导航时候使用方向投影
    
    return annotationView;
}

/***
 *加载出错
 ****/
- (void)mapViewDidFailLoadingMap:(MKMapView *)theMapView
                       withError:(NSError *)error
{
    NSLog(@"error : %@", [error localizedDescription]);
}

@end

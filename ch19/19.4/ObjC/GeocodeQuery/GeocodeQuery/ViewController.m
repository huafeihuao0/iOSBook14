#import "ViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITextView *txtView;
@property (weak, nonatomic) IBOutlet UITextField *txtQueryKey;

@end

@implementation ViewController

- (IBAction)geocodeQuery:(id)sender
{
    
    if (self.txtQueryKey.text == nil) {
        return;
    }
    
    //本地搜索请求
    MKLocalSearchRequest *request = [[MKLocalSearchRequest alloc] init];
//    request.naturalLanguageQuery = self.txtQueryKey.text;//搜索关键字
    request.naturalLanguageQuery = @"北京";//搜索关键字
    //本地搜索器
    MKLocalSearch *search = [[MKLocalSearch alloc] initWithRequest:request];
    
    //搜索完成后回调
    id onSearchFinished=^(MKLocalSearchResponse *response, NSError *error)
    {
        if ([response.mapItems count] > 0) //搜索到的地标点
        {
            //取出最后一个地标点
            MKMapItem *lastMapItem = response.mapItems.lastObject;
            //在ios地图中打开
            [lastMapItem openInMapsWithLaunchOptions:nil];
            //地图上设置行车路线
            //            NSDictionary* options = @{MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving};
            //            [lastMapItem openInMapsWithLaunchOptions:options];
            
            //多个点标注线
            //            [MKMapItem openMapsWithItems:response.mapItems launchOptions:nil];
        }
        
    };
    
    //开始搜索
    [search startWithCompletionHandler:onSearchFinished];

    //关闭键盘
    [self.txtQueryKey resignFirstResponder];
}

@end

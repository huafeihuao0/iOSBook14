#import "ViewController.h"
#import "AFNetworking.h"

@interface ViewController ()

@property(weak, nonatomic) IBOutlet UIProgressView *progressView;
@property(weak, nonatomic) IBOutlet UIImageView *imageView1;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)onClick:(id)sender {

    
    [self afnDown];

}

#pragma mark --  【DAO】
/***
 * 使用AFN下载
 ****/
- (void)afnDown
{
    //构建下载请求
    NSURLRequest * request = [self makeDownRequ];
    //实例化默认的AFN会话管理器
    NSURLSessionConfiguration *defaultConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *afnSessManager = [[AFURLSessionManager alloc] initWithSessionConfiguration:defaultConfig];
    
    //进度更新回调
    id onProgressed=^(NSProgress *downloadProgress)
    {
        NSLog(@"%@", [downloadProgress localizedDescription]);
        //更新进度条的进度
        dispatch_async(dispatch_get_main_queue(), ^
        {
            [self.progressView setProgress:downloadProgress.fractionCompleted animated:TRUE];
        });
    };
    
    //准备转移位置回调
    id onDestinated=^NSURL *(NSURL *targetPath, NSURLResponse *response)
    {
        //获取文档目录
        NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, TRUE) objectAtIndex:0];
        //拼接完成保存路径
        NSString *savePath = [docDir stringByAppendingPathComponent:[response suggestedFilename]];
        NSURL *saveUrl = [NSURL fileURLWithPath:savePath];
        
        return saveUrl;
    };
    
    //完成时候回调
    id onFinished=^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        
        NSLog(@"File downloaded to: %@", filePath);
        NSData *imgData = [[NSData alloc] initWithContentsOfURL:filePath];
        UIImage *img = [UIImage imageWithData:imgData];
        self.imageView1.image = img;
        
    };
    
    NSURLSessionDownloadTask *afnDownTask = [afnSessManager downloadTaskWithRequest:request
                                                                            progress:onProgressed //进度更新
                                                                         destination:onDestinated //指定目标位置
                                                                   completionHandler:onFinished]; //完成后回调
    
    [afnDownTask resume];
}

/***
 * 构建下载请求
 ****/
- (NSURLRequest *)makeDownRequ
{
    NSString *downUrlBody=@"http://www.51work6.com/service/download.php?email=%@&FileName=test1.jpg";
    NSString *downUrlStr = [[NSString alloc] initWithFormat:downUrlBody, @"<你的51work6.com用户邮箱>"];
    
    NSURL *downUrl = [NSURL URLWithString:downUrlStr];
    NSURLRequest *downRequ = [NSURLRequest requestWithURL:downUrl];
    return downRequ;
}

@end

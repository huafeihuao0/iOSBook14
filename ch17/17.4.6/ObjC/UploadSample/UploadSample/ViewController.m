#import "ViewController.h"
#import "AFNetworking.h"

@interface ViewController ()

@property(weak, nonatomic) IBOutlet UIProgressView *progressView;
@property(weak, nonatomic) IBOutlet UIImageView *imageView1;
@property(weak, nonatomic) IBOutlet UILabel *label;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



- (IBAction)onClick:(id)sender {
    //使用AFN上传图片
    [self afnUp];
}

- (void)download {

    NSString *strURL = [[NSString alloc] initWithFormat:@"http://www.51work6.com/service/download.php?email=%@&FileName=test1.jpg", @"<你的51work6.com用户邮箱>"];

    NSURL *url = [NSURL URLWithString:strURL];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];

    NSURLSessionConfiguration *defaultConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:defaultConfig];

    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:^(NSProgress *downloadProgress) {

        NSLog(@"下载: %@", [downloadProgress localizedDescription]);

        dispatch_async(dispatch_get_main_queue(), ^{
            [self.progressView setProgress:downloadProgress.fractionCompleted animated:TRUE];
        });

    } destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {

        NSString *downloadsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, TRUE) objectAtIndex:0];
        NSString *downloadStrPath = [downloadsDir stringByAppendingPathComponent:[response suggestedFilename]];
        NSURL *downloadURLPath = [NSURL fileURLWithPath:downloadStrPath];

        return downloadURLPath;

    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {

        NSLog(@"下载文件保存: %@", filePath);
        NSData *imgData = [[NSData alloc] initWithContentsOfURL:filePath];
        UIImage *img = [UIImage imageWithData:imgData];
        self.imageView1.image = img;

    }];

    [downloadTask resume];

    self.label.text = @"下载进度";
    self.progressView.progress = 0.0;

}

#pragma mark --  【上传】
/***
 * 使用AFN上传图片
 ****/
- (void)afnUp
{
    //构建上传请求
    NSMutableURLRequest * upRequ = [self makeUpRequ];
    
    //默认的AFN的会话管理器
    NSURLSessionConfiguration *defSessConfig=[NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *defAFNManager = [[AFURLSessionManager alloc] initWithSessionConfiguration:defSessConfig];
    
    //进度回调
    id onProgressed=^(NSProgress *uploadProgress)
    {
        NSLog(@"上传: %@", [uploadProgress localizedDescription]);
        dispatch_async(dispatch_get_main_queue(), ^
        {
            [self.progressView setProgress:uploadProgress.fractionCompleted];
        });
        
    };
    //完成回调
    id onFinished=^(NSURLResponse *response, id responseObject, NSError *error)
    {
        if (!error)
        {
            NSLog(@"上传成功");
            [self download];
        } else
        {
            NSLog(@"上传失败: %@", error.localizedDescription);
        }
    };
    
    NSURLSessionUploadTask *uploadTask= [defAFNManager uploadTaskWithStreamedRequest:upRequ //使用流式请求构建上传任务
                                                                            progress:onProgressed //进度回调
                                                                   completionHandler:onFinished]; //完成回调
    //恢复上传任务
    [uploadTask resume];
    
    self.label.text = @"上传进度";
    self.progressView.progress = 0.0;
}

/***
 * 构建上传请求
 ****/
- (NSMutableURLRequest *)makeUpRequ
{
    NSString *uploadStrURL = @"http://www.51work6.com/service/upload.php";
    //普通键值参数
    NSDictionary *kvParams = @{@"email" : @"<你的51work6.com用户邮箱>"};
    //要上传的文件路径
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"test2"
                                                         ofType:@"jpg"];
    //构建多部分请求表单数据的block
    id buildBodyBlock=^(id <AFMultipartFormData> multiPartsData)
    {
        [multiPartsData appendPartWithFileURL:[NSURL fileURLWithPath:filePath]
                                         name:@"file" //key
                                     fileName:@"1.jpg" //建议的文件名
                                     mimeType:@"image/jpeg" //文件类型
                                        error:nil];
    };
    //请求序列化器构建多部分数据请求体
    NSMutableURLRequest *upRequ = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST"
                                                                                              URLString:uploadStrURL
                                                                                            parameters:kvParams
                                                                              constructingBodyWithBlock:buildBodyBlock
                                                                                                  error:nil];
    return upRequ;
}
@end

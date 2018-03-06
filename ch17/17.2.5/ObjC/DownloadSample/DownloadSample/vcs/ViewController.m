#import "ViewController.h"

@interface ViewController () <NSURLSessionDownloadDelegate> //会话下载代理

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



- (IBAction)onClick:(id)sender
{
    //开始下载
    [self startDownload];
}

#pragma mark --  【DAO】

/***
 * 开始下载
 ****/
- (void)startDownload
{
    //构建下载地址url
    NSString *downUrlSTr = [[NSString alloc] initWithFormat:@"http://www.51work6.com/service/download.php?email=%@&FileName=test1.jpg"
                            , @"<你的51work6.com用户邮箱>"];
    NSURL *downUrl = [NSURL URLWithString:downUrlSTr];
    
    //创建默认会话
    NSURLSession *defSess = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]//默认会话配置
                                                          delegate:self //下载代理
                                                     delegateQueue:[NSOperationQueue mainQueue]];//主队列
    //创建下载任务
    NSURLSessionDownloadTask *downloadTask = [defSess downloadTaskWithURL:downUrl];
    
    //恢复下载任务
    [downloadTask resume];
}

#pragma mark -- NSURLSessionDownloadDelegate
/***
 * 下载进度回调
 ****/
- (void)URLSession:(NSURLSession *)session  //管理下载的会话
      downloadTask:(NSURLSessionDownloadTask *)downloadTask //执行下载的任务
      didWriteData:(int64_t)bytesWritten    //本次回调写入的数据
 totalBytesWritten:(int64_t)totalBytesWritten //总共已经写入的数据
totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite //数据总大小
{
    //计算进度
    float downProg = totalBytesWritten * 1.0 / totalBytesExpectedToWrite;
    //更新进度条进度
    [self.progressView setProgress:downProg animated:TRUE];
    NSLog(@"进度= %f", downProg);
    NSLog(@"接收: %lld 字节 (已下载: %lld 字节)  期待: %lld 字节.",
          bytesWritten, totalBytesWritten, totalBytesExpectedToWrite);
}


/***
 * 下载完成回调
 ****/
- (void)URLSession:(NSURLSession *)session
      downloadTask:(NSURLSessionDownloadTask *)downloadTask
didFinishDownloadingToURL:(NSURL *)tmpLocationUrl  //下载文件的临时路径
{

    NSLog(@"临时文件: %@\n", tmpLocationUrl);
    //获取文档目录
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, TRUE) objectAtIndex:0];
    //拼接完整保存路径
    NSString *saveDownedFilePath = [docDir stringByAppendingPathComponent:@"test1.jpg"];
    NSURL *saveUrl = [NSURL fileURLWithPath:saveDownedFilePath];

    //文件管理器
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //删除旧的文件
    NSError * error = [self deleteOldFileByFM:fileManager saveDownedFilePath:saveDownedFilePath];

    error = nil;

    //将临时位置的下载文件保存到应用文档目录中
    if ([fileManager moveItemAtURL:tmpLocationUrl
                             toURL:saveUrl
                             error:&error])
    {
        NSLog(@"文件保存: %@", saveDownedFilePath);
        //加载下载到的图片
        UIImage *img = [UIImage imageWithContentsOfFile:saveDownedFilePath];
        self.imageView1.image = img;
        
    } else
    {
        NSLog(@"保存文件失败: %@", error.localizedDescription);
    }
}

/***
 * 删除旧的文件
 ****/
- (NSError *)deleteOldFileByFM:(NSFileManager *)fileManager
            saveDownedFilePath:(NSString *)saveDownedFilePath
{
    NSError *error = nil;
    if ([fileManager fileExistsAtPath:saveDownedFilePath]) //判断文件是否存在
    {
        [fileManager removeItemAtPath:saveDownedFilePath error:&error]; //如果已经存在，删除旧的文件
        if (error)
        {
            NSLog(@"删除文件失败: %@", error.localizedDescription);
        }
    }
    return error;
}


@end

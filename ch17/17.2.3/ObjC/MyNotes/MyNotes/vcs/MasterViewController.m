
#import "MasterViewController.h"
#import "DetailViewController.h"



@implementation MasterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    self.detailViewController = (DetailViewController *) [[self.splitViewController.viewControllers lastObject] topViewController];

    //使用默认会话get型请求
    [self getRequByDefSess];
}

#pragma mark -【DAO】
/***
 * 使用默认会话get型请求
 ****/
- (void)getRequByDefSess
{
    //构建get型请求对象
    NSURLRequest * getRequ = [self makeupGetRequ];
    //实例化默认会话配置
    NSURLSessionConfiguration *defaultSessConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    //使用默认会话配置实例化默认会话
    NSURLSession *session = [NSURLSession sessionWithConfiguration: defaultSessConfig
                                                          delegate: nil
                                                     delegateQueue: [NSOperationQueue mainQueue]];//在主队列中运行
    //下载完成处理器
    id onCompleted=^(NSData *data, NSURLResponse *response, NSError *error)
    {
        NSLog(@"请求完成...");
        if (!error)
        {
            //反序列化
            NSDictionary *resDict = [NSJSONSerialization JSONObjectWithData:data
                                                                    options:NSJSONReadingAllowFragments //可读片段
                                                                      error:nil];
            //刷新表格
            [self reloadView:resDict];
        } else
        {
            NSLog(@"error : %@", error.localizedDescription);
        }
    };
    //创建数据下载任务
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:getRequ
                                            completionHandler:onCompleted];

    [dataTask resume];

}

/***
 * 构建get型请求对象
 ****/
- (NSURLRequest *)makeupGetRequ
{
    NSString *getUrlMainStr=@"http://www.51work6.com/service/mynotes/WebService.php?email=%@&type=%@&action=%@";
    NSString *requUrlStr = [[NSString alloc] initWithFormat:getUrlMainStr, @"<你的51work6.com用户邮箱>", @"JSON", @"query"];
    requUrlStr = [requUrlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    NSURL *requUrl = [NSURL URLWithString:requUrlStr];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:requUrl];
    return request;
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSMutableDictionary *dict = self.listData[indexPath.row];
        DetailViewController *controller = (DetailViewController *) [[segue destinationViewController] topViewController];
        [controller setDetailItem:dict];
        controller.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
        controller.navigationItem.leftItemsSupplementBackButton = TRUE;
    }
}

#pragma mark - Table View

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.listData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

    NSMutableDictionary *dict = self.listData[indexPath.row];
    cell.textLabel.text = dict[@"Content"];
    cell.detailTextLabel.text = dict[@"CDate"];

    return cell;
}

#pragma mark - 重新加载表视图

- (void)reloadView:(NSDictionary *)res {

    NSNumber *resultCode = res[@"ResultCode"];

    if ([resultCode integerValue] >= 0) {
        self.listData = res[@"Record"];
        [self.tableView reloadData];
    } else {
        NSString *errorStr = [resultCode errorMessage];
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"错误信息" message:errorStr preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:okAction];
        //显示
        [self presentViewController:alertController animated:true completion:nil];
    }
}


@end

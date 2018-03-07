#import "MasterViewController.h"
#import "DetailViewController.h"

@implementation MasterViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    self.detailViewController = (DetailViewController *) [[self.splitViewController.viewControllers lastObject] topViewController];

    //使用简单会话发送get型请求
    [self getRequBySimpleSess];
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

/***
 * 重新加载表视图
 ****/
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

#pragma mark --  【DAO】
/***
 * 构建get请求对象
 ****/
- (NSURLRequest *)makeupGetRequ
{
    //请求地址字符串
    NSString *requStrMainStr=@"http://www.51work6.com/service/mynotes/WebService.php?email=%@&type=%@&action=%@";
    NSString *requUrlStr = [[NSString alloc] initWithFormat:requStrMainStr, @"<你的51work6.com用户邮箱>", @"JSON", @"query"];
    //url地址百分号编码
    requUrlStr = [requUrlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL *requUrl = [NSURL URLWithString:requUrlStr];
    
    //实例化请求对象
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:requUrl];
    return request;
}

/***
 *  使用简单会话发送get型请求
 ****/
- (void)getRequBySimpleSess
{
    //构建get请求对象
    NSURLRequest * getRequ = [self makeupGetRequ];
    
    //实例化简单的共享会话单例
    NSURLSession *sharedSess = [NSURLSession sharedSession];
    id onCompleted=^(NSData *data, NSURLResponse *response, NSError *error)
    {
        NSLog(@"请求完成...");
        if (!error)
        {
            NSDictionary *resDict = [NSJSONSerialization JSONObjectWithData:data
                                                                    options:NSJSONReadingAllowFragments
                                                                    error:nil];
            //主队列更新表格
            dispatch_async(dispatch_get_main_queue(), ^
            {
                [self reloadView:resDict];
            });
        } else
        {
            NSLog(@"error : %@", error.localizedDescription);
        }
    };
    
    //创建get型请求任务
    NSURLSessionDataTask *getRequTask = [sharedSess dataTaskWithRequest:getRequ //get型请求
                                                      completionHandler:onCompleted]; //下载完成处理器
    //恢复任务
    [getRequTask resume];
}
@end

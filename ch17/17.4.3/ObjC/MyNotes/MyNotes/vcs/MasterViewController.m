#import "MasterViewController.h"
#import "DetailViewController.h"

//#import <AFNetworking/AFNetworking.h>
#import "AFNetworking.h"

@implementation MasterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    self.detailViewController = (DetailViewController *) [[self.splitViewController.viewControllers lastObject] topViewController];
    
    [self afnGet];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

#pragma mark -【DAO】
/***
 * AFN发送get型请求
 ****/
- (void)afnGet
{
    //创建get请求对象
    NSURLRequest * getRequ = [self makeGetRequ];
    //使用默认会话配置构建afn会话管理器
    NSURLSessionConfiguration *defSessConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *afnManager = [[AFURLSessionManager alloc] initWithSessionConfiguration:defSessConfig];
    
    //get完成后回调
    id onGetFinished=^(NSURLResponse *response,//响应对象
                       id responseObject,//数据
                       NSError *error)
    {
        NSLog(@"请求完成...");
        if (!error)
        {
            [self reloadView:responseObject];
        } else
        {
            NSLog(@"error : %@", error.localizedDescription);
        }
    };
    
    //创建get请求任务
    NSURLSessionDataTask *task = [afnManager dataTaskWithRequest:getRequ
                                               completionHandler:onGetFinished];
    
    //恢复get任务
    [task resume];
    
}

/***
 * 创建get请求对象
 ****/
- (NSURLRequest *)makeGetRequ
{
    NSString *urlPathStr=@"http://www.51work6.com/service/mynotes/WebService.php?email=%@&type=%@&action=%@";
    NSString *strURL = [[NSString alloc] initWithFormat:urlPathStr,
                        @"<你的51work6.com用户邮箱>", @"JSON", @"query"];
    
    strURL = [strURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    NSURL *url = [NSURL URLWithString:strURL];
    NSURLRequest *getRequ = [[NSURLRequest alloc] initWithURL:url];
    return getRequ;
}


@end

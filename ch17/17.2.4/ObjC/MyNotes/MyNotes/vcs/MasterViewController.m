#import "MasterViewController.h"
#import "DetailViewController.h"

@implementation MasterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    self.detailViewController = (DetailViewController *) [[self.splitViewController.viewControllers lastObject] topViewController];

    //使用默认会话发送post请求
    [self startRequest];
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


#pragma mark - 【DAO】
/***
 * 使用默认会话发送post请求
 ****/
- (void)startRequest
{
    //构建post请求对象
    NSMutableURLRequest * postRequ = [self makeupPostRequ];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration: [NSURLSessionConfiguration defaultSessionConfiguration]//默认配置对象
                                                          delegate: nil
                                                     delegateQueue: [NSOperationQueue mainQueue]];//主队列
    id onPostDataFinished=^(NSData *data, NSURLResponse *response, NSError *error)
    {
        NSLog(@"请求完成...");
        if (!error) {
            NSDictionary *resDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            //dispatch_async(dispatch_get_main_queue(), ^{
            [self reloadView:resDict];
            //});
        } else {
            NSLog(@"error : %@", error.localizedDescription);
        }
    };
    
    //创建post数据任务
    NSURLSessionDataTask *postTask = [session dataTaskWithRequest:postRequ
                                            completionHandler:onPostDataFinished];
    
    [postTask resume];
    
}

/***
 * 构建post请求对象
 ****/
- (NSMutableURLRequest *)makeupPostRequ
{
    NSString *postUrlStr = @"http://www.51work6.com/service/mynotes/WebService.php";
    NSURL *postUrl = [NSURL URLWithString:postUrlStr];

    //转化post表单参数
    NSString *postParamStr = [NSString stringWithFormat:@"email=%@&type=%@&action=%@",
                              @"<你的51work6.com用户邮箱>", @"JSON", @"query"];
    NSData *postData = [postParamStr dataUsingEncoding:NSUTF8StringEncoding];
    
    //创建可变的post请求对象
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:postUrl];
    [request setHTTPMethod:@"POST"];//设置请求方式是POST
    [request setHTTPBody:postData];//设置post请求体
    return request;
}

@end

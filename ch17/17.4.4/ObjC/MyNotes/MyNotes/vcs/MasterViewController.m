#import "MasterViewController.h"
#import "DetailViewController.h"

//#import <AFNetworking/AFNetworking.h>
#import "AFNetworking.h"

@implementation MasterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    self.detailViewController = (DetailViewController *) [[self.splitViewController.viewControllers lastObject] topViewController];

    [self afnPostData];
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
- (void)afnPostData
{
    //构建post请求对象
    NSMutableURLRequest * postRequ = [self makePostRequ];
    
    //使用默认会话配置实例化AFN会话管理器
    NSURLSessionConfiguration *defSessConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:defSessConfig];
    
    //post请求完成后回调
    id onPostFinished=^(NSURLResponse *response, id responseObject, NSError *error)
    {
        NSLog(@"请求完成...");
        if (!error) {
            [self reloadView:responseObject];
        } else {
            NSLog(@"error : %@", error.localizedDescription);
        }
    };
    
    NSURLSessionDataTask *task = [manager dataTaskWithRequest:postRequ
                                            completionHandler:onPostFinished];
    
    [task resume];
}

/***
 * 构建post请求对象
 ****/
- (NSMutableURLRequest *)makePostRequ
{
    NSString *strURL = @"http://www.51work6.com/service/mynotes/WebService.php";
    NSURL *url = [NSURL URLWithString:strURL];
    
    //创建post请求参数体
    NSString *post = [NSString stringWithFormat:@"email=%@&type=%@&action=%@",
                      @"<你的51work6.com用户邮箱>", @"JSON", @"query"];
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding];
    //创建可变请求对象
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:postData]; //设置请求体
    return request;
}

@end

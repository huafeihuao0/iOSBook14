#import "MasterViewController.h"
#import "DetailViewController.h"

@implementation MasterViewController


- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.leftBarButtonItem = self.editButtonItem;

    self.detailViewController = (DetailViewController *) [[self.splitViewController.viewControllers lastObject] topViewController];
    
    //获取数据的data对象
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Notes"
                                                     ofType:@"json"];
    NSData *jsonData = [[NSData alloc] initWithContentsOfFile:path];

    //初始化NSjson的序列化工具
    NSError *error;
    id jsonObj = [NSJSONSerialization JSONObjectWithData:jsonData //数据data
                                                 options:NSJSONReadingMutableContainers //解析成可变的数据容器
                                                   error:&error];
    if (!jsonObj || error)
    {
        NSLog(@"JSON解码失败");
    }

    self.listData = jsonObj[@"Record"];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
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

@end

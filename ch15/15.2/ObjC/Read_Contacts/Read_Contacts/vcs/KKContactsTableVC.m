#import "KKContactsTableVC.h"
#import "DetailViewController.h"

#import <Contacts/Contacts.h>

//自定义的联系人表控制器
@interface KKContactsTableVC () <UISearchBarDelegate,  //搜索栏代理
                              UISearchResultsUpdating> //搜索结果更新器

@property(strong, nonatomic) UISearchController *searchController; //搜索控制器
@property(strong, nonatomic) NSArray *searchedContactsList;//展示的符合条件的联系人集合

@end

@implementation KKContactsTableVC


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //实例化UISearchController
    [self initSearchCtrler];

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //查询通信录中所有联系人
        self.searchedContactsList = [self findAllContacts];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    });
    
}

/***
 * 跳转时候回调
 ****/
- (void)prepareForSegue:(UIStoryboardSegue *)segue
                 sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) //准备跳转到联系人详情页
    {
        //获取目标的联系人详情控制器
        DetailViewController *detailViewController = [segue destinationViewController];
        
        //设置选中的联系人
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        detailViewController.selectContact = self.searchedContactsList[indexPath.row];
    }
}

#pragma mark --  【views】
/***
 * 实例化UISearchController
 ****/
- (void)initSearchCtrler
{
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    //设置self为更新搜索结果对象
    self.searchController.searchResultsUpdater = self;
    //在搜索是背景设置为灰色
    self.searchController.dimsBackgroundDuringPresentation = FALSE;
    //将搜索栏放到表视图的表头中
    self.tableView.tableHeaderView = self.searchController.searchBar;
}

#pragma mark - 【表格数据源】
/***
 * 每段行数
 ****/
- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    if (self.searchedContactsList == nil)
    {
        return 0;
    }
    return [self.searchedContactsList count];
}

/***
 * 单元格样式
 ****/
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath//
{
    //尝试获取可复用的单元格
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    //获取单元格对应的数据，即指定联系人
    CNContact *contact = self.searchedContactsList[indexPath.row];
    //拼接完整名字
    NSString *name = [NSString stringWithFormat:@"%@ %@", contact.givenName, contact.familyName];
    
    cell.textLabel.text = name;
    return cell;
}


#pragma mark --  【搜索条代理】

/***
 * 选择改变监听器
 ****/
- (void)searchBar:(UISearchBar *)searchBar
selectedScopeButtonIndexDidChange:(NSInteger)selectedScope
{
    [self updateSearchResultsForSearchController:self.searchController];
}

/***
 * 更新搜索条的结果
 ****/
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    NSString *searchString = searchController.searchBar.text;
    //查询
    self.searchedContactsList = [self findContactsByName:searchString];
    [self.tableView reloadData];
}

#pragma mark --  【DAO】

/***
 * 查询通信录中所有联系人
 ****/
- (NSArray*)findAllContacts
{
    //所有联系人数组
    id allContactsArr = [[NSMutableArray alloc] init];
    //要获取的联系人属性数组
    NSArray *keysToFetch = @[CNContactFamilyNameKey,//姓
                             CNContactGivenNameKey];//名
    //获取所有联系人的请求对象
    CNContactFetchRequest *requForAllContacts = [[CNContactFetchRequest alloc] initWithKeysToFetch:keysToFetch];
    
    //联系人仓库
    CNContactStore *contactStore = [[CNContactStore alloc] init];
    NSError *error = nil;
    //枚举所有联系人
    [contactStore enumerateContactsWithFetchRequest:requForAllContacts
                                              error:&error
                                         usingBlock:^(CNContact *_Nonnull contact, BOOL *_Nonnull stop) //每次读取都一个联系人的时候都会回调
                                                    {
                                                        if (!error)
                                                        {
                                                            [allContactsArr addObject:contact];
                                                        } else
                                                        {
                                                            NSLog(@"error : %@", error.localizedDescription);
                                                        }
                                                    }];
    
    return allContactsArr;
}

/***
 * 按照姓名查询通信录中的联系人
 ****/
- (NSArray*)findContactsByName:(NSString *)searchName   //
{
    //没有输入任何字符
    if ([searchName length] == 0)
    {
        //返回通信录中所有联系人
        return [self findAllContacts];
    }
    
    //联系人仓库
    CNContactStore *contactStore = [[CNContactStore alloc] init];
    //要获取的联系人属性键
    NSArray *keysToFetch = @[CNContactFamilyNameKey, CNContactGivenNameKey];
    //联系人预言对象
    NSPredicate *predicate = [CNContact predicateForContactsMatchingName:searchName]; //匹配名字
    
    NSError *error = nil;
    id contacts = [contactStore unifiedContactsMatchingPredicate:predicate //使用预言查询符合条件的联系人
                                                     keysToFetch:keysToFetch
                                                           error:&error];
    if (!error)
    {
        //没有错误情况下返回查询结果
        return contacts;
    } else
    {
        //如果有错误发生，返回通信录中所有联系人
        return [self findAllContacts];
    }
}


@end

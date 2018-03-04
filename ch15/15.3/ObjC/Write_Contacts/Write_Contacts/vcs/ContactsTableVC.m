#import <Contacts/Contacts.h>
#import "ContactsTableVC.h"//联系人表格控制器
#import "ContactDetailVC.h"//联系人详情控制器
#import "AddContactVC.h"//添加联系人控制器

@interface ContactsTableVC () <UISearchBarDelegate, //搜索栏委托
                               UISearchResultsUpdating>//搜索结果更新器

@property(strong, nonatomic) UISearchController *searchController;//搜索栏控制器

@property(strong, nonatomic) NSArray *listContacts;

@end

@implementation ContactsTableVC


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //实例化UISearchController
    [self initSearchCtrl];
    
}

//视图即将显示的时候回调
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:TRUE];

    dispatch_block_t findContactsTask=^//无参数、无返回值的block类型，执行异步任务
    {
        //查询通信录中所有联系人
        self.listContacts = [self findAllContacts];
        //更新表格的任务
        dispatch_block_t updateTableTask=^
        {
            [self.tableView reloadData];
        };
        //主队列中更新表格
        dispatch_async(dispatch_get_main_queue(),updateTableTask);
    };
    //子线程异步查询联系人集合
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),findContactsTask);
                   
}

#pragma mark --预处理Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"])
    {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        ContactDetailVC *detailViewController = [segue destinationViewController];
        detailViewController.selectContact = self.listContacts[indexPath.row];
    }
}

#pragma mark --  【views】
/***
 * 实例化UISearchController
 ****/
- (void)initSearchCtrl //
{
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    //设置self为更新搜索结果对象
    self.searchController.searchResultsUpdater = self;
    //在搜索是背景设置为灰色
    self.searchController.dimsBackgroundDuringPresentation = FALSE;
    //将搜索栏放到表视图的表头中
    self.tableView.tableHeaderView = self.searchController.searchBar;
}



/***
 * 搜索栏选中范围改变监听器
 ****/
- (void)searchBar:(UISearchBar *)searchBar
        selectedScopeButtonIndexDidChange:(NSInteger)selectedScope
{
    //更新搜索栏的搜索结果
    [self updateSearchResultsForSearchController:self.searchController];
}

/***
 * 更新搜索栏搜索结果
 ****/
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    NSString *searchString = searchController.searchBar.text;
    //查询
    self.listContacts = [self findContactsByName:searchString];
    [self.tableView reloadData];
}


#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.listContacts count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    CNContact *contact = self.listContacts[indexPath.row];
    NSString *firstName = contact.givenName;
    NSString *lastName = contact.familyName;
    
    NSString *name = [NSString stringWithFormat:@"%@ %@", firstName, lastName];
    cell.textLabel.text = name;
    
    return cell;
}


#pragma mark --  【DAO】
/***
 * 查询通信录中所有联系人
 ****/
- (NSArray*)findAllContacts {
    
    //返回的联系人集合
    id contacts = [[NSMutableArray alloc] init];
    
    NSArray *keysToFetch = @[CNContactFamilyNameKey, CNContactGivenNameKey];
    CNContactFetchRequest *fetchRequest = [[CNContactFetchRequest alloc] initWithKeysToFetch:keysToFetch];
    
    CNContactStore *contactStore = [[CNContactStore alloc] init];
    NSError *error = nil;
    [contactStore enumerateContactsWithFetchRequest:fetchRequest error:&error usingBlock:^(CNContact *_Nonnull contact, BOOL *_Nonnull stop) {
        if (!error) {
            [contacts addObject:contact];
        } else {
            NSLog(@"error : %@", error.localizedDescription);
        }
    }];
    
    return contacts;
}

/***
 * 按照姓名查询通信录中的联系人
 ****/
- (NSArray*)findContactsByName:(NSString *)searchName {
    
    //没有输入任何字符
    if ([searchName length] == 0) {
        //返回通信录中所有联系人
        return [self findAllContacts];
    }
    
    CNContactStore *contactStore = [[CNContactStore alloc] init];
    
    NSArray *keysToFetch = @[CNContactFamilyNameKey, CNContactGivenNameKey];
    NSPredicate *predicate = [CNContact predicateForContactsMatchingName:searchName];
    NSError *error = nil;
    id contacts = [contactStore unifiedContactsMatchingPredicate:predicate keysToFetch:keysToFetch error:&error];
    
    if (!error) {
        //没有错误情况下返回查询结果
        return contacts;
    } else {
        //如果有错误发生，返回通信录中所有联系人
        return [self findAllContacts];
    }
}


@end

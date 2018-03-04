
#import "ViewController.h"
#import <ContactsUI/ContactsUI.h>

@interface ViewController () <CNContactPickerDelegate, CNContactViewControllerDelegate>

@property(strong, nonatomic) NSMutableArray *listContacts;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.listContacts = [[NSMutableArray alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark --实现表视图数据源协议

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

#pragma mark --表视图委托协议


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CNContactStore* contactStore = [[CNContactStore alloc] init];
    
    CNContact *selectedContact = self.listContacts[indexPath.row];
    
    id keysToFetch = @[[CNContactViewController descriptorForRequiredKeys]];
    NSError *error;
    CNContact *contact = [contactStore unifiedContactWithIdentifier:selectedContact.identifier keysToFetch:keysToFetch error:&error];

    if (!error) {
        
        [self pushToContactVC:contact contactStore:contactStore];
    } else {
        NSLog(@"error : %@", error.localizedDescription);
    }

}


#pragma mark --  【联系人选择控制器】
/***
 * 使用系统默认联系人选择控制器选择联系人
 ****/
- (IBAction)selectContacts:(id)sender
{
    //联系人选择控制器
    CNContactPickerViewController *contactPicker = [[CNContactPickerViewController alloc] init];
    contactPicker.delegate = self;
    contactPicker.displayedPropertyKeys = @[CNContactPhoneNumbersKey];
    
    [self presentViewController:contactPicker animated:TRUE completion:nil];
    
}

#pragma  --实现CNContactPickerDelegate委托协议
/***
 * 选中了一个联系人
 ****/
- (void)contactPicker:(CNContactPickerViewController *)picker
     didSelectContact:(CNContact *)contact
{
    
    if (![self.listContacts containsObject:contact])
    {
        [self.listContacts addObject:contact];
        [self.tableView reloadData];
    }
}

#pragma mark --  【联系人控制器】
/***
 * 推入联系人选择控制器
 ****/
- (void)pushToContactVC:(CNContact *)contact
           contactStore:(CNContactStore *)contactStore
{
    CNContactViewController* contactVC = [CNContactViewController viewControllerForContact:contact];//指定要操作的联系人
    contactVC.delegate = self;
    contactVC.contactStore = contactStore;
    contactVC.allowsEditing = TRUE;//允许编辑
    contactVC.allowsActions = TRUE;//允许操作
    
    contactVC.displayedPropertyKeys = @[CNContactPhoneNumbersKey,
                                        CNContactEmailAddressesKey];//要展示的联系人属性
    
    [self.navigationController pushViewController:contactVC animated:TRUE];
}
#pragma  --实现CNContactViewControllerDelegate委托协议
/***
 * 联系人控制器是否执行默认的动作
 ****/
- (BOOL)contactViewController:(CNContactViewController *)viewController
        shouldPerformDefaultActionForContactProperty:(CNContactProperty *)property
{
    return TRUE;
}

@end

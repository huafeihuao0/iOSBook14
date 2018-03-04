
#import "ViewController.h"
#import <ContactsUI/ContactsUI.h>

@interface ViewController () <CNContactPickerDelegate>

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



#pragma mark - 实现表视图数据源协议

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


#pragma mark --  【系统联系人表格控制器】
/***
 * 调用系统联系人表格控制器选择联系人
 ****/
- (IBAction)selectContacts:(id)sender //
{
    //实例化联系人选择控制器
    CNContactPickerViewController *contactPicker = [[CNContactPickerViewController alloc] init];
    contactPicker.delegate = self;
    contactPicker.displayedPropertyKeys = @[CNContactPhoneNumbersKey]; //要显示的联系人属性键
    
    [self presentViewController:contactPicker animated:TRUE completion:nil];
}

#pragma  --实现CNContactPickerDelegate委托协议
/***
 * 选中单个联系人监听器
 ****/
- (void)contactPicker:(CNContactPickerViewController *)picker
     didSelectContact:(CNContact *)selectedContact
{
    if (![self.listContacts containsObject:selectedContact])
    {
        [self.listContacts addObject:selectedContact];
        [self.tableView reloadData];
    }

}

//- (void)contactPicker:(CNContactPickerViewController *)picker didSelectContacts:(NSArray<CNContact *> *)contacts {
//
//    for (CNContact *contact in contacts) {
//        if (![self.listContacts containsObject:contact]) {
//            [self.listContacts addObject:contact];
//        }
//    }
//    [self.tableView reloadData];
//}

//- (void)contactPicker:(CNContactPickerViewController *)picker didSelectContactProperty:(CNContactProperty *)contactProperty {
//    CNContact* contact = contactProperty.contact;
//    CNPhoneNumber* phoneNumber = (CNPhoneNumber*)contactProperty.value;
//
//    NSLog(@"%@", contact.givenName);
//    NSLog(@"%@", phoneNumber.stringValue);
//
//}

@end

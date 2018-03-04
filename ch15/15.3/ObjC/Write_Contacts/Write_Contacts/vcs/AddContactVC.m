

#import "AddContactVC.h"

/***
 * 添加联系人控制器
 ****/
@interface AddContactVC ()

@end

@implementation AddContactVC


- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



/***
 * 添加联系人
 ****/
- (IBAction)saveClick:(id)sender
{
    //新家联系人
    CNMutableContact* contact = [[CNMutableContact alloc] init];
    
    //设置姓名属性
    contact.familyName =  self.txtFirstName.text;
    contact.givenName =  self.txtLastName.text;
        
    // 设置电话号码
    [self savePhones:contact];
    
    //设置Email属性
    [self saveEmails:contact];
    
    //最后保存
    CNSaveRequest* request = [[CNSaveRequest alloc] init];
    [request addContact:contact toContainerWithIdentifier:nil];//不添加到具名容器id
    
    CNContactStore *contactStore = [[CNContactStore alloc] init];
    NSError* error;
    [contactStore executeSaveRequest:request error:&error];
    
    if (!error)
    {
        //关闭模态视图
        [self dismissViewControllerAnimated:TRUE completion:nil];
    } else
    {
        NSLog(@"error : %@", error.localizedDescription);
    }
    
}

- (IBAction)cancelClick:(id)sender {
    [self dismissViewControllerAnimated:TRUE completion:nil];
}


#pragma mark --  【工具】

/***
 * 保存电话
 ****/
- (void)savePhones:(CNMutableContact *)contact
{
    CNPhoneNumber* mobilePhoneValue = [[CNPhoneNumber alloc] initWithStringValue:self.txtMobile.text];
    CNLabeledValue* mobilePhone = [[CNLabeledValue alloc] initWithLabel:CNLabelPhoneNumberMobile
                                                                  value:mobilePhoneValue];
    
    CNPhoneNumber* iPhoneValue = [[CNPhoneNumber alloc] initWithStringValue:self.txtIPhone.text];
    CNLabeledValue* iPhone = [[CNLabeledValue alloc] initWithLabel:CNLabelPhoneNumberiPhone value:iPhoneValue];
    
    // 添加电话号码到数据库
    contact.phoneNumbers = @[mobilePhone, iPhone];
}

/***
 * 保存邮箱
 ****/
- (void)saveEmails:(CNMutableContact *)contact
{
    CNLabeledValue* homeEmail = [[CNLabeledValue alloc] initWithLabel:CNLabelHome value:self.txtHomeEmail.text];
    CNLabeledValue* workEmail = [[CNLabeledValue alloc] initWithLabel:CNLabelWork value:self.txtWorkEmail.text];
    // 添加Email到数据库
    contact.emailAddresses = @[homeEmail, workEmail];
}

@end

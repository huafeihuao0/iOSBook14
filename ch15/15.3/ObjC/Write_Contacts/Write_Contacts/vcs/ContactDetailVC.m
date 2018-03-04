#import "ContactDetailVC.h"

/***
 * 联系人详情和修改控制器
 ****/
@interface ContactDetailVC ()

@end

@implementation ContactDetailVC


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CNContactStore *contactStore = [[CNContactStore alloc] init];
    
    NSArray *keysToFetch = @[CNContactFamilyNameKey, CNContactGivenNameKey, CNContactEmailAddressesKey, CNContactPhoneNumbersKey, CNContactImageDataKey];
    NSError *error = nil;
    CNContact *contact = [contactStore unifiedContactWithIdentifier:self.selectContact.identifier keysToFetch:keysToFetch error:&error];
    
    //保存查询出的联系人
    self.selectContact = contact;
    
    if (!error) {
        
        //取得姓名属性
        NSString *firstName = contact.givenName;
        NSString *lastName = contact.familyName;
        
        NSString *name = [NSString stringWithFormat:@"%@ %@", firstName, lastName];
        [self.lblName setText:name];
        
        //取得Email属性
        NSArray<CNLabeledValue<NSString*>*> *emailAddresses = contact.emailAddresses;
        
        for (CNLabeledValue<NSString*>* emailProperty in emailAddresses) {
            
            if ([emailProperty.label isEqualToString:CNLabelWork]) {
                [self.txtWorkEmail setText:emailProperty.value];
            } else if ([emailProperty.label isEqualToString:CNLabelHome]) {
                [self.txtHomeEmail setText:emailProperty.value];
            } else {
                NSLog(@"%@: %@", @"其他Email", emailProperty.value);
            }
        }
        
        //取得电话号码属性
        NSArray<CNLabeledValue<CNPhoneNumber*>*> *phoneNumbers = contact.phoneNumbers;
        
        for (CNLabeledValue<CNPhoneNumber*>* phoneNumberProperty in phoneNumbers) {
            CNPhoneNumber *phoneNumber = phoneNumberProperty.value;
            
            if ([phoneNumberProperty.label isEqualToString:CNLabelPhoneNumberMobile]) {
                [self.txtMobile setText:phoneNumber.stringValue];
            } else if ([phoneNumberProperty.label isEqualToString:CNLabelPhoneNumberiPhone]) {
                [self.txtIPhone setText:phoneNumber.stringValue];
            } else {
                NSLog(@"%@: %@", @"其他电话", phoneNumber.stringValue);
            }
        }
        
        //取得个人图片
        NSData *photoData = contact.imageData;
        if(photoData){
            [self.imageView setImage:[UIImage imageWithData:photoData]];
        }
    }
    
}

/***
 * 保存联系人被点击
 ****/
- (IBAction)saveClick:(id)sender
{
    //复制要习惯的联系人
    CNMutableContact* contactToChange = [self.selectContact mutableCopy];
    
    // 设置电话号码
    [self savePhone:contactToChange];
    
    //设置Email属性
    [self saveEmails:contactToChange];
    
    //最后保存
    CNSaveRequest* request = [[CNSaveRequest alloc] init];//实例化保存请求对象
    [request updateContact:contactToChange];//更新联系人
    
    CNContactStore *contactStore = [[CNContactStore alloc] init];
    NSError* error;
    [contactStore executeSaveRequest:request error:&error];//联系人仓库执行保存联系人请求
    if (!error)
    {
        //导航回根视图控制器ViewController
        [self.navigationController popToRootViewControllerAnimated:TRUE];
    } else
    {
        NSLog(@"error : %@", error.localizedDescription);
    }
}

/***
 * 删除联系人被点击
 ****/
- (IBAction)deleteClick:(id)sender
{
    //复制要删除的联系人
    CNMutableContact* contact = [self.selectContact mutableCopy];

    //实例化保存请求对象
    CNSaveRequest* request = [[CNSaveRequest alloc] init];
    [request deleteContact:contact];  //删除联系人
    
    CNContactStore *contactStore = [[CNContactStore alloc] init];
    NSError* error;
    [contactStore executeSaveRequest:request error:&error];
    
    if (!error)
    {
        //导航回根视图控制器ViewController
        [self.navigationController popToRootViewControllerAnimated:TRUE];
    } else
    {
        NSLog(@"error : %@", error.localizedDescription);
    }
    
}

#pragma mark --  【工具】
/***
 * 保存手机号
 ****/
- (void)savePhone:(CNMutableContact *)contactToChange
{
    CNPhoneNumber* mobilePhoneValue = [[CNPhoneNumber alloc] initWithStringValue:self.txtMobile.text];
    CNLabeledValue* mobilePhone = [[CNLabeledValue alloc] initWithLabel:CNLabelPhoneNumberMobile  //移动电话
                                                                  value:mobilePhoneValue];
    
    CNPhoneNumber* iPhoneValue = [[CNPhoneNumber alloc] initWithStringValue:self.txtIPhone.text];
    CNLabeledValue* iPhone = [[CNLabeledValue alloc] initWithLabel:CNLabelPhoneNumberiPhone //iphone电话
                                                             value:iPhoneValue];
    
    // 添加电话号码到数据库
    contactToChange.phoneNumbers = @[mobilePhone, iPhone];
}

/***
 * 保存邮箱
 ****/
- (void)saveEmails:(CNMutableContact *)contactToChange
{
    CNLabeledValue* homeEmail = [[CNLabeledValue alloc] initWithLabel:CNLabelHome
                                                                value:self.txtHomeEmail.text];
    CNLabeledValue* workEmail = [[CNLabeledValue alloc] initWithLabel:CNLabelWork
                                                                value:self.txtWorkEmail.text];
    // 添加Email到数据库
    contactToChange.emailAddresses = @[homeEmail, workEmail];
}

@end

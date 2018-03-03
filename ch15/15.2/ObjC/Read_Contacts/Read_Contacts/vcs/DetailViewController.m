#import "DetailViewController.h"

@interface DetailViewController ()

@end

@implementation DetailViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //根据选中联系人id查询联系人，以获得其他属性
    NSError * error;
    CNContact * contact;
    [self findContactByID:&contact error:&error];
    
    if (!error)
    {
        //取得姓名属性
        NSString *name = [NSString stringWithFormat:@"%@ %@", contact.givenName, contact.familyName];
        [self.lblName setText:name];
        
        //取得多值属性Email
        [self extractMultiEmails:contact];
        
        //取得电话号码属性
        [self extractPhones:contact];
        
        //取得个人图片
        NSData *photoData = contact.imageData;
        if(photoData){
            [self.imgvHeader setImage:[UIImage imageWithData:photoData]];
        }
        
    }
    
}

/***
 * 根据选中联系人id查询联系人，以获得其他属性
 ****/
- (void)findContactByID:(CNContact **)contact
                  error:(NSError **)error
{
    //联系人工厂
    CNContactStore *contactStore = [[CNContactStore alloc] init];
    //要获取的联系人属性键
    NSArray *keysToFetch = @[CNContactFamilyNameKey,
                             CNContactGivenNameKey,
                             CNContactEmailAddressesKey,
                             CNContactPhoneNumbersKey,
                             CNContactImageDataKey];
    *error = nil;
    //根据id查询唯一的联系人
    *contact = [contactStore unifiedContactWithIdentifier:self.selectContact.identifier
                                              keysToFetch:keysToFetch error:error];
}

#pragma mark --  【工具】
/***
 * 取得多值属性Email
 ****/
- (void)extractMultiEmails:(CNContact *)contact
{
    NSArray<CNLabeledValue<NSString*>*> *emailAddresses = contact.emailAddresses;
    for (CNLabeledValue<NSString*>* emailEntry in emailAddresses)
    {
        if ([emailEntry.label isEqualToString:CNLabelWork]) //工作邮箱
        {
            [self.lblWorkEmail setText:emailEntry.value];
        } else if ([emailEntry.label isEqualToString:CNLabelHome]) //家庭邮箱
        {
            [self.lblHomeEmail setText:emailEntry.value];
        } else
        {
            NSLog(@"%@: %@", @"其他Email", emailEntry.value);
        }
    }
}

/***
 * 取得电话号码属性
 ****/
- (void)extractPhones:(CNContact *)contact
{
    NSArray<CNLabeledValue<CNPhoneNumber*>*> *phoneNumbers = contact.phoneNumbers;
    
    for (CNLabeledValue<CNPhoneNumber*>* phoneEntry in phoneNumbers)
    {
        CNPhoneNumber *phoneNumber = phoneEntry.value;
    
        if ([phoneEntry.label isEqualToString:CNLabelPhoneNumberMobile])//移动号
        {
            [self.lblMobile setText:phoneNumber.stringValue];
        } else if ([phoneEntry.label isEqualToString:CNLabelPhoneNumberiPhone])//iphone号
        {
            [self.lblIPhone setText:phoneNumber.stringValue];
        } else {
            NSLog(@"%@: %@", @"其他电话", phoneNumber.stringValue);
        }
    }
}
@end

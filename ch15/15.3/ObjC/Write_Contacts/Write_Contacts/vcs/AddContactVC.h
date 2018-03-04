
#import <UIKit/UIKit.h>
#import <Contacts/Contacts.h>


/***
 * 添加联系人控制器
 ****/
@interface AddContactVC : UITableViewController

@property (weak, nonatomic) IBOutlet UITextField *txtLastName;
@property (weak, nonatomic) IBOutlet UITextField *txtFirstName;

@property (weak, nonatomic) IBOutlet UITextField *txtMobile;
@property (weak, nonatomic) IBOutlet UITextField *txtIPhone;

@property (weak, nonatomic) IBOutlet UITextField *txtWorkEmail;
@property (weak, nonatomic) IBOutlet UITextField *txtHomeEmail;

- (IBAction)saveClick:(id)sender;
- (IBAction)cancelClick:(id)sender;

@end

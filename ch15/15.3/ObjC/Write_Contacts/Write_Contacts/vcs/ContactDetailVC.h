

#import <UIKit/UIKit.h>
#import <Contacts/Contacts.h>

/***
 * 联系人详情控制器
 ****/
@interface ContactDetailVC : UITableViewController


@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UITextField *txtMobile;

@property (weak, nonatomic) IBOutlet UITextField *txtIPhone;

@property (weak, nonatomic) IBOutlet UITextField *txtWorkEmail;
@property (weak, nonatomic) IBOutlet UITextField *txtHomeEmail;

@property (strong, nonatomic) CNContact* selectContact;

- (IBAction)saveClick:(id)sender;
- (IBAction)deleteClick:(id)sender;

@end

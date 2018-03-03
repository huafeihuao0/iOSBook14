#import <UIKit/UIKit.h>
#import <Contacts/Contacts.h>

@interface DetailViewController : UITableViewController

@property (strong, nonatomic) CNContact* selectContact; //选中的联系人，由联系人表格控制器传入

@property (weak, nonatomic) IBOutlet UIImageView *imgvHeader;//联系人头像

@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblMobile;

@property (weak, nonatomic) IBOutlet UILabel *lblIPhone;
@property (weak, nonatomic) IBOutlet UILabel *lblWorkEmail;
@property (weak, nonatomic) IBOutlet UILabel *lblHomeEmail;

@end

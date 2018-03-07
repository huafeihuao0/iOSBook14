#import <UIKit/UIKit.h>

#import "NSNumber+Message.h"

@class DetailViewController;

@interface MasterViewController : UITableViewController

@property(strong, nonatomic) DetailViewController *detailViewController;
//保存数据列表
@property(nonatomic, strong) NSMutableArray *listData;

//开始请求Web Service
- (void)getRequByDefSess;

@end

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad //
{
    [super viewDidLoad];
    //读取本地化的文本
    NSLog(@"App FinishLaunching %@", NSLocalizedString(@"Name", @"L16N App"));
    
    //设置到视图控制器的民名字
    self.title = NSLocalizedString(@"Title", @"Title");
}
@end

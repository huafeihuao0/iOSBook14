#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    //加载本地化
    NSLog(@"App FinishLaunching %@", NSLocalizedString(@"Name", @"L16N App"));
    self.title = NSLocalizedString(@"Title", @"Title");
}

@end

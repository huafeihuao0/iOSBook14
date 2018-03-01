#import "ViewController.h"

@interface ViewController ()
//用户名
@property(weak, nonatomic) IBOutlet UILabel *username;
//密码
@property(weak, nonatomic) IBOutlet UILabel *password;
//每月是否清除缓存
@property(weak, nonatomic) IBOutlet UILabel *clearCache;
//每月流量限制
@property(weak, nonatomic) IBOutlet UILabel *flowmeter;
//服务器
@property(weak, nonatomic) IBOutlet UILabel *serverName;
//通知-声音
@property(weak, nonatomic) IBOutlet UILabel *notiSound;
//通知-震动
@property(weak, nonatomic) IBOutlet UILabel *notiVibrate;

//读取设置数据
- (IBAction)getSettingData:(id)sender;

@end

@implementation ViewController

//视图将显示
- (void)viewWillAppear:(BOOL)animated
{
    [self getSettingData:nil];
}

/***
 * 获取配置数据
 **/
- (IBAction)getSettingData:(id)sender
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    // 获取字符串形式的用户名和密码
    self.username.text = [userDefaults stringForKey:@"name_preference"];
    self.password.text = [userDefaults stringForKey:@"password_preference"];

    //获取是否清理缓存
    if ([userDefaults boolForKey:@"enabled_preference"])
    {
        self.clearCache.text = @"YES";
    } else
    {
        self.clearCache.text = @"NO";
    }

    
    self.flowmeter.text = [NSString stringWithFormat:@"%.2fGB",
                                    [userDefaults doubleForKey:@"slider_preference"]];

    //获取服务器
    self.serverName.text = [userDefaults stringForKey:@"multivaule_preference"];

    if ([userDefaults boolForKey:@"sound_enabled_preference"])
    {
        self.notiSound.text = @"YES";
    } else
    {
        self.notiSound.text = @"NO";
    }


    if ([userDefaults boolForKey:@"vibrate_enabled_preference"])
    {
        self.notiVibrate.text = @"YES";
    } else
    {
        self.notiVibrate.text = @"NO";
    }
}

@end

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

//应用加载启动完成时候回调
- (BOOL)application:(UIApplication *)application
        didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    return YES;
}

//应用即将获得焦点
- (void)applicationWillResignActive:(UIApplication *)application{}

//进入前台
- (void)applicationWillEnterForeground:(UIApplication *)application {}

//获得焦点
- (void)applicationDidBecomeActive:(UIApplication *)application {}

//进入后台
- (void)applicationDidEnterBackground:(UIApplication *)application {}

//应用被终止
- (void)applicationWillTerminate:(UIApplication *)application {}

@end


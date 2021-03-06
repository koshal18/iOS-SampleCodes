//
//  AppDelegate.m
//  CoreLocationSample-CurrentLocation
//
//  Created by UQ Times on 12/05/23.
//  Copyright (c) 2012年 Individual. All rights reserved.
//

#import "AppDelegate.h"

#import "ViewController.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize viewController = _viewController;

- (void)dealloc
{
    [_window release];
    [_viewController release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    if ([launchOptions objectForKey:UIApplicationLaunchOptionsLocationKey]) {
        // アプリの終了中に大幅変更位置情報サービスの通知を受け取った場合
        NSLog(@"%s | launchOptions: %@", __PRETTY_FUNCTION__, launchOptions);
        
		UILocalNotification *lc = [[UILocalNotification alloc] init];
		lc.alertBody = @"didFinishLaunchingWithOptions";
		lc.soundName = UILocalNotificationDefaultSoundName;
		[[UIApplication sharedApplication] presentLocalNotificationNow:lc];
		[lc release];
        // ここでCLLocationManagerを利用する場合はインスタンスを作成しなければならない
    }
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        self.viewController = [[[ViewController alloc] initWithNibName:@"ViewController_iPhone" bundle:nil] autorelease];
    } else {
        self.viewController = [[[ViewController alloc] initWithNibName:@"ViewController_iPad" bundle:nil] autorelease];
    }
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    // バックグラウンドでの動作スイッチがオンで、大幅変更位置情報サービスが利用可能ならば、切り替える
    if (self.viewController.workInBackgroundSwitch.on) {
        if ([CLLocationManager locationServicesEnabled] && [CLLocationManager significantLocationChangeMonitoringAvailable]) {
            NSLog(@"%s | stopUpdatingLocation and startMonitoringSignificantLocationChanges", __PRETTY_FUNCTION__);
            [self.viewController.locationManager stopUpdatingLocation];
            [self.viewController.locationManager startMonitoringSignificantLocationChanges];
        }
    }
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    // 大幅変更位置情報サービスを使っていたのならば停止
    if ([CLLocationManager significantLocationChangeMonitoringAvailable]) {
        NSLog(@"%s | stopMonitoringSignificantLocationChanges", __PRETTY_FUNCTION__);
        [self.viewController.locationManager stopMonitoringSignificantLocationChanges];
    }
    // 標準位置情報サービスに切り替える
    if ([CLLocationManager locationServicesEnabled]) {
        NSLog(@"%s | startUpdatingLocation", __PRETTY_FUNCTION__);
        [self.viewController.locationManager startUpdatingLocation];
    }
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end

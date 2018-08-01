//
//  AppDelegate.m
//  HiplaRetail
//
//  Created by fnspl3 on 07/02/18.
//  Copyright © 2018 fnspl3. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"
#import "ProfileViewController.h"
#import "ProductCategoryViewController.h"
#import "UIImageView+WebCache.h"
#import "APIManager.h"
#import "ZoneViewController.h"

@interface AppDelegate (){
    
    NSDictionary *ProfInfo;
    NSString *userId;
    NSString *zoneIdStr;
}

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // Override point for customization after application launch.
    api = [APIManager sharedManager];
    
    NSString *uniqueIdentifier = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    
    [[NSUserDefaults standardUserDefaults] setObject:uniqueIdentifier forKey:@"device_id"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    //-- Set Notification
    if ([application respondsToSelector:@selector(isRegisteredForRemoteNotifications)])
    {
        // iOS 8 Notifications
        [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        
        [application registerForRemoteNotifications];
    }
    else
    {
        // iOS < 8 Notifications
        [application registerForRemoteNotificationTypes:
         (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound)];
    }
    
    [application setApplicationIconBadgeNumber:0];
    
    NSArray *arrZone = [NSArray arrayWithObjects:@"1",@"2",@"3",@"4",@"5",@"6", nil];
    
    for (int i=0; i<[arrZone count]; i++)
    {
        [Userdefaults setBool:NO forKey:[NSString stringWithFormat:@"offerDescription:%@",[arrZone objectAtIndex:i]]];
        
        [Userdefaults synchronize];
    }
    
    [launchOptions valueForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    
    [Userdefaults setBool:NO forKey:@"isEntry"];
    [Userdefaults setBool:NO forKey:@"isWelcome"];
    [Userdefaults setBool:NO forKey:@"isDistPresent"];
    [Userdefaults setBool:NO forKey:@"isLoginSuccess"];
    
    [Userdefaults synchronize];
    
    [Fabric with:@[[Crashlytics class]]];
    
    //For gps
    [self startStandardUpdates];
    
    [self registerForRemoteNotifications:application];
    //////////////////////////////////////////////////////////////////////////////////////////////
    self.window = [[UIWindow alloc]initWithFrame:[[UIScreen mainScreen] bounds]];
    
    isLoggedIn = [Userdefaults objectForKey:@"isLoggedIn"];
    
    if([isLoggedIn isEqualToString:@"YES"]){
        
        [Userdefaults setBool:YES forKey:@"isLoginSuccess"];
        
//        homeVc = [[ProductCategoryViewController alloc]initWithNibName:@"ProductCategoryViewController" bundle:nil];
//
//        nav = [[UINavigationController alloc]initWithRootViewController:homeVc];
        
        
        homeVc = [[ProductCategoryViewController alloc]initWithNibName:@"ProductCategoryViewController" bundle:nil];
        
        menu = [[MenuTableViewController alloc] init];
        drawer = [[KYDrawerController alloc] init];
        
        [menu setElDrawer:drawer];
        
        nav = [[UINavigationController alloc] initWithRootViewController:homeVc];
        
        drawer.mainViewController = nav;
        
        drawer.drawerViewController = menu;
        
        /* Customize */
        drawer.drawerDirection = KYDrawerControllerDrawerDirectionLeft;
        drawer.drawerWidth = 5*(SCREENWIDTH/8);
        
        self.window.rootViewController = drawer;
        
    }
    else
    {
        loginVc = [[LoginViewController alloc]initWithNibName:@"LoginViewController" bundle:nil];
        
        nav = [[UINavigationController alloc]initWithRootViewController:loginVc];
        
        self.window.rootViewController = nav;
    }
    
    [self.window makeKeyAndVisible];
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}


// This code block is invoked when application is in foreground (active-mode)
-(void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    //    NSLog(@"didReceiveLocalNotification");
//    NSLog(@"Object = %@", notification);
//
//    NSDictionary* userInfo = [notification userInfo];
//    NSLog(@"UserInfo = %@", userInfo);
//
//    isLoggedIn = [Userdefaults objectForKey:@"isLoggedIn"];
//
//    if([isLoggedIn isEqualToString:@"YES"]){
//
//        zoneVc = [[ZoneViewController alloc]initWithNibName:@"ZoneViewController" bundle:nil];
//
//        zoneVc.discountlist = userInfo;
//
//        nav = [[UINavigationController alloc]initWithRootViewController:zoneVc];
//    }
//
//    self.window.rootViewController = nav;
//    [self.window makeKeyAndVisible];
//    
//    NSLog(@"didReceiveLocalNotification");
}

-(void)localNotif
{
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    
    UNAuthorizationOptions options = UNAuthorizationOptionBadge + UNAuthorizationOptionSound;
    
    [center requestAuthorizationWithOptions:options
                          completionHandler:^(BOOL granted, NSError * _Nullable error) {
                              if (!granted) {
                                  NSLog(@"Something went wrong");
                              }
                          }];
}

- (void)registerForRemoteNotifications:(UIApplication *)application
{
    if(SYSTEM_VERSION_GRATERTHAN_OR_EQUALTO(@"8.0")){
        
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        
        center.delegate = self;
        
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionBadge) completionHandler:^(BOOL granted, NSError * _Nullable error){
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
                
                if(!error){
                    
                    [[UIApplication sharedApplication] registerForRemoteNotifications];
                }
                
            });
            
        }];
        
    }
    else {
        
        // Code for old versions
    }
}

//Called when a notification is delivered to a foreground app.
-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler{
    
    NSLog(@"User Info : %@",notification.request.content.userInfo);
    
    //    if ([[notification.request.content.userInfo allKeys] count]>0) {
    //
    //        userinfo = notification.request.content.userInfo;
    //
    //        [UIApplication sharedApplication].applicationIconBadgeNumber = [[[userinfo objectForKey:@"aps"] objectForKey: @"badgecount"] intValue];
    //
    //    }
    
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
    if ([UIApplication sharedApplication].applicationState == UIApplicationStateActive||[UIApplication sharedApplication].applicationState == UIApplicationStateInactive||[UIApplication sharedApplication].applicationState == UIApplicationStateBackground)
    {
        //        NSDictionary* userInfo = notification.request.content.userInfo;
        //
        //        NSLog(@"UserInfo = %@", userInfo);
        //
        //        isLoggedIn = [Userdefaults objectForKey:@"isLoggedIn"];
        //
        //        if([isLoggedIn isEqualToString:@"YES"]){
        //
        //            zoneVc = [[ZoneViewController alloc]initWithNibName:@"ZoneViewController" bundle:nil];
        //
        //            zoneVc.userInfoDict = userInfo;
        //
        //            nav = [[UINavigationController alloc]initWithRootViewController:zoneVc];
        //        }
        //
        //        self.window.rootViewController = nav;
        //        [self.window makeKeyAndVisible];
        
    }
    
    completionHandler(UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionBadge);
}


//Called to let your app know which action was selected by the user for a given notification.
-(void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)())completionHandler{
    
    NSLog(@"User Info : %@",response.notification.request.content.userInfo);
    
    //    if ([[notification.request.content.userInfo allKeys] count]>0) {
    //
    //        userinfo = notification.request.content.userInfo;
    //
    //        [UIApplication sharedApplication].applicationIconBadgeNumber = [[[userinfo objectForKey:@"aps"] objectForKey: @"badgecount"] intValue];
    //
    //    }
    
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
    if ([UIApplication sharedApplication].applicationState == UIApplicationStateActive||[UIApplication sharedApplication].applicationState == UIApplicationStateInactive||[UIApplication sharedApplication].applicationState == UIApplicationStateBackground)
    {
        NSDictionary* userInfo = response.notification.request.content.userInfo;
        NSString *strMsg = response.notification.request.content.body;
        
        NSLog(@"UserInfo = %@", userInfo);
        
        isLoggedIn = [Userdefaults objectForKey:@"isLoggedIn"];
        
        if([isLoggedIn isEqualToString:@"YES"]){
            
            
            if ([[userInfo allKeys] containsObject:@"aps"]) {
                
                NSString *status = [[userInfo objectForKey:@"aps"] objectForKey:@"alert"];
                
                if ([status containsString:@"zone notification text"]) {
                    
                    // NSMutableArray *arrZoneNames = [Userdefaults objectForKey:@"arrzoneName"];
                    
                    int zone = 0;
                    
                    NSDictionary *dict = [Userdefaults objectForKey:@"ZoneNameInfo"];
                    zoneIdStr = [NSString stringWithFormat:@"%@",[dict objectForKey:@"ZoneIdInfo"]];
                    
                    if ([status containsString:@"conference room small"]) {
                        
                        zone  = 1;
                        
                        if ([zoneIdStr integerValue]==zone)
                        {
                            zoneVc = [[ZoneViewController alloc]initWithNibName:@"ZoneViewController" bundle:nil];
                            
                            zoneVc.discountlist = dict;
                            
                            nav = [[UINavigationController alloc]initWithRootViewController:zoneVc];
                        }
                        
                    }
                    else if ([status containsString:@"service desk"]) {
                        
                        zone  = 2;
                        
                        if ([zoneIdStr integerValue]==zone)
                        {
                            zoneVc = [[ZoneViewController alloc]initWithNibName:@"ZoneViewController" bundle:nil];
                            
                            zoneVc.discountlist = dict;
                            
                            nav = [[UINavigationController alloc]initWithRootViewController:zoneVc];
                        }
                        
                    }
                    else if ([status containsString:@"Developers 1"]) {
                        
                        zone  = 3;
                        
                        if ([zoneIdStr integerValue]==zone)
                        {
                            zoneVc = [[ZoneViewController alloc]initWithNibName:@"ZoneViewController" bundle:nil];
                            
                            zoneVc.discountlist = dict;
                            
                            nav = [[UINavigationController alloc]initWithRootViewController:zoneVc];
                        }
                        
                    }
                    else if ([status containsString:@"conference area"]) {
                        
                        zone  = 4;
                        
                        if ([zoneIdStr integerValue] == zone)
                        {
                            zoneVc = [[ZoneViewController alloc]initWithNibName:@"ZoneViewController" bundle:nil];
                            
                            zoneVc.discountlist = dict;
                            
                            nav = [[UINavigationController alloc]initWithRootViewController:zoneVc];
                   
                        }
                        
                    }
                    else if ([status containsString:@"Developers 2"]) {
                        
                        zone  = 5;
                        
                        if ([zoneIdStr integerValue]==zone)
                        {
                            zoneVc = [[ZoneViewController alloc]initWithNibName:@"ZoneViewController" bundle:nil];
                            
                            zoneVc.discountlist = dict;
                            
                            nav = [[UINavigationController alloc]initWithRootViewController:zoneVc];
                        }
                        
                    }
                    else if ([status containsString:@"marketing room"]) {
                        
                        zone  = 6;
                        
                        if ([zoneIdStr integerValue]==zone)
                        {
                            zoneVc = [[ZoneViewController alloc]initWithNibName:@"ZoneViewController" bundle:nil];
                            
                            zoneVc.discountlist = dict;
                            
                            nav = [[UINavigationController alloc]initWithRootViewController:zoneVc];
                        }
                        
                    }
                    
                }
                else if ([status containsString:@"do you need any asistance?"]) {
                    
                    [self getSendPushToSale];
                    
                }
                
            }
            else
            {
                if ([strMsg containsString:@"Now a flat"]){
                    
                    zoneVc = [[ZoneViewController alloc]initWithNibName:@"ZoneViewController" bundle:nil];
                    
                    zoneVc.discountlist = userInfo;
                    
                    menu = [[MenuTableViewController alloc] init];
                    drawer = [[KYDrawerController alloc] init];
                    
                    [menu setElDrawer:drawer];
                    
                    nav = [[UINavigationController alloc] initWithRootViewController:zoneVc];
                    
                    drawer.mainViewController = nav;
                    
                    drawer.drawerViewController = menu;
                    
                    /* Customize */
                    drawer.drawerDirection = KYDrawerControllerDrawerDirectionLeft;
                    drawer.drawerWidth = 5*(SCREENWIDTH/8);
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        self.window.rootViewController = drawer;
                        
                    });
                    
                    
                }
                else if ([strMsg containsString:@"Welcome to Hipla Retail.Macbook Pro is available on 34% of discount.Checkout now."]) {
                    
                    homeVc = [[ProductCategoryViewController alloc]initWithNibName:@"ProductCategoryViewController" bundle:nil];
                    
                    nav = [[UINavigationController alloc]initWithRootViewController:homeVc];
                    
                }
                else if ([strMsg containsString:@"Your car parking space is available."]) {
                    
                    homeVc = [[ProductCategoryViewController alloc]initWithNibName:@"ProductCategoryViewController" bundle:nil];
                    
                    nav = [[UINavigationController alloc]initWithRootViewController:homeVc];
                    
                }
                else if ([strMsg containsString:@"do you need any asistance?"]) {
                    
                    [self getSendPushToSale];
                    
                    homeVc = [[ProductCategoryViewController alloc]initWithNibName:@"ProductCategoryViewController" bundle:nil];
                    
                    nav = [[UINavigationController alloc]initWithRootViewController:homeVc];
                    
                }
                
//                else if ([strMsg containsString:@"Get a discount up to"]) {
//                    
//                    zoneVc = [[ZoneViewController alloc]initWithNibName:@"ZoneViewController" bundle:nil];
//                    
//                    zoneVc.discountlist = userInfo;
//                    
//                    nav = [[UINavigationController alloc]initWithRootViewController:zoneVc];
//                    
//                }
                else{
                    
//                    zoneVc = [[ZoneViewController alloc]initWithNibName:@"ZoneViewController" bundle:nil];
//
//                    zoneVc.discountlist = userInfo;
//
//                    nav = [[UINavigationController alloc]initWithRootViewController:zoneVc];
                }
            }
            
        }
        
        else{
            
            loginVc = [[LoginViewController alloc]initWithNibName:@"LoginViewController" bundle:nil];
            
            nav = [[UINavigationController alloc]initWithRootViewController:loginVc];
            
        }
        
        self.window.rootViewController = nav;
        [self.window makeKeyAndVisible];
    }
    
    completionHandler(UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionBadge);
    
}

- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings // NS_AVAILABLE_IOS(8_0);
{
    [application registerForRemoteNotifications];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    
    // NSLog(@"deviceToken: %@", deviceToken);
    
    NSString * token = [NSString stringWithFormat:@"%@", deviceToken];
    //Format token as you need:
    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    token = [token stringByReplacingOccurrencesOfString:@">" withString:@""];
    token = [token stringByReplacingOccurrencesOfString:@"<" withString:@""];
    
    NSLog(@"token: %@", token);
    
    // [self sendEmailwithBody:token];
    
    [Utils setDeviceToken:token];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    
    NSLog(@"Did Fail to Register for Remote Notifications");
    NSLog(@"%@, %@", error, error.localizedDescription);
    
}


-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    NSLog(@"%@",userInfo);
    
    application.applicationIconBadgeNumber = 0;
    
    if (application.applicationState == UIApplicationStateActive)
    {
        
    }
}
/////////////////For gps//////////////////////////////
- (void)startStandardUpdates
{
    // Create the location manager if this object does not
    // already have one.
    if (nil == self.locationManager)
        
        self.locationManager = [[CLLocationManager alloc] init];
    
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
    self.locationManager.activityType = kCLLocationAccuracyNearestTenMeters;
    
    // Set a movement threshold for new events.
    self.locationManager.distanceFilter = 10; // meters
    
    [self.locationManager startUpdatingLocation];
    
    if(IS_OS_8_OR_LATER) {
        
        [self.locationManager requestAlwaysAuthorization];
    }
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9) {
        
        _locationManager.allowsBackgroundLocationUpdates = YES;
    }
    
    [self.locationManager startMonitoringSignificantLocationChanges];
    
}

#pragma mark - Location Manager delegates
/////////////////For Gps/////////////////////////
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    NSLog(@"didUpdateLocations: %@", [locations lastObject]);
    
    CLLocation *loc = [locations lastObject];
    
    if (loc!=nil)
    {
        isLoggedIn = [Userdefaults objectForKey:@"isLoggedIn"];
        
        if([isLoggedIn isEqualToString:@"YES"])
        {
            //CLLocation *location = [[CLLocation alloc] initWithLatitude:22.573228 longitude:88.452763];
            
            //double Dist = [location distanceFromLocation:_locationManager.location];
            
            // [self performSelector:@selector(reverseGeoCode:) withObject:_locationManager.location afterDelay:180.0];
            
            [self reverseGeoCode:_locationManager.location];
            
            BOOL isDistPresent = [Userdefaults boolForKey:@"isDistPresent"];
            
            if (isDistPresent==YES)
            {
                if(Dist<=200)
                {
                    BOOL isWelcome = [Userdefaults boolForKey:@"isWelcome"];
                    
                    if (isWelcome==NO)
                    {
                        //NSDictionary *dict = [NSDictionary dictionaryWithObject:_zoneId forKey:@"ZoneIdInfo"];
                        UILocalNotification *notification = [[UILocalNotification alloc] init];
                        notification.fireDate = [NSDate date];
                        notification.alertBody = @"Welcome to Hipla Retail.Macbook Pro is available on 34% of discount.Checkout now.";
                        notification.timeZone = [NSTimeZone localTimeZone];
                        // notification.userInfo = dict;
                        notification.soundName = UILocalNotificationDefaultSoundName;
                        //   notification.applicationIconBadgeNumber = 1;
                        notification.repeatInterval=0;
                        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
                        
                        [Userdefaults setBool:YES forKey:@"isWelcome"];
                        [Userdefaults synchronize];
                        
                    }
                    
                }
                else if (Dist>200)
                    
                {
                    [Userdefaults setBool:NO forKey:@"isWelcome"];
                    [Userdefaults synchronize];
                }
                
            }
        }
        
    }
    
}

/////////////////////For Gps///////////////////////////
-(void)GetDistance:(CLLocation *)location
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    
    NSString *hostUrl = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/distancematrix/json?origins=%@&destinations=future+netwings&key=%@",strAddress,API_KEY];
    
    [manager GET:hostUrl parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"JSON: %@", responseObject);
        
        NSDictionary *dict = responseObject;
        
        NSArray *rows = [dict objectForKey:@"rows"];
        
        if ([rows count]>0) {
            
            NSDictionary *elements = [rows objectAtIndex:0];
            
            NSArray *details = [elements objectForKey:@"elements"];
            
            NSDictionary *ETAinfo = [details objectAtIndex:0];
            
            NSDictionary *distanceDic = [ETAinfo objectForKey:@"distance"];
            
            NSDictionary *durationDic = [ETAinfo objectForKey:@"duration"];
            
            distance = [distanceDic objectForKey:@"text"];
            
            duration = [durationDic objectForKey:@"text"];
            
            NSArray *arrUnit = [distance componentsSeparatedByString:@" "];
            
            if ([arrUnit count]>0) {
                
                NSString *addressStr = [arrUnit objectAtIndex:0];
                
                Dist = [addressStr doubleValue];
                
                if ([arrUnit containsObject:@"km"]) {
                    
                    Dist = Dist *100;
                }
                
                [Userdefaults setBool:YES forKey:@"isDistPresent"];
                [Userdefaults synchronize];
            }
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"Error: %@", error);
        
    }];
    
}

///////////////For Gps//////////////////////////////////
-(void)reverseGeoCode:(CLLocation *)location
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    
    NSString *hostUrl = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/geocode/json?latlng=%f,%f&sensor=true", location.coordinate.latitude, location.coordinate.longitude];;
    
    [manager GET:hostUrl parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        //NSLog(@"JSON: %@", responseObject);
        
        NSDictionary *dict = responseObject;
        
        NSArray *arrResults = [dict objectForKey:@"results"];
        
        if ([arrResults count]>0) {
            
            NSDictionary *address_components = [arrResults objectAtIndex:0];
            
            NSString *strAddress1 = [address_components objectForKey:@"formatted_address"];
            
            NSString *strAddress2 = [strAddress1 stringByReplacingOccurrencesOfString:@", " withString:@","];
            
            NSString *strAddress3 = [strAddress2 stringByReplacingOccurrencesOfString:@" " withString:@"+"];
            
            //NSLog(@"strAddress: %@", strAddress3);
            
            strAddress = strAddress3;
            
            [self GetDistance:location];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        NSLog(@"Error: %@", error);
        
    }];
    
}

/////////////////////For Gps///////////////////////////
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"Location manager error: %@", error.localizedDescription);
}

/////////////////////For Gps///////////////////////////
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    
    if (status == kCLAuthorizationStatusAuthorizedAlways) {
        
        [self.locationManager startUpdatingLocation];
        
    } else if (status == kCLAuthorizationStatusDenied) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Location services not authorised" message:@"This app needs you to authorise locations services to work."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        
    } else
        
        NSLog(@"Wrong location status");
}


#pragma mark - Core Data stack

@synthesize persistentContainer = _persistentContainer;
- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.crescentek.Entr" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}
- (NSPersistentContainer *)persistentContainer {
    // The persistent container for the application. This implementation creates and returns a container, having loaded the store for the application to it.
    @synchronized (self) {
        if (_persistentContainer == nil) {
            _persistentContainer = [[NSPersistentContainer alloc] initWithName:@"HiplaRetail"];
            [_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
                if (error != nil) {
                    // Replace this implementation with code to handle the error appropriately.
                    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    
                    /*
                     Typical reasons for an error here include:
                     * The parent directory does not exist, cannot be created, or disallows writing.
                     * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                     * The device is out of space.
                     * The store could not be migrated to the current model version.
                     Check the error message to determine what the actual problem was.
                    */
                    NSLog(@"Unresolved error %@, %@", error, error.userInfo);
                    abort();
                }
            }];
        }
    }
    
    return _persistentContainer;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *context = self.persistentContainer.viewContext;
    NSError *error = nil;
    if ([context hasChanges] && ![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
}
-(void)getSendPushToSale
{
    [SVProgressHUD show];
    
    NSString *userUpdate = [NSString stringWithFormat:@"body=%@&title=%@",[NSString stringWithFormat:@"%@",@"I need some assistants"],[NSString stringWithFormat:@"%@",@"RetailReport"]];
    //Convert the String to Data
    NSData *data = [userUpdate dataUsingEncoding:NSUTF8StringEncoding];
    
    [api ApiRequestPOSTwithPostdata:data WithUrlLastPart:@"sendPush_to_sale.php" completion:^(NSDictionary * dict, NSError *error) {
        
        [SVProgressHUD dismiss];
        
        NSLog(@"%@",dict);
        
        NSLog(@"%@",error);
        
        if (!error) {
            
            NSString *successStr = [dict objectForKey:@"status"];
            
            if ([successStr isEqualToString:@"success"]) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [Userdefaults removeObjectForKey:@"CountZoneId"];
                    [Userdefaults synchronize];
                    
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Post the request to the salesman."
                                                                        message:nil
                                                                       delegate:nil
                                                              cancelButtonTitle:@"Ok"
                                                              otherButtonTitles:nil];
                    [alertView show];
                    
                });
                
                
            }
            else {
                
                [SVProgressHUD dismiss];
                
                NSLog(@"Error: %@", error);
                
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"There have some problem with login, try again later."
                                                                    message:nil
                                                                   delegate:nil
                                                          cancelButtonTitle:@"Ok"
                                                          otherButtonTitles:nil];
                [alertView show];
                
            }
        }
    }];
    
}
@end

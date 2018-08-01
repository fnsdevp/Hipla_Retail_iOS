//
//  AppDelegate.h
//  HiplaRetail
//
//  Created by fnspl3 on 07/02/18.
//  Copyright © 2018 fnspl3. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "LoginViewController.h"
#import "MenuTableViewController.h"
#import "KYDrawerController.h"
#import "ProductCategoryViewController.h"
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>
#import <AFNetworking/AFNetworking.h>
#import <CoreLocation/CoreLocation.h>
#import <UserNotifications/UserNotifications.h>
#import "ZoneViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    LoginViewController *loginVc;
    ProductCategoryViewController *homeVc;
    ZoneViewController *zoneVc;
    UINavigationController *nav;
    KYDrawerController *drawer;
    MenuTableViewController *menu;
    
    NSString *isLoggedIn;
    APIManager *api;
    
    BOOL addressFetch;
    double Dist;
    NSString *distance;
    NSString *duration;
    NSString *strAddress;
}
@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property CLLocationManager *locationManager;
@property (weak, nonatomic) CLLocation *cLoc;
- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end


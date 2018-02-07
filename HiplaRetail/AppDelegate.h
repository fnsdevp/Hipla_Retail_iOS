//
//  AppDelegate.h
//  HiplaRetail
//
//  Created by fnspl3 on 07/02/18.
//  Copyright © 2018 fnspl3. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end


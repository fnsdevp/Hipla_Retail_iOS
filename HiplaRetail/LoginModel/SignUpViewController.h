//
//  SignUpViewController.h
//  Jing
//
//  Created by fnspl3 on 08/09/17.
//  Copyright © 2017 fnspl3. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSDictionary+NullReplacement.h"
@class KYDrawerController;
#import "APIManager.h"
#import "MenuTableViewController.h"

@interface SignUpViewController : UIViewController<UITextFieldDelegate>{
    
    
    APIManager *api;
    KYDrawerController *drawer;
    MenuTableViewController *menu;
    UINavigationController *localNavigationController;

}
@property (weak, nonatomic) IBOutlet UIView *userDetailsView;
@property (weak, nonatomic) IBOutlet UITextField *txtEmail;
@property (weak, nonatomic) IBOutlet UITextField *txtPhoneNumber;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;
@property (weak, nonatomic) IBOutlet UITextField *txtFirstName;
@property (weak, nonatomic) IBOutlet UITextField *txtLastName;
@property (weak, nonatomic) IBOutlet UITextField *txtLocation;
@property (weak, nonatomic) IBOutlet UITextField *txtPincode;
@property (weak, nonatomic) IBOutlet UIView *loginView;
- (IBAction)loginBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *signupView;
- (IBAction)signUpBtn:(id)sender;

@property (weak, nonatomic) KYDrawerController *elDrawer;

@end

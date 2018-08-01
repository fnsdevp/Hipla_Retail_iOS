//
//  ProfileViewController.h
//  Jing
//
//  Created by fnspl3 on 18/09/17.
//  Copyright © 2017 fnspl3. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSDictionary+NullReplacement.h"
#import "KYDrawerController.h"
#import "MenuTableViewController.h"
#import "APIManager.h"

@interface ProfileViewController : UIViewController<UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>{
    
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
@property (weak, nonatomic) IBOutlet UIView *viewUpdate;

@property (weak, nonatomic) IBOutlet UIImageView *imgProfilePic;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicatorView;
@property (weak, nonatomic) IBOutlet UIView *viewCount;
@property (weak, nonatomic) IBOutlet UILabel *lblCount;
@property (weak, nonatomic) IBOutlet UIButton *btnCountOutlet;

- (IBAction)addToCart:(id)sender;
- (IBAction)btnUpdate:(id)sender;
- (IBAction)btnJing:(id)sender;

@end

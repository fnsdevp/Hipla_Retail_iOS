//
//  ForgetPasswordViewController.h
//  Jing
//
//  Created by fnspl3 on 08/09/17.
//  Copyright © 2017 fnspl3. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "APIManager.h"


@interface ForgetPasswordViewController : UIViewController{
    
    APIManager *api;

}
@property (weak, nonatomic) IBOutlet UIView *emailView;
@property (weak, nonatomic) IBOutlet UITextField *txtEmail;
@property (weak, nonatomic) IBOutlet UIView *loginView;
- (IBAction)loginBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *submitView;
- (IBAction)submitBtn:(id)sender;

@end

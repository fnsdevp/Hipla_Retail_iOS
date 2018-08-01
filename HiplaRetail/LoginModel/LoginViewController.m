//
//  LoginViewController.m
//  Jing
//
//  Created by fnspl3 on 08/09/17.
//  Copyright © 2017 fnspl3. All rights reserved.
//

#import "LoginViewController.h"
#import "SignUpViewController.h"
#import "ForgetPasswordViewController.h"
#import "YourCartViewController.h"
#import "SubCategoryViewController.h"
#import "ProductDetailsViewController.h"
#import "ProductCategoryViewController.h"

@interface LoginViewController (){
    
    NSArray *productCategory;

    
}

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
  [self.navigationController.navigationBar setHidden:YES];
//    [Userdefaults setObject:@"" forKey:@"deviceToken"];
//    
//    [Userdefaults synchronize];
    _viewSignUp.layer.cornerRadius = 20.0f;
    _viewSignUp.clipsToBounds = YES;
    _viewSignUp.layer.borderWidth=2.0f;
    //    _loginView.layer.borderColor=(__bridge CGColorRef _Nullable)([UIColor lightGrayColor]);
    _viewSignUp.layer.borderColor=[UIColor lightGrayColor].CGColor;
    _viewLogin.layer.cornerRadius = 20.0f;
    _viewLogin.clipsToBounds = YES;
    _viewLogin.layer.borderWidth=2.0f;
    // _submitView.layer.borderColor=[[UIColor greenColor] CGColor];
    _viewLogin.layer.borderColor=[[UIColor colorWithRed:80/255.0 green:187/255.0 blue:232/255.0 alpha:1.0] CGColor];
    
    
    UIView *statusBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 20)];
    statusBarView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:statusBarView];
    
    _emailPassView.layer.cornerRadius = 5.0f;
    _emailPassView.clipsToBounds = YES;
    api = [APIManager sharedManager];
    
//    [api createSession];
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:YES];
    [self.navigationController.navigationBar setHidden:YES];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)forgetPassBtn:(id)sender {
    
    ForgetPasswordViewController *forgotpasswordScreen = [[ForgetPasswordViewController alloc]initWithNibName:@"ForgetPasswordViewController" bundle:nil];
    [self.navigationController pushViewController:forgotpasswordScreen animated:YES];
}

- (IBAction)signUpBtn:(id)sender {
    SignUpViewController *homeScreen = [[SignUpViewController alloc]initWithNibName:@"SignUpViewController" bundle:nil];
    [self.navigationController pushViewController:homeScreen animated:YES];
    
}
- (IBAction)loginBtn:(id)sender {
    
    [self LoginWithDetails];
 
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark- TextField Validation

-(BOOL) notEmptyChecking{
    
    if([_txtEmail.text isEqualToString:@""]){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Please provide the email address."
                                                            message:nil
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
        [alertView show];
        [_txtEmail becomeFirstResponder];
        return NO;
    }
    
    if([_txtPassword.text isEqualToString:@""]){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Password can't be empty."
                                                            message:nil
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
        [alertView show];
        [_txtPassword becomeFirstResponder];
        return NO;
    }
    
    return YES;
}

-(BOOL) validityChecking:(UITextField *) textField{
    
    BOOL validEmail = [Utils isEmailAddress:_txtEmail.text];
    
    if(validEmail == NO){
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Please provide a valid email address."
                                                            message:nil
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
        [alertView show];
        
        [_txtEmail becomeFirstResponder];
        
        return NO;
    }
    
    return YES;
}

-(BOOL) NSStringIsValidEmail:(NSString *)emailString{
    BOOL stricterFilter = NO;
    NSString *stricterFilterString = @"^[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}$";
    NSString *laxString = @"^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:emailString];
}

-(void)LoginWithDetails
{
    if([self notEmptyChecking] == NO){return;}
    
    if([self validityChecking:_txtEmail] == NO){return;}
    
//    if ([Utils isEmailAddress:_txtEmail.text]) {
//        
//        return;
//    }
    
    [SVProgressHUD show];
    
    NSString *deviceToken = [Utils deviceToken];
    
//    NSDictionary *params = @{@"username":self.txtEmail.text,@"password":self.txtPassword.text,@"deviceId":deviceToken,@"type":@"iOS"};
    
//    NSDictionary *params = @{@"username":[NSString stringWithString: self.txtEmail.text],@"password":[NSString stringWithString:self.txtPassword.text],@"deviceId":@"78141ce550d27d5c4e9f7fb6aba7d38c80bc1e641412881f03ad61ba1c9f6e14",@"dtype":@"ios"};
    
//    NSLog(@"params==%@",params);
    
//        NSString *userUpdate = @{@"username":self.txtEmail.text,@"password":self.txtPassword.text,@"deviceId":deviceToken,@"dtype":@"iOS"};
    
    
    NSString *userUpdate = [NSString stringWithFormat:@"username=%@&password=%@&deviceId=%@&dtype=ios",[NSString stringWithFormat:@"%@", self.txtEmail.text],[NSString stringWithFormat:@"%@",self.txtPassword.text],deviceToken];
     NSLog(@"%@",userUpdate);
    
//    NSString *userUpdate = @"username=josephmcclane3@gmail.com&password=123456&deviceId=78141ce550d27d5c4e9f7fb6aba7d38c80bc1e641412881f03ad61ba1c9f6e14&dtype=ios";
    
    //Convert the String to Data
    NSData *data = [userUpdate dataUsingEncoding:NSUTF8StringEncoding];

//    [api ApiRequestPOSTwithParameters:params WithUrlLastPart:@"login.php" completion:^(NSDictionary * dict, NSError *error) {
    
    [api ApiRequestPOSTwithPostdata:data WithUrlLastPart:@"login.php" completion:^(NSDictionary * dict, NSError *error) {
        [SVProgressHUD dismiss];
        
        NSLog(@"%@",dict);
        
        NSLog(@"%@",error);
        
        if (!error) {
            
            NSString *successStr = [dict objectForKey:@"status"];
            
            if ([successStr isEqualToString:@"success"]) {
                
                productCategory = [dict objectForKey:@"profile"];
                
                if ([productCategory count]>0) {
                    
                    NSDictionary *ProfDict = (NSDictionary *)[productCategory objectAtIndex:0];
                    
                    NSDictionary *dict = [ProfDict dictionaryByReplacingNullsWithBlanks];
                    NSLog(@"DICT=====%@",dict);
                    
                    [Userdefaults setObject:dict forKey:@"ProfInfo"];
                    [Userdefaults setObject:@"YES" forKey:@"isLoggedIn"];
                    
                    [Userdefaults synchronize];
                    
                    BOOL isLoginSuccess = [Userdefaults boolForKey:@"isLoginSuccess"];
                    
                    if (isLoginSuccess==NO)
                    {
                        UILocalNotification *notification = [[UILocalNotification alloc] init];
                        notification.fireDate = [NSDate date];
                        notification.alertBody = @"Your car parking space is available.";
                        notification.timeZone = [NSTimeZone localTimeZone];
                        notification.soundName = UILocalNotificationDefaultSoundName;
                        //   notification.applicationIconBadgeNumber = 1;
                        
                        notification.repeatInterval=0;
                        
                        [Userdefaults setBool:YES forKey:@"isLoginSuccess"];
                        
                        [Userdefaults synchronize];
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            [[UIApplication sharedApplication] scheduleLocalNotification:notification];
                        });
                        
                    }
                    
//                    ProductCategoryViewController *productCategoryViewControllerScreen = [[ProductCategoryViewController alloc]initWithNibName:@"ProductCategoryViewController" bundle:nil];
                    
//                    dispatch_async(dispatch_get_main_queue(), ^{
//
//                       [self.navigationController pushViewController:productCategoryViewControllerScreen animated:YES];
//                    });
                    
                    [self gotoHome];
    
                }
                
            }
            else{
                
                NSString *failurStr = [dict objectForKey:@"status"];
                
                if ([failurStr isEqualToString:@"failur"])
                {
                    NSString *messageStr = [dict objectForKey:@"message"];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:messageStr
                                                                            message:nil
                                                                           delegate:nil
                                                                  cancelButtonTitle:@"Ok"
                                                                  otherButtonTitles:nil];
                        
                        
                        [alertView show];
                        
                        [SVProgressHUD dismiss];
                        
                    });
                    
                    
                }
                
            }
            
        } else {
            
            [SVProgressHUD dismiss];
            
            NSLog(@"Error: %@", error);
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"There have some problem with login, try again later."
                                                                message:nil
                                                               delegate:nil
                                                      cancelButtonTitle:@"Ok"
                                                      otherButtonTitles:nil];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [alertView show];
                
            });
            
           
        }
        
    }];
    
}

-(void)gotoHome
{
    ProductCategoryViewController *productViewScreen = [[ProductCategoryViewController alloc]initWithNibName:@"ProductCategoryViewController" bundle:nil];

    menu = [[MenuTableViewController alloc] init];
    drawer = [[KYDrawerController alloc] init];

    [menu setElDrawer:drawer];

    localNavigationController = [[UINavigationController alloc] initWithRootViewController:productViewScreen];

    drawer.mainViewController = localNavigationController;

    drawer.drawerViewController = menu;

    /* Customize */
    drawer.drawerDirection = KYDrawerControllerDrawerDirectionLeft;
    drawer.drawerWidth = 5*(SCREENWIDTH/8);

    dispatch_async(dispatch_get_main_queue(), ^{

        [UIApplication sharedApplication].keyWindow.rootViewController = drawer;
    });

}

@end

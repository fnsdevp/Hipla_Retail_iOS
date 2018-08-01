//
//  ForgetPasswordViewController.m
//  Jing
//
//  Created by fnspl3 on 08/09/17.
//  Copyright © 2017 fnspl3. All rights reserved.
//

#import "ForgetPasswordViewController.h"
#import "LoginViewController.h"
#import "ProductCategoryViewController.h"

@interface ForgetPasswordViewController (){
    NSString *text;
}

@end

@implementation ForgetPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    api = [APIManager sharedManager];
    
    _emailView.layer.cornerRadius = 5.0f;
    _emailView.clipsToBounds = YES;
    _loginView.layer.cornerRadius = 20.0f;
    _loginView.clipsToBounds = YES;
    _loginView.layer.borderWidth=2.0f;
//    _loginView.layer.borderColor=(__bridge CGColorRef _Nullable)([UIColor lightGrayColor]);
    _loginView.layer.borderColor=[UIColor lightGrayColor].CGColor;
    _submitView.layer.cornerRadius = 20.0f;
    _submitView.clipsToBounds = YES;
    _submitView.layer.borderWidth=2.0f;
   // _submitView.layer.borderColor=[[UIColor greenColor] CGColor];
    _submitView.layer.borderColor=[[UIColor colorWithRed:95/255.0 green:175/255.0 blue:80/255.0 alpha:1.0] CGColor];
    
    UIView *statusBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 20)];
    statusBarView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:statusBarView];
    
     api = [APIManager sharedManager];
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

- (IBAction)loginBtn:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)submitBtn:(id)sender {
    [self resetPassword:text];
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
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
    
    return YES;
}


-(void)resetPassword:(NSString*)getEmailId{
    
    if([self notEmptyChecking] == NO){return;}
    if([self validityChecking:_txtEmail] == NO){return;}
    
//    if ([Utils isEmailAddress:_txtEmail.text]) {
//        
//        return;
//    }
    
    [SVProgressHUD show];
    
//    NSString *deviceToken = [Userdefaults objectForKey:@"deviceToken"];
    
//    NSDictionary *params = @{@"email":self.txtEmail.text};
//
//    NSLog(@"params==%@",params);
    
    NSString *userUpdate = [NSString stringWithFormat:@"email=%@",[NSString stringWithFormat:@"%@", self.txtEmail.text]];
    NSLog(@"params==%@",userUpdate);
    
    NSData *data = [userUpdate dataUsingEncoding:NSUTF8StringEncoding];
    
//    [api ApiRequestPOSTwithParameters:params WithUrlLastPart:@"retrivepassword.php" completion:^(NSDictionary * dict, NSError *error) {
    
    [api ApiRequestPOSTwithPostdata:data WithUrlLastPart:@"retrivepassword.php" completion:^(NSDictionary * dict, NSError *error) {
        
        
        NSLog(@"%@",dict);
        
        NSLog(@"%@",error);
        
        if (!error) {
            
            NSString *successStr = [dict objectForKey:@"status"];
            
            if ([successStr isEqualToString:@"success"]) {
                
                NSString *messageStr = [dict objectForKey:@"message"];
                
                NSLog(@"%@",messageStr);
                
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:messageStr
                                                                    message:nil
                                                                   delegate:nil
                                                          cancelButtonTitle:@"Ok"
                                                          otherButtonTitles:nil];

                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [alertView show];
                    
                    [self.navigationController popViewControllerAnimated:YES];
                    
                });
                
//////////////////////////////////////////////////////////////////////////////////////
                
//                LoginViewController *loginViewControllerScreen = [[LoginViewController alloc]initWithNibName:@"LoginViewController" bundle:nil];
//                [self.navigationController pushViewController:loginViewControllerScreen animated:YES];
                
                
//////////////////////////////////////////////////////////////////////////////////
   
//                UIAlertController * alert=   [UIAlertController
//                                              alertControllerWithTitle:@"Info"
//                                              message:messageStr
//                                              preferredStyle:UIAlertControllerStyleAlert];
//                
//                UIAlertAction* ok = [UIAlertAction
//                                     actionWithTitle:@"OK"
//                                     style:UIAlertActionStyleDefault
//                                     handler:^(UIAlertAction * action)
//                                     {
//                                         [alert dismissViewControllerAnimated:YES completion:nil];
//                                         [self.navigationController popViewControllerAnimated:YES];
//                                         
//                                     }];
//                
//                [alert addAction:ok];
//                
//                [self presentViewController:alert animated:YES completion:nil];
                
                
                [SVProgressHUD dismiss];


//                if ([productCategory count]>0) {
//                    
//                    NSDictionary *ProfDict = [productCategory objectAtIndex:0];
//                    
//                    [Userdefaults setObject:ProfDict forKey:@"ProfInfo"];
//                    [Userdefaults setBool:YES forKey:@"isLogin"];
//                    
//                    [Userdefaults synchronize];
//                    
//                    
//                    ProductCategoryViewController *productViewScreen = [[ProductCategoryViewController alloc]initWithNibName:@"ProductCategoryViewController" bundle:nil];
//                    
//                    
//                    menu = [[MenuTableViewController alloc] init];
//                    drawer = [[KYDrawerController alloc] init];
//                    
//                    localNavigationController = [[UINavigationController alloc] initWithRootViewController:productViewScreen];
//                    
//                    drawer.mainViewController = localNavigationController;
//                    
//                    drawer.drawerViewController = menu;
//                    
//                    /* Customize */
//                    drawer.drawerDirection = KYDrawerControllerDrawerDirectionLeft;
//                    drawer.drawerWidth = 5*(SCREENWIDTH/8);
//                    
//                    [UIApplication sharedApplication].keyWindow.rootViewController = drawer;
//                    
//                    
//                }
                
            }
            else{
                
//                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"There have some problem with email, try again later."
//                                                                    message:nil
//                                                                   delegate:nil
//                                                          cancelButtonTitle:@"Ok"
//                                                          otherButtonTitles:nil];
//                [alertView show];
                
                UIAlertController * alert=   [UIAlertController
                                              alertControllerWithTitle:@"There have some problem with email, try again later."
                                              message:nil
                                              preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction* ok = [UIAlertAction
                                     actionWithTitle:@"OK"
                                     style:UIAlertActionStyleDefault
                                     handler:^(UIAlertAction * action)
                                     {
                                         [alert dismissViewControllerAnimated:YES completion:nil];
                                         
                                     }];
                
                [alert addAction:ok];
                
                [self presentViewController:alert animated:YES completion:nil];
                
                [SVProgressHUD dismiss];
                
            }
            
        } else {
            
            [SVProgressHUD dismiss];
            NSLog(@"Error: %@", error);
            
//            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"There have some problem with email, try again later."
//                                                                message:nil
//                                                               delegate:nil
//                                                      cancelButtonTitle:@"Ok"
//                                                      otherButtonTitles:nil];
//            [alertView show];
            
            UIAlertController * alert=   [UIAlertController
                                          alertControllerWithTitle:@"There have some problem with email, try again later."
                                          message:nil
                                          preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* ok = [UIAlertAction
                                 actionWithTitle:@"OK"
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action)
                                 {
                                     [alert dismissViewControllerAnimated:YES completion:nil];
                                     
                                     dispatch_async(dispatch_get_main_queue(), ^{
                                         
                                         ProductCategoryViewController *productCategoryScreen = [[ProductCategoryViewController alloc]initWithNibName:@"ProductCategoryViewController" bundle:nil];
                                         [self.navigationController pushViewController:productCategoryScreen animated:YES];
                                         
                                     });
                                     
                                 }];
            
            [alert addAction:ok];
            
            [self presentViewController:alert animated:YES completion:nil];
        }
        
    }];
    
}


@end

//
//  SignUpViewController.m
//  Jing
//
//  Created by fnspl3 on 08/09/17.
//  Copyright © 2017 fnspl3. All rights reserved.
//

#import "SignUpViewController.h"
#import "ProductCategoryViewController.h"

@interface SignUpViewController (){
    NSArray *productCategory;

}

@end

@implementation SignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    UIView *statusBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 20)];
    statusBarView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:statusBarView];
    
    api = [APIManager sharedManager];
    
    _userDetailsView.layer.cornerRadius = 5.0f;
    _userDetailsView.clipsToBounds = YES;
    _loginView.layer.cornerRadius = 20.0f;
    _loginView.clipsToBounds = YES;
    _loginView.layer.borderWidth = 2.0f;
//    _loginView.layer.borderColor = (__bridge CGColorRef _Nullable)([UIColor lightGrayColor]);
    _loginView.layer.borderColor=[UIColor lightGrayColor].CGColor;
    
    _signupView.layer.cornerRadius = 20.0f;
    _signupView.clipsToBounds = YES;
    _signupView.layer.borderWidth = 2.0f;
//    _signupView.layer.borderColor = (__bridge CGColorRef _Nullable)([UIColor greenColor]);
//    _signupView.layer.borderColor=[[UIColor colorWithRed:95/255.0 green:175/255.0 blue:80/255.0 alpha:1.0] CGColor];
    _signupView.layer.borderColor=[[UIColor colorWithRed:80/255.0 green:187/255.0 blue:232/255.0 alpha:1.0] CGColor];


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
- (IBAction)signUpBtn:(id)sender {
    
    [self signUp];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
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
-(BOOL) validityChecking{
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
    
//    if(![_txtFieldPassword.text isEqualToString:_txtFieldConfirmPassword.text]){
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Password text must match."
//                                                            message:nil
//                                                           delegate:nil
//                                                  cancelButtonTitle:@"Ok"
//                                                  otherButtonTitles:nil];
//        [alertView show];
//        _txtFieldPassword.text = @"";
//        _txtFieldConfirmPassword.text = @"";
//        [_txtFieldPassword becomeFirstResponder];
//        return NO;
//    }
    
//    if(![_txtFieldEmail.text isEqualToString:_txtFieldConfirmEmail.text]){
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Email text must match."
//                                                            message:nil
//                                                           delegate:nil
//                                                  cancelButtonTitle:@"Ok"
//                                                  otherButtonTitles:nil];
//        [alertView show];
//        _txtFieldEmail.text = @"";
//        _txtFieldConfirmEmail.text = @"";
//        [_txtFieldEmail becomeFirstResponder];
//        return NO;
//    }
    
    return YES;
}

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
    if([_txtPhoneNumber.text isEqualToString:@""]){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Please provide a phone number."
                                                            message:nil
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
        [alertView show];
        [_txtPhoneNumber becomeFirstResponder];
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

    if([_txtFirstName.text isEqualToString:@""]){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Please provide the First Name."
                                                            message:nil
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
        [alertView show];
        [_txtFirstName becomeFirstResponder];
        return NO;
    }
        if([_txtLastName.text isEqualToString:@""]){
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Please provide the Last Name."
                                                                message:nil
                                                               delegate:nil
                                                      cancelButtonTitle:@"Ok"
                                                      otherButtonTitles:nil];
            [alertView show];
            [_txtLastName becomeFirstResponder];
            return NO;
        }
    
   
        if([_txtLocation.text isEqualToString:@""]){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Please provide the location."
                                                            message:nil
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
        [alertView show];
        [_txtLocation becomeFirstResponder];
        return NO;
    }
    if([_txtPincode.text isEqualToString:@""]){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Please provide the pincode."
                                                            message:nil
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
        [alertView show];
        [_txtPincode becomeFirstResponder];
        return NO;
    }
    
    return YES;
}


-(void)signUp{
    
    if([self notEmptyChecking] == NO){return;}
    if([self validityChecking] == NO){return;}
    
    [SVProgressHUD show];
    
    NSString *deviceToken = [Utils deviceToken];
    
//    NSDictionary *params = @{@"email":self.txtEmail.text,@"phone":self.txtPhoneNumber.text,@"password":self.txtPassword.text,@"fname":self.txtFirstName.text,@"lname":self.txtLastName.text,@"address":self.txtLocation.text,@"pincode":self.txtPincode.text,@"deviceId":deviceToken,@"dtype":@"iOS"};
//
//    NSLog(@"params==%@",params);
    
    NSString *userUpdate = [NSString stringWithFormat:@"email=%@&phone=%@&password=%@&fname=%@&lname=%@&address=%@&pincode=%@&deviceId=%@&dtype=ios",[NSString stringWithFormat:@"%@",self.txtEmail.text],[NSString stringWithFormat:@"%@",self.txtPhoneNumber.text],[NSString stringWithFormat:@"%@",self.txtPassword.text],[NSString stringWithFormat:@"%@",self.txtFirstName.text],[NSString stringWithFormat:@"%@",self.txtLastName.text],[NSString stringWithFormat:@"%@",self.txtLocation.text],[NSString stringWithFormat:@"%@",self.txtPincode.text],deviceToken];
    
    
//    NSString *userUpdate = [NSString stringWithFormat:@"email=%@&phone=%@&password=%@&fname=%@&lname=%@&address=%@&pincode=%@&deviceId=78141ce550d27d5c4e9f7fb6aba7d38c80bc1e641412881f03ad61ba1c9f6e14&dtype=ios",[NSString stringWithFormat:@"%@",self.txtEmail.text],[NSString stringWithFormat:@"%@",self.txtPhoneNumber.text],[NSString stringWithFormat:@"%@",self.txtPassword.text],[NSString stringWithFormat:@"%@",self.txtFirstName.text],[NSString stringWithFormat:@"%@",self.txtLastName.text],[NSString stringWithFormat:@"%@",self.txtLocation.text],[NSString stringWithFormat:@"%@",self.txtPincode.text]];
    
    NSLog(@"params==%@",userUpdate);
    //Convert the String to Data
    NSData *data = [userUpdate dataUsingEncoding:NSUTF8StringEncoding];
    
//    [api ApiRequestPOSTwithParameters:params WithUrlLastPart:@"register.php" completion:^(NSDictionary * dict, NSError *error) {
    [api ApiRequestPOSTwithPostdata:data WithUrlLastPart:@"register.php" completion:^(NSDictionary * dict, NSError *error) {
    
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
                    [Userdefaults setBool:YES forKey:@"isLogin"];
                    
                    [Userdefaults synchronize];
                    
                    [self gotoHome];
                    
                }
                
            }
            else{
                
//                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"There have some problem with Sign Up, try again later."
//                                                                    message:nil
//                                                                   delegate:nil
//                                                          cancelButtonTitle:@"Ok"
//                                                          otherButtonTitles:nil];
//                [alertView show];
                UIAlertController * alert=   [UIAlertController
                                              alertControllerWithTitle:@"There have some problem with Sign Up, try again later."
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
            
//            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"There have some problem with Sign up, try again later."
//                                                                message:nil
//                                                               delegate:nil
//                                                      cancelButtonTitle:@"Ok"
//                                                      otherButtonTitles:nil];
//            [alertView show];
            
            UIAlertController * alert=   [UIAlertController
                                          alertControllerWithTitle:@"There have some problem with Sign up, try again later."
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

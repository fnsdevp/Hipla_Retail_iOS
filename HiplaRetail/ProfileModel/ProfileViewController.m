//
//  ProfileViewController.m
//  Jing
//
//  Created by fnspl3 on 18/09/17.
//  Copyright © 2017 fnspl3. All rights reserved.
//

#import "ProfileViewController.h"
#import "YourCartViewController.h"
#import "ProductCategoryViewController.h"
#import "CartDetails.h"
#import "UIImageView+WebCache.h"


@interface ProfileViewController (){
    
    NSDictionary *ProfInfo;
    NSString *userId;
    NSString *address;
    NSString *email;
    NSString *fname;
    NSString *lname;
    NSString *phone;
    NSString *pincode;
    NSArray *productCategory;
    NSString *countStr;
    NSString *imgStr;

    
}

@end


@implementation ProfileViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    _userDetailsView.layer.cornerRadius = 5.0f;
    _userDetailsView.clipsToBounds = YES;
    _viewUpdate.layer.cornerRadius = 20.0f;
    _viewUpdate.clipsToBounds = YES;
    _viewUpdate.layer.borderWidth = 2.0f;
    _viewUpdate.layer.borderColor=[[UIColor colorWithRed:80/255.0 green:187/255.0 blue:232/255.0 alpha:1.0] CGColor];
    
    [self.navigationController.navigationBar setHidden:YES];
    
    ProfInfo = [Userdefaults objectForKey:@"ProfInfo"];
    userId = [NSString stringWithFormat:@"%@",[ProfInfo objectForKey:@"id"]];
    NSLog(@"USERID==%@",userId);
    address=[ProfInfo objectForKey:@"address"];
    email=[ProfInfo objectForKey:@"email"];
    fname=[ProfInfo objectForKey:@"fname"];
    lname=[ProfInfo objectForKey:@"lname"];
    phone=[ProfInfo objectForKey:@"phone"];
    pincode=[ProfInfo objectForKey:@"pincode"];
    
    
    self.imgProfilePic.layer.cornerRadius =  self.imgProfilePic.frame.size.height/2;
    self.imgProfilePic.layer.masksToBounds = YES;
     _viewCount.layer.cornerRadius= _viewCount.frame.size.height/2;
    
    _txtLocation.text=address;
    _txtEmail.text=email;
    _txtFirstName.text=fname;
    _txtLastName.text=lname;
    _txtPhoneNumber.text=phone;
    _txtPincode.text=pincode;
    [_indicatorView startAnimating];
    _imgProfilePic.image = nil;
    
    NSString *imgURL= [NSString stringWithFormat:@"http://cxc.gohipla.com/retail/%@",[ProfInfo objectForKey:@"image"]];
    imgURL = [imgURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    [manager downloadImageWithURL:[NSURL URLWithString:imgURL]
                          options:0
                         progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                             
                             // progression tracking code
                             NSLog(@"receivedSize %ld",(long)receivedSize);
                         }
                        completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                            
                            if (image) {
                                // do something with image
                                _imgProfilePic.image = image;
                                
                                [_indicatorView setHidden:YES];
                                [_indicatorView stopAnimating];
                                
                            }
                        }];
    
    [_imgProfilePic setContentMode:UIViewContentModeScaleAspectFit];

    
    
    api = [APIManager sharedManager];
    NSInteger curtItems = [[CartDetails sharedInstanceCartDetails] countCartItems];
    countStr = [NSString stringWithFormat:@"%ld",curtItems];
    //    countStr=[Userdefaults objectForKey:@"isCount"];
    _lblCount.text = countStr;
    
    if([_lblCount.text isEqualToString:@"0"]){
        _viewCount.hidden=YES;
    }
    else{
        _viewCount.hidden=NO;
        
    }
 
}


-(IBAction)selectPic:(UIButton *)sender
{
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"Set a picture" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
        // Cancel button tappped.
        [self dismissViewControllerAnimated:YES completion:^{
        }];
    }]];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Take photo" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        [self presentViewController:picker animated:YES completion:nil];
        
//        [self dismissViewControllerAnimated:YES completion:^{
//        }];
    }]];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Choose from library" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
        [self presentViewController:picker animated:YES completion:nil];
        
//        [self dismissViewControllerAnimated:YES completion:^{
//        }];
    }]];
    
    // Present action sheet.
    [self presentViewController:actionSheet animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    // output image
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    
    self.imgProfilePic.image = chosenImage;
   
    [picker dismissViewControllerAnimated:YES completion:nil];
    
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

- (IBAction)addToCart:(id)sender {
    
    if([_lblCount.text isEqualToString:@"0"]){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"No product added in your cart.Shop more to proceed."
                                                            message:nil
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
        [alertView show];
    }
    else{
        YourCartViewController *cartViewScreen = [[YourCartViewController alloc]initWithNibName:@"YourCartViewController" bundle:nil];
        [self.navigationController pushViewController:cartViewScreen animated:YES];
    }
    
   
}

- (IBAction)btnUpdate:(id)sender {
    
    [self update];
}

- (IBAction)btnJing:(id)sender {
    
    BOOL isHasProductCat = NO;
    NSArray* arrViewControllers = self.navigationController.viewControllers;
    for (id viewController in arrViewControllers) {
        if ([viewController isKindOfClass:[ProductCategoryViewController class]]) {
            
            isHasProductCat = YES;
            ProductCategoryViewController* prdCatVC = (ProductCategoryViewController *)viewController;
            [self.navigationController popToViewController:prdCatVC animated:YES];
            break;
        }
        
    }
    
    if (!isHasProductCat) {
        
        ProductCategoryViewController *productCategoryViewControllerScreen = [[ProductCategoryViewController alloc]initWithNibName:@"ProductCategoryViewController" bundle:nil];
        [self.navigationController pushViewController:productCategoryViewControllerScreen animated:YES];
        
    } else {
        
    }
    
//    ProductCategoryViewController *ProductCategoryScreen = [[ProductCategoryViewController alloc]initWithNibName:@"ProductCategoryViewController" bundle:nil];
//    [self.navigationController pushViewController:ProductCategoryScreen animated:YES];
}

- (IBAction)clickedOpen:(id)sender {
    
    KYDrawerController *elDrawer = (KYDrawerController*)self.navigationController.parentViewController;
    
    [elDrawer setDrawerState:KYDrawerControllerDrawerStateOpened animated:YES];
    
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
    BOOL validEmail = [self NSStringIsValidEmail:_txtEmail.text];
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
//    if([_txtPassword.text isEqualToString:@""]){
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Password can't be empty."
//                                                            message:nil
//                                                           delegate:nil
//                                                  cancelButtonTitle:@"Ok"
//                                                  otherButtonTitles:nil];
//        [alertView show];
//        [_txtPassword becomeFirstResponder];
//        return NO;
//    }
    
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

-(void)update{
    if(self.imgProfilePic != nil){
    imgStr = [self imageToNSString:self.imgProfilePic.image];
    }
    
    if([self notEmptyChecking] == NO){return;}
    if([self validityChecking] == NO){return;}
    
    [SVProgressHUD show];
    
    NSString *deviceToken = [Utils deviceToken];
    
    //    NSDictionary *params = @{@"email":self.txtEmail.text,@"phone":self.txtPhoneNumber.text,@"password":self.txtPassword.text,@"fname":self.txtFirstName.text,@"lname":self.txtLastName.text,@"address":self.txtLocation.text,@"pincode":self.txtPincode.text,@"deviceId":deviceToken,@"dtype":@"iOS"};
    //
    //    NSLog(@"params==%@",params);
    
    NSString *userUpdate = [NSString stringWithFormat:@"email=%@&phone=%@&firstname=%@&lastname=%@&address=%@&pincode=%@&userid=%@&image=%@",[NSString stringWithFormat:@"%@",self.txtEmail.text],[NSString stringWithFormat:@"%@",self.txtPhoneNumber.text],[NSString stringWithFormat:@"%@",self.txtFirstName.text],[NSString stringWithFormat:@"%@",self.txtLastName.text],[NSString stringWithFormat:@"%@",self.txtLocation.text],[NSString stringWithFormat:@"%@",self.txtPincode.text],userId,imgStr];
    
    
    //    NSString *userUpdate = [NSString stringWithFormat:@"email=%@&phone=%@&password=%@&fname=%@&lname=%@&address=%@&pincode=%@&deviceId=78141ce550d27d5c4e9f7fb6aba7d38c80bc1e641412881f03ad61ba1c9f6e14&dtype=ios",[NSString stringWithFormat:@"%@",self.txtEmail.text],[NSString stringWithFormat:@"%@",self.txtPhoneNumber.text],[NSString stringWithFormat:@"%@",self.txtPassword.text],[NSString stringWithFormat:@"%@",self.txtFirstName.text],[NSString stringWithFormat:@"%@",self.txtLastName.text],[NSString stringWithFormat:@"%@",self.txtLocation.text],[NSString stringWithFormat:@"%@",self.txtPincode.text]];
    
    
    NSLog(@"params==%@",userUpdate);
    //Convert the String to Data
    NSData *data = [userUpdate dataUsingEncoding:NSUTF8StringEncoding];
    
    //    [api ApiRequestPOSTwithParameters:params WithUrlLastPart:@"register.php" completion:^(NSDictionary * dict, NSError *error) {
    
    [api ApiRequestPOSTwithPostdata:data WithUrlLastPart:@"edituser.php" completion:^(NSDictionary * dict, NSError *error) {
        
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
//                    [Userdefaults setBool:YES forKey:@"isLogin"];
                    
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
-(NSString *)imageToNSString:(UIImage *)image
{
    NSData *imageData = UIImagePNGRepresentation(image);
    return [imageData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
}
@end

//
//  MenuTableViewController.m
//  Jing
//
//  Created by FNSPL on 14/09/17.
//  Copyright © 2017 fnspl3. All rights reserved.
//

#import "MenuTableViewController.h"
#import "ProductCategoryViewController.h"
#import "KYDrawerController.h"
#import "MenuTableViewCell.h"
#import "ProfileViewController.h"
#import "SubCategoryViewController.h"
#import "OrderHistoryViewController.h"
#import "LoginViewController.h"
#import "UIImageView+WebCache.h"
#import "ProductbycatViewController.h"
#import "ProductbycatbyuserpreferenceViewController.h"
#import "FavouriteViewController.h"

@interface MenuTableViewController (){
    
    NSDictionary *ProfInfo;
    
    NSMutableArray *catbyuserPreferenceInfo;
    NSDictionary *catbyuserPreferenceDict;
    NSString *userId;
    
    NSMutableArray *productbyCatlistInfo;
    NSDictionary *productbyCatlistfoDict;
    
    NSMutableArray *productbycatbyuserpreferenceproductbyCatlistInfo;
    NSDictionary *productbycatbyuserpreferenceproductbyCatlistDict;
    
    NSMutableArray *favouritelistInfo;
    NSDictionary *favouritelistDict;

}

@end


@implementation MenuTableViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    api = [APIManager sharedManager];
    
    [self.navigationController.navigationBar setHidden:YES];
    _imgView.layer.cornerRadius=_imgView.frame.size.height /2;
    _imgView.layer.masksToBounds = YES;
    _browseListArray = [[NSArray alloc]initWithObjects:@"BABY",@"BAKING",@"BREAKFAST",@"DRINK",@"HEALTH",@"FRUIT",@"VEGETABLES",nil];
    _browseimageArray = [[NSArray alloc]initWithObjects:@"avocado.png",@"avocado.png",@"avocado.png",nil];
    _forUArray = [[NSArray alloc]initWithObjects:@"RECOMMENDED CARD",@"FAVOURITES",nil];
    _forUimageArray = [[NSArray alloc]initWithObjects:@"avocado.png",@"avocado.png",nil];
    

    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receivePopNotification:)
                                                 name:@"PopVC"
                                               object:nil];
    
    ProfInfo = [Userdefaults objectForKey:@"ProfInfo"];
    userId = [NSString stringWithFormat:@"%@",[ProfInfo objectForKey:@"id"]];
    
   // NSLog(@"%@",[ProfInfo objectForKey:@"fname"]);
    
    _lblName.text=[NSString stringWithFormat:@"%@ %@",[ProfInfo objectForKey:@"fname"],[ProfInfo objectForKey:@"lname"]];
    
//    [_indicatorView startAnimating];
    
    _imgView.image = nil;
    
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
                                _imgView.image = image;
                                
//                                [_indicatorView setHidden:YES];
//                                [_indicatorView stopAnimating];
                                
                            }
                        }];
    
    [_imgView setContentMode:UIViewContentModeScaleAspectFit];

   
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self catbyuserPreference];
    
    
//    [[NSNotificationCenter defaultCenter]
//     postNotificationName:@"navigineSetup"
//     object:self];
}

-(void)receivePopNotification:(NSNotification *)notification{
    
    if ([notification.name isEqualToString:@"PopVC"]) {
        {
            KYDrawerController *elDrawer = (KYDrawerController*)self.navigationController.parentViewController;
            
            [elDrawer setDrawerState:KYDrawerControllerDrawerStateClosed animated:YES];
            
            
           // ProfileViewController *profileViewScreen = [[ProfileViewController alloc]initWithNibName:@"ProfileViewController" bundle:nil];
            
           // [self.navigationController pushViewController:profileViewScreen animated:YES];
            
        }
        
    }
}

- (IBAction)btnProfile:(UIButton *)sender {
    
    
    ProfileViewController *cartViewScreen = [[ProfileViewController alloc]initWithNibName:@"ProfileViewController" bundle:nil];
    //            [self.navigationController pushViewController:cartViewScreen animated:YES];
    [_elDrawer goToTargetViewController:cartViewScreen];
    

    
    
    [[NSNotificationCenter defaultCenter]
              postNotificationName:@"PopVC"
              object:self];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (section==0) {
        
        return 0;
        
    }
    else if (section==1) {
        
        return 2;
        
    }
    else if (section==2) {
        
        return [catbyuserPreferenceInfo count];
    }
    else if (section==3) {
        
        return 0;
        
    }
    else{
        return 0;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIndentifier = @"menuCellIdentifier";
    
    MenuTableViewCell *cell = (MenuTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    
    if(cell==nil){
        
//        cell = [[MenuTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
        
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"MenuTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
//    [cell.contentView setBackgroundColor:[UIColor blueColor]];
//    cell.lblTitle.text = @"menu";
    
     if (indexPath.section==1) {
    
    cell.imgName.image= [UIImage imageNamed:[_forUimageArray objectAtIndex:indexPath.row]];
    cell.lblImageName.text = [_forUArray objectAtIndex:indexPath.row];
         
    }
    
   else if (indexPath.section==2) {
        
        cell.imgName.image= [UIImage imageNamed:[_browseimageArray objectAtIndex:indexPath.row]];
//        cell.lblImageName.text = [_browseListArray objectAtIndex:indexPath.row];
       
       if ([catbyuserPreferenceInfo count]>0) {
           
           NSDictionary *dict = [catbyuserPreferenceInfo objectAtIndex:indexPath.row];
           
           cell.lblImageName.text = [NSString stringWithFormat:@"%@",[dict objectForKey:@"category_name"]];
           
//           cell.imgProductCatView.image = nil;
           
//           NSString *imgURL= [NSString stringWithFormat:@"%@",[dict objectForKey:@"thumb"]];
//           imgURL = [imgURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//           SDWebImageManager *manager = [SDWebImageManager sharedManager];
//           [manager downloadImageWithURL:[NSURL URLWithString:imgURL]
//                                 options:0
//                                progress:^(NSInteger receivedSize, NSInteger expectedSize) {
//
//                                    // progression tracking code
//                                    NSLog(@"receivedSize %ld",(long)receivedSize);
//                                }
//                               completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
//
//                                   if (image) {
//                                       // do something with image
//                                       cell.imgProductCatView.image = image;
//
//                                       //                                [cell.indicatorView setHidden:YES];
//                                       //                                [cell.indicatorView stopAnimating];
//
//
//                                   }
//                               }];
//
//           [cell.imgProductCatView setContentMode:UIViewContentModeScaleAspectFill];
           
       }
    }
    
   else{
       
       return  0;
   }
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section==0) {
        
        return 30;
    }
    else if (section==1) {
        
        return 30;
    }

    else if (section==2) {
        
        return 30;
    }

    else if (section==3) {
        
        return 30;
    }
    else{
        return 0;
    }


}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *view0 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tblMenu.frame.size.width, _tblMenu.sectionHeaderHeight)];
    
//    view0.backgroundColor = [UIColor colorWithRed:86/255.0 green:160/255.0 blue:73/255.0 alpha:1.0];
    view0.backgroundColor = [UIColor whiteColor];
    
    UILabel *lblHeader = [[UILabel alloc] initWithFrame:CGRectMake(20, 6, self.tblMenu.frame.size.width, 20)];
    
    lblHeader.font = [UIFont boldSystemFontOfSize:18.0];
    
    lblHeader.textAlignment = NSTextAlignmentLeft;
    
    if (section == 0) {
        lblHeader.font =[UIFont fontWithName:@"HelveticaNeue-Medium" size:17];
        
        lblHeader.text = @"ORDER HISTORY";
        
        lblHeader.textColor = [UIColor darkGrayColor];
        [view0 addSubview:lblHeader];
        
        UIButton *btnHeader = [[UIButton alloc] initWithFrame:CGRectMake(20, 6, self.tblMenu.frame.size.width, 20)];
        [view0 addSubview:btnHeader];
        [btnHeader addTarget:self action:@selector(btnOrderHistory:) forControlEvents:UIControlEventTouchUpInside];
        
        return view0;
        
    }else if (section == 1){
        lblHeader.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:17];
        
        lblHeader.text = @"FOR YOU";
        
        lblHeader.textColor = [UIColor darkGrayColor];
        [view0 addSubview:lblHeader];
        
        return view0;
    }
    else if (section == 2){
        lblHeader.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:17];
        
        lblHeader.text = @"BROWSE";
        
        lblHeader.textColor = [UIColor darkGrayColor];
        [view0 addSubview:lblHeader];
        
        return view0;
    }
    else if (section == 3){
        lblHeader.font = [UIFont fontWithName:@"Helvetica-Bold" size:17];
        
        lblHeader.text = @"LOGOUT";
        
        lblHeader.textColor = [UIColor darkGrayColor];
        [view0 addSubview:lblHeader];
        
        UIButton *btnLogoutOutlet = [[UIButton alloc] initWithFrame:CGRectMake(20, 6, self.tblMenu.frame.size.width, 20)];
        
        [view0 addSubview:btnLogoutOutlet];
        
        [btnLogoutOutlet addTarget:self action:@selector(btnLogOut:) forControlEvents:UIControlEventTouchUpInside];
        
        return view0;
    }
    else{
        
        return nil;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)newIndexPath{
    
    [tableView deselectRowAtIndexPath:newIndexPath animated:YES];
    
//    KYDrawerController *elDrawer = (KYDrawerController*)self.navigationController.parentViewController;
    
//    ProductCategoryViewController *viewController = [[ProductCategoryViewController alloc]initWithNibName:@"ProductCategoryViewController" bundle:nil];
    
//    SubCategoryViewController *cartViewScreen = [[SubCategoryViewController alloc]initWithNibName:@"SubCategoryViewController" bundle:nil];
//    [_elDrawer goToTargetViewController:cartViewScreen];
    
//    UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:viewController];
    
    if(newIndexPath.section == 1){
      
    switch ([newIndexPath row]) {
            
        case 0:{
            
              [self productbycatbyuserpreference];
//            SubCategoryViewController *cartViewScreen = [[SubCategoryViewController alloc]initWithNibName:@"SubCategoryViewController" bundle:nil];
////            [self.navigationController pushViewController:cartViewScreen animated:YES];
//            [_elDrawer goToTargetViewController:cartViewScreen];

            break;
            }
        case 1:{
            
            [self getFavouritebyUserList];
            
            break;
        }

        default:
            break;

    }

  }
    
    if(newIndexPath.section == 2){
        
        NSDictionary *dict = [catbyuserPreferenceInfo  objectAtIndex:newIndexPath.row];
        
        NSString *catIdStr = [NSString stringWithFormat:@"%@",[dict objectForKey:@"catid"]];
        
        [self getProductbyCategoryList:catIdStr];
        
//        switch ([newIndexPath row]) {
//            case 0:{
//
//                SubCategoryViewController *cartViewScreen = [[SubCategoryViewController alloc]initWithNibName:@"SubCategoryViewController" bundle:nil];
//                [_elDrawer goToTargetViewController:cartViewScreen];
////                [self.navigationController pushViewController:cartViewScreen animated:YES];
//
//                break;
//            }
//            case 1:{
//
//                SubCategoryViewController *cartViewScreen = [[SubCategoryViewController alloc]initWithNibName:@"SubCategoryViewController" bundle:nil];
//                [_elDrawer goToTargetViewController:cartViewScreen];
////                [self.navigationController pushViewController:cartViewScreen animated:YES];
//
//                break;
//            }
//
//            case 2:{
//
//                SubCategoryViewController *cartViewScreen = [[SubCategoryViewController alloc]initWithNibName:@"SubCategoryViewController" bundle:nil];
//                [_elDrawer goToTargetViewController:cartViewScreen];
////                [self.navigationController pushViewController:cartViewScreen animated:YES];
//
//                break;
//            }
//            case 3:{
//
//                SubCategoryViewController *cartViewScreen = [[SubCategoryViewController alloc]initWithNibName:@"SubCategoryViewController" bundle:nil];
//                [_elDrawer goToTargetViewController:cartViewScreen];
////                [self.navigationController pushViewController:cartViewScreen animated:YES];
//
//                break;
//            }
//            case 4:{
//
//                SubCategoryViewController *cartViewScreen = [[SubCategoryViewController alloc]initWithNibName:@"SubCategoryViewController" bundle:nil];
//                [_elDrawer goToTargetViewController:cartViewScreen];
////                [self.navigationController pushViewController:cartViewScreen animated:YES];
//
//                break;
//            }
//            case 5:{
//
//                SubCategoryViewController *cartViewScreen = [[SubCategoryViewController alloc]initWithNibName:@"SubCategoryViewController" bundle:nil];
//                [_elDrawer goToTargetViewController:cartViewScreen];
////                [self.navigationController pushViewController:cartViewScreen animated:YES];
//
//                break;
//            }
//            case 6:{
//
//                SubCategoryViewController *cartViewScreen = [[SubCategoryViewController alloc]initWithNibName:@"SubCategoryViewController" bundle:nil];
//                [_elDrawer goToTargetViewController:cartViewScreen];
////                [self.navigationController pushViewController:cartViewScreen animated:YES];
//
//                break;
//            }
//            case 7:{
//
//                SubCategoryViewController *cartViewScreen = [[SubCategoryViewController alloc]initWithNibName:@"SubCategoryViewController" bundle:nil];
//                [_elDrawer goToTargetViewController:cartViewScreen];
////                [self.navigationController pushViewController:cartViewScreen animated:YES];
//
//                break;
//            }
//            default:
//
//                break;
//
//
//        }
    }
//    _elDrawer.mainViewController = navController;
    
//    [_elDrawer setDrawerState:KYDrawerControllerDrawerStateClosed animated:YES];
}


/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

/*
 #pragma mark - Table view delegate
 
 // In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
 - (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
 // Navigation logic may go here, for example:
 // Create the next view controller.
 <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:<#@"Nib name"#> bundle:nil];
 
 // Pass the selected object to the new view controller.
 
 // Push the view controller.
 [self.navigationController pushViewController:detailViewController animated:YES];
 }
 */

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (void)btnOrderHistory:(id)sender{
    
    NSLog(@"ClickOrderHistory");
    OrderHistoryViewController *orderHistoryScreen = [[OrderHistoryViewController alloc]initWithNibName:@"OrderHistoryViewController" bundle:nil];
    //            [self.navigationController pushViewController:cartViewScreen animated:YES];
    [_elDrawer goToTargetViewController:orderHistoryScreen];
}

- (void)btnLogOut:(id)sender{
    
    [Userdefaults removeObjectForKey:@"ProfInfo"];
    [Userdefaults removeObjectForKey:@"isLoggedIn"];
    NSLog(@"ClickOrderHistory");
    LoginViewController *orderHistoryScreen = [[LoginViewController alloc]initWithNibName:@"LoginViewController" bundle:nil];
    //            [self.navigationController pushViewController:cartViewScreen animated:YES];
    [_elDrawer goToTargetViewController:orderHistoryScreen];
}

//////////////////////////////////////////////////////////////////////////////////////////////
//For table menu
-(void)catbyuserPreference
{
    [SVProgressHUD show];
    
  NSString *userUpdate = [NSString stringWithFormat:@"user_id=%@",userId];
    
    //Convert the String to Data
    NSData *data = [userUpdate dataUsingEncoding:NSUTF8StringEncoding];
    
    //    [api ApiRequestPOSTwithParameters:params WithUrlLastPart:@"login.php" completion:^(NSDictionary * dict, NSError *error) {
    
    [api ApiRequestPOSTwithPostdata:data WithUrlLastPart:@"catbyuserpreference.php" completion:^(NSDictionary * dict, NSError *error) {
        [SVProgressHUD dismiss];
        
        NSLog(@"%@",dict);
        
        NSLog(@"%@",error);
        
        if (!error) {
            
            NSString *successStr = [dict objectForKey:@"status"];
            
            if ([successStr isEqualToString:@"success"]) {
                
                NSString *strCatlist = [dict objectForKey:@"catlist"];
                
                if (![[Utils sharedInstance] isNullString:strCatlist])
                {
                    catbyuserPreferenceInfo = [dict objectForKey:@"catlist"];
                    
                    if ([catbyuserPreferenceInfo count]>0) {
                        
                        catbyuserPreferenceDict = (NSDictionary *)[catbyuserPreferenceInfo objectAtIndex:0];
                        
                        //                    NSDictionary *dict = [ProfDict dictionaryByReplacingNullsWithBlanks];
                        //                    NSLog(@"DICT=====%@",dict);
                        //
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            [_tblMenu reloadData];
                            
                            //                        YourCartViewController *YourCartViewScreen = [[YourCartViewController alloc]initWithNibName:@"YourCartViewController" bundle:nil];
                            //
                            //                        YourCartViewScreen.ProductInfo = cartDetails.addToCartItems;
                            //                        //
                            //
                            //                        [self.navigationController pushViewController:YourCartViewScreen animated:YES];
                        });
                        //
                        //                    //                }
                        
                    }
                }
                else {
                    
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"No browse data are found."
                                                                        message:nil
                                                                       delegate:nil
                                                              cancelButtonTitle:@"Ok"
                                                              otherButtonTitles:nil];
                    [alertView show];
                    [SVProgressHUD dismiss];
                    
                    
                }
                
            } else {
                
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
///////////////////////////////////////////////////////////////////////////////////////////////////////////
-(void)getProductbyCategoryList:(NSString *)catId
{
    [SVProgressHUD show];
    
    NSString *userUpdate = [NSString stringWithFormat:@"cat=%@",catId];
    
    //Convert the String to Data
    NSData *data = [userUpdate dataUsingEncoding:NSUTF8StringEncoding];
    
    [api ApiRequestPOSTwithPostdata:data WithUrlLastPart:@"productbycat.php" completion:^(NSDictionary * dict, NSError *error) {
        
        [SVProgressHUD dismiss];
        
        NSLog(@"%@",dict);
        
        NSLog(@"%@",error);
        
        if (!error) {
            
            NSString *successStr = [dict objectForKey:@"status"];
            
            if ([successStr isEqualToString:@"success"]) {
                
                productbyCatlistInfo = [dict objectForKey:@"productlist"];
                
                if ([productbyCatlistInfo count]>0) {
                    
                    productbyCatlistfoDict = (NSDictionary *)[productbyCatlistInfo objectAtIndex:0];
                    
                    
                    //                    NSDictionary *dict = [ProfDict dictionaryByReplacingNullsWithBlanks];
                    //                    NSLog(@"DICT=====%@",dict);
                    //
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        [Userdefaults setObject:@"true" forKey:@"isMenu"];
                        
                        [Userdefaults synchronize];
                        
                        ProductbycatViewController *productbycatScreen = [[ProductbycatViewController alloc]initWithNibName:@"ProductbycatViewController" bundle:nil];
                        productbycatScreen.productbyCatlistInfo = productbyCatlistInfo;
//                        [self.navigationController pushViewController:productbycatScreen animated:YES];
                        [_elDrawer goToTargetViewController:productbycatScreen];
                        
                        
                    });
                    //
                    //                    //                }
                    
                }
                else{
                    
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"There have some problem with login, try again later."
                                                                        message:nil
                                                                       delegate:nil
                                                              cancelButtonTitle:@"Ok"
                                                              otherButtonTitles:nil];
                    [alertView show];
                    [SVProgressHUD dismiss];
                    
                    
                }
                
            } else {
                
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
///////////////////////////////////////////////////////////////////////////
-(void)productbycatbyuserpreference
{
    [SVProgressHUD show];
    
    NSString *userUpdate = [NSString stringWithFormat:@"user_id=%@",userId];
    
    //Convert the String to Data
    NSData *data = [userUpdate dataUsingEncoding:NSUTF8StringEncoding];
    
    [api ApiRequestPOSTwithPostdata:data WithUrlLastPart:@"productbycatbyuserpreference.php" completion:^(NSDictionary * dict, NSError *error) {
        
        [SVProgressHUD dismiss];
        
        NSLog(@"%@",dict);
        
        NSLog(@"%@",error);
        
        if (!error) {
            
            NSString *successStr = [dict objectForKey:@"status"];
            
            if ([successStr isEqualToString:@"success"]) {
                
                productbycatbyuserpreferenceproductbyCatlistInfo = [dict objectForKey:@"productlist"];
                
                if ([productbycatbyuserpreferenceproductbyCatlistInfo count]>0) {
                    
                    productbycatbyuserpreferenceproductbyCatlistDict = (NSDictionary *)[productbycatbyuserpreferenceproductbyCatlistInfo objectAtIndex:0];
                    
                    
                    //                    NSDictionary *dict = [ProfDict dictionaryByReplacingNullsWithBlanks];
                    //                    NSLog(@"DICT=====%@",dict);
                    //
                    
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [Userdefaults setObject:@"true" forKey:@"isMenu"];
            
            [Userdefaults synchronize];
                        
    ProductbycatbyuserpreferenceViewController *ProductbycatbyuserpreferenceViewScreen = [[ProductbycatbyuserpreferenceViewController alloc]initWithNibName:@"ProductbycatbyuserpreferenceViewController" bundle:nil];

      ProductbycatbyuserpreferenceViewScreen.productbycatbyuserpreferenceproductbyCatlistInfo = productbycatbyuserpreferenceproductbyCatlistInfo;

//    [self.navigationController pushViewController:ProductbycatbyuserpreferenceViewScreen animated:YES];
    [_elDrawer goToTargetViewController:ProductbycatbyuserpreferenceViewScreen];
            
                        
                    });
                    //
                    //                    //                }
                    
                }
                else{
                    
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"There have some problem with login, try again later."
                                                                        message:nil
                                                                       delegate:nil
                                                              cancelButtonTitle:@"Ok"
                                                              otherButtonTitles:nil];
                    [alertView show];
                    [SVProgressHUD dismiss];
                    
                    
                }
                
            } else {
                
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
/////////////////////////////////////////////////////////////////////////////////////////////////////////////
-(void)getFavouritebyUserList
{
    [SVProgressHUD show];
    
    NSString *userUpdate = [NSString stringWithFormat:@"user_id=%@",userId];
    
    //Convert the String to Data
    NSData *data = [userUpdate dataUsingEncoding:NSUTF8StringEncoding];
    
    [api ApiRequestPOSTwithPostdata:data WithUrlLastPart:@"favouritebyuser.php" completion:^(NSDictionary * dict, NSError *error) {
        
        [SVProgressHUD dismiss];
        
        NSLog(@"%@",dict);
        
        NSLog(@"%@",error);
        
        if (!error) {
            
            NSString *successStr = [dict objectForKey:@"status"];
            
            if ([successStr isEqualToString:@"success"]) {
                
                favouritelistInfo = [dict objectForKey:@"productlist"];
                
                if ([favouritelistInfo count]>0) {
                    
                    favouritelistDict = (NSDictionary *)[favouritelistInfo objectAtIndex:0];
                    
                    //                    NSDictionary *dict = [ProfDict dictionaryByReplacingNullsWithBlanks];
                    //                    NSLog(@"DICT=====%@",dict);
                    //
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        [Userdefaults setObject:@"true" forKey:@"isMenu"];
                        
                        [Userdefaults synchronize];
                        
                        FavouriteViewController *favouriteScreen = [[FavouriteViewController alloc]initWithNibName:@"FavouriteViewController" bundle:nil];
                        favouriteScreen.favoriteProductlistInfo = favouritelistInfo;
                        //                        [self.navigationController pushViewController:productbycatScreen animated:YES];
                        [_elDrawer goToTargetViewController:favouriteScreen];
                        
                    });
                    //
                    //                    //                }
                    
                }
                else{
                    
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"There have some problem with login, try again later."
                                                                        message:nil
                                                                       delegate:nil
                                                              cancelButtonTitle:@"Ok"
                                                              otherButtonTitles:nil];
                    [alertView show];
                    [SVProgressHUD dismiss];
                    
                    
                }
                
            } else {
                
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

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

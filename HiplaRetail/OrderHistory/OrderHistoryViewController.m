//
//  OrderHistoryViewController.m
//  Jing
//
//  Created by fnspl3 on 22/11/17.
//  Copyright © 2017 fnspl3. All rights reserved.
//

#import "OrderHistoryViewController.h"
#import "OrderHistoryTableViewCell.h"
#import "YourCartViewController.h"
#import "ProductCategoryViewController.h"
#import "QRViewController.h"
#import "CartDetails.h"

@interface OrderHistoryViewController (){
    
    NSDictionary *ProfInfo;
    NSString *userId;
    NSMutableArray *orderhistoryDetailslistInfo;
    NSMutableArray *orderhistoryDetailsArr;
    NSDictionary *orderhistoryDetailslistfoDict;
    NSString *orderUniqueIdStr;
    NSString *orderhistoryIdStr;
    NSString *qrStr;
    NSString *countStr;
}

@end

@implementation OrderHistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
     _viewCount.layer.cornerRadius= _viewCount.frame.size.height/2;
    api = [APIManager sharedManager];
    ProfInfo = [Userdefaults objectForKey:@"ProfInfo"];
    userId = [NSString stringWithFormat:@"%@",[ProfInfo objectForKey:@"id"]];
    NSLog(@"USERID==%@",userId);
    [self.navigationController.navigationBar setHidden:YES];
    [self getOrderHistoryDetails];
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


- (UIImage *)createQRForString:(NSString *)imagename {
    
    // Generation of QR code image
    NSData *qrCodeData = [imagename dataUsingEncoding:NSISOLatin1StringEncoding]; // recommended encoding
    CIFilter *qrCodeFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [qrCodeFilter setValue:qrCodeData forKey:@"inputMessage"];
    [qrCodeFilter setValue:@"M" forKey:@"inputCorrectionLevel"]; //default of L,M,Q & H modes
    
    CIImage *qrCodeImage = qrCodeFilter.outputImage;
    
    CGRect imageSize = CGRectIntegral(qrCodeImage.extent); // generated image size
    CGSize outputSize = CGSizeMake(240.0, 240.0); // required image size
    CIImage *imageByTransform = [qrCodeImage imageByApplyingTransform:CGAffineTransformMakeScale(outputSize.width/CGRectGetWidth(imageSize), outputSize.height/CGRectGetHeight(imageSize))];
    
    UIImage *qrCodeImageByTransform = [UIImage imageWithCIImage:imageByTransform];
    
    return qrCodeImageByTransform;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
  
    return [orderhistoryDetailslistInfo count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *simpleTableIdentifier = @"OrderHistoryTableViewCell";
    
    OrderHistoryTableViewCell *cell = (OrderHistoryTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"OrderHistoryTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    //    NSDictionary *dict = [[_productInfoDict objectForKey:@"productlist"] objectAtIndex:indexPath.row];
    //    cell.lblName.text = [dict objectForKey:@"title"];
    
//    NSArray *arrayOfArrays = orderhistoryDetailslistInfo;
//    
//    NSSortDescriptor *sd = [NSSortDescriptor sortDescriptorWithKey: @"@lastObject" ascending: YES];
//    
//    NSArray *sorted = [arrayOfArrays sortedArrayUsingDescriptors: @[sd]];
//    
    
    if ([orderhistoryDetailslistInfo count]>0) {
        
        NSDictionary *dict = [orderhistoryDetailslistInfo objectAtIndex:indexPath.row];
        
        cell.lblOrderID.text=[NSString stringWithFormat:@"Order Id: %@",[dict objectForKey:@"order_unique_id"]];
        cell.lblRupees.text=[NSString stringWithFormat:@"Rs/-%@ ",[dict objectForKey:@"total_amount"]];
        cell.lblCount.text=[NSString stringWithFormat:@"%@",[dict objectForKey:@"total_quantity"]];
        cell.lblDate.text=[NSString stringWithFormat:@"Date: %@",[dict objectForKey:@"order_date"]];
        NSString *gatepassStr=[NSString stringWithFormat:@"%@",[dict objectForKey:@"gate_pass"]];
        if([gatepassStr isEqualToString:@"0"]){
            
            cell.lblOrderStatus.text=@"Pending";
            cell.lblOrderStatus.textColor=[UIColor redColor];
            
        }
       else if([gatepassStr isEqualToString:@"1"]){
            
            cell.lblOrderStatus.text=@"Approved";
            cell.lblOrderStatus.textColor=[UIColor greenColor];
        }
        qrStr = [NSString stringWithFormat:@"%@",[dict objectForKey:@"order_unique_id"]];
        
        cell.imgView.image = [self createQRForString:qrStr];
        
      }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 116;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *dict = [orderhistoryDetailslistInfo objectAtIndex:indexPath.row];
    orderhistoryIdStr = [NSString stringWithFormat:@"%@",[dict objectForKey:@"id"]];
    orderUniqueIdStr = [NSString stringWithFormat:@"%@",[dict objectForKey:@"order_unique_id"]];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
       // orderhistoryDetailslistfoDict = (NSDictionary *)[orderhistoryDetailslistInfo objectAtIndex:0];
        orderhistoryDetailsArr=[dict objectForKey:@"prod_list"];
        
        NSLog(@"orderhistoryIdStr=== %@",orderhistoryIdStr);
                            
        [self gotoHome];
                            
//                            ProductDetailsViewController *productbyDetailsScreen = [[ProductDetailsViewController alloc]initWithNibName:@"ProductDetailsViewController" bundle:nil];
//                            productbyDetailsScreen.productbyDetailslistInfo = productbyDetailslistInfo;
//                            [self.navigationController pushViewController:productbyDetailsScreen animated:YES];
    
     });
    
}
//- (CIImage *)createQRForString {
//    NSData *stringData = [qrStr dataUsingEncoding: NSISOLatin1StringEncoding];
//
//    CIFilter *qrFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
//    [qrFilter setValue:stringData forKey:@"inputMessage"];
//
//    return qrFilter.outputImage;
//}
-(void)getOrderHistoryDetails
{
    [SVProgressHUD show];
    
    NSString *userUpdate = [NSString stringWithFormat:@"user_id=%@",userId];
    
    //Convert the String to Data
    NSData *data = [userUpdate dataUsingEncoding:NSUTF8StringEncoding];
    
    [api ApiRequestPOSTwithPostdata:data WithUrlLastPart:@"ordhistorybyuser.php" completion:^(NSDictionary * dict, NSError *error) {
        
//        [SVProgressHUD dismiss];
        
        NSLog(@"%@",dict);
        
        NSLog(@"%@",error);
        
        if (!error) {
            
            NSString *successStr = [dict objectForKey:@"status"];
            
            if ([successStr isEqualToString:@"success"]) {
//                dispatch_async(dispatch_get_main_queue(), ^{

                orderhistoryDetailslistInfo = [dict objectForKey:@"order_list"];
                
                if ([orderhistoryDetailslistInfo count]>0) {
                    
//                    orderhistoryDetailslistfoDict = (NSDictionary *)[orderhistoryDetailslistInfo objectAtIndex:0];
                    
//                    orderhistoryDetailsArr=[orderhistoryDetailslistfoDict objectForKey:@"prod_list"];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                    
                      [self.tableViewOrderHistory reloadData];
                        
                    });
                    [SVProgressHUD dismiss];
                }
                else{
                    
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"There have some problem with order history, try again later."
                                                                        message:nil
                                                                       delegate:nil
                                                              cancelButtonTitle:@"Ok"
                                                              otherButtonTitles:nil];
                    [alertView show];
                    [SVProgressHUD dismiss];
                    
                    
                }
//               });
            } else {
                
                [SVProgressHUD dismiss];
                
                NSLog(@"Error: %@", error);
                
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"There have some problem with order history, try again later."
                                                                    message:nil
                                                                   delegate:nil
                                                          cancelButtonTitle:@"Ok"
                                                          otherButtonTitles:nil];
                [alertView show];
            }
        }
    }];
    
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

-(void)gotoHome
{
    QRViewController *qrViewScreen = [[QRViewController alloc]initWithNibName:@"QRViewController" bundle:nil];
    qrViewScreen.orderUniqueIdStr = orderUniqueIdStr;
    qrViewScreen.orderhistoryDetailsArr=orderhistoryDetailsArr;
    
    menu = [[MenuTableViewController alloc] init];
    drawer = [[KYDrawerController alloc] init];
    
    [menu setElDrawer:drawer];
    
    localNavigationController = [[UINavigationController alloc] initWithRootViewController:qrViewScreen];
    
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

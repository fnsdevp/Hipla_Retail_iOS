//
//  YourCartViewController.m
//  Jing
//
//  Created by fnspl3 on 11/09/17.
//  Copyright © 2017 fnspl3. All rights reserved.
//

#import "YourCartViewController.h"
#import "YourCartTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "YourCartTableViewCell.h"
#import "ProductCategoryViewController.h"
#import "CartDetails.h"
#import "QuickCheckOutViewController.h"
//#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

@interface YourCartViewController (){
    
    NSInteger number;
    NSInteger totalitem;
    NSInteger totalvalue;
    
    CartDetails* cartDetails;
//    int selectedTag;
    
    NSDictionary *ProfInfo;
    NSString *userId;
    NSString *address;
    NSString *phone;
    NSString *pincode;
    NSString *fname;
    NSString *currentDateStr;
    NSString *createOrderuniqueId;
    NSString *createOrderId;
    NSString *lblCountStr;

}

@end


@implementation YourCartViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    _continueView.layer.cornerRadius = 5.0f;
    _continueView.clipsToBounds = YES;
    
    _checkoutview.layer.cornerRadius = 5.0f;
    _checkoutview.clipsToBounds = YES;
    
    number = 0;
    
    api = [APIManager sharedManager];
    cartDetails = [CartDetails sharedInstanceCartDetails];
    ProfInfo = [Userdefaults objectForKey:@"ProfInfo"];
    userId = [NSString stringWithFormat:@"%@",[ProfInfo objectForKey:@"id"]];
    NSLog(@"USERID==%@",userId);
    address=[ProfInfo objectForKey:@"address"];
    phone=[ProfInfo objectForKey:@"phone"];
    pincode=[ProfInfo objectForKey:@"pincode"];
    fname=[ProfInfo objectForKey:@"fname"];
    
    NSDateFormatter *dt = [[NSDateFormatter alloc] init];
    
    NSDate *currentdate = [NSDate date];
    
    [dt setDateFormat:@"yyyy-MM-dd"];
    
    currentDateStr = [dt stringFromDate:currentdate];
    
    totalitem = 0;
    totalvalue = 0;
    
    _ProductInfo = [Userdefaults objectForKey:@"CartDetails"];
    
    if ([_ProductInfo count]>0) {
        
        /*for (int i=0; i<[_ProductInfo count]; i++) {
            
          NSDictionary *dict = [_ProductInfo objectAtIndex:i];
            
          number = (int)[[Userdefaults objectForKey:[NSString stringWithFormat:@"Product:%d",i]] integerValue];
          NSNumber *prdQn = [dict objectForKey:@"prdQuentity"];
          number = [prdQn integerValue];
            
            if (number==0) {
                
                number=1;
                
            }
//            [Userdefaults removeObjectForKey:[NSString stringWithFormat:@"Product:%d",i]];
           [Userdefaults setObject:[NSString stringWithFormat:@"%d",number] forKey:[NSString stringWithFormat:@"Product:%d",i]];
            
           [Userdefaults synchronize];
            
          NSString *Rupees = [NSString stringWithFormat:@"%@",[dict objectForKey:@"price"]];
//            [Userdefaults removeObjectForKey:[NSString stringWithFormat:@"Product:%d",i]];
            
          totalitem = number + totalitem;
          totalvalue = ((int)[Rupees integerValue]*number) + totalvalue;
            
        }*/
        
        totalitem = [cartDetails countCartItems];
        totalvalue = [cartDetails totalPrice];

        self.lblSubtotal.text = [NSString stringWithFormat:@"Subtotal :Rs %ld/- ",totalvalue];
        self.lblItems.text = [NSString stringWithFormat:@"Items : %ld",totalitem];
        
//        lblCountStr= [NSString stringWithFormat:@"%d",totalitem];
//        [Userdefaults setObject:lblCountStr forKey:@"isCount"];
//        [Userdefaults synchronize];
    }
    else
    {
        
        self.lblSubtotal.text = [NSString stringWithFormat:@"Subtotal : %d Rs/-",totalvalue];
        self.lblItems.text = [NSString stringWithFormat:@"Items : %d",totalitem];
        
        lblCountStr= [NSString stringWithFormat:@"%d",totalitem];
        [Userdefaults setObject:lblCountStr forKey:@"isCount"];
        [Userdefaults synchronize];
    }

}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [_ProductInfo count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *simpleTableIdentifier = @"YourCartTableViewCell";
    
    YourCartTableViewCell *cell = (YourCartTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"YourCartTableViewCell" owner:self options:nil];
        
        cell = [nib objectAtIndex:0];
    }
    
    [cell setDelegate:self];
    
    cell.tag = (int) indexPath.row;
    
    if ([_ProductInfo count]>0) {
        
        NSDictionary *dict = [_ProductInfo objectAtIndex:indexPath.row];
        cell.prdDict = [NSMutableDictionary dictionaryWithDictionary:dict];
        
        NSInteger prdQuentity = [[dict objectForKey:@"prdQuentity"] integerValue];
        if (prdQuentity > 1) {
            
            [cell.minusBtnOutlet setEnabled:YES];
            
        } else {
            
            [cell.minusBtnOutlet setEnabled:NO];
        }
        cell.lblName.text=[NSString stringWithFormat:@"%@",[dict objectForKey:@"title"]];
        
        cell.lblRupees.text=[NSString stringWithFormat:@"Rs %@ /-",[dict objectForKey:@"price"]];
        
        cell.productPrice = [[dict objectForKey:@"price"] integerValue];
        
//        number = (int)[[Userdefaults objectForKey:[NSString stringWithFormat:@"Product:%d",(int)cell.tag]] integerValue];
        
        cell.lblCount.text = [NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"%ld",prdQuentity]];
        
        cell.imgview.image = nil;
        
        NSString *imgURL= [NSString stringWithFormat:@"http://cxc.gohipla.com/retail/admin/resources/image/product/%@/%@",[dict objectForKey:@"product_image_folder"],[dict objectForKey:@"product_image"]];
        
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
                                    cell.imgview.image = image;
                                    
                                    // [cell.indicatorView setHidden:YES];
                                    //  [cell.indicatorView stopAnimating];
                                    
                                }
                            }];
        
        [cell.imgview setContentMode:UIViewContentModeScaleAspectFit];
    
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 98;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
   
}

#pragma mark - YourCartTableViewCellDelegate

- (void)plusBtnAction:(id)sender{
    
    YourCartTableViewCell *cell = (YourCartTableViewCell *)sender;
    NSMutableDictionary* dic = cell.prdDict;
    
    [cartDetails plusItemsCount:&dic];
    number = [cartDetails itemsCount:cell.prdDict];
//    number = (int)[[Userdefaults objectForKey:[NSString stringWithFormat:@"Product:%d",(int)cell.tag]] integerValue];
////    if(number>1){
//
//    number++;
    
    cell.lblCount.text = [NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"%ld",number]];
    
    totalitem = [cartDetails countCartItems];
    totalvalue = cell.productPrice + totalvalue;
    
    self.lblSubtotal.text = [NSString stringWithFormat:@"Subtotal :Rs %ld/- ",totalvalue];
    self.lblItems.text = [NSString stringWithFormat:@"Items : %ld",totalitem];
    
    lblCountStr= [NSString stringWithFormat:@"%ld",totalitem];
    
    number = [cartDetails itemsCount:cell.prdDict];
    if (number>1) {
        [cell.minusBtnOutlet setEnabled:YES];
    } else {
        [cell.minusBtnOutlet setEnabled:NO];
    }
//    [Userdefaults setObject:lblCountStr forKey:@"isCount"];
//    [Userdefaults synchronize];
//
//    [Userdefaults setObject:cell.lblCount.text forKey:[NSString stringWithFormat:@"Product:%d",(int)cell.tag]];
//
//    [Userdefaults setObject:_ProductInfo forKey:@"CartDetails"];
//
//    [Userdefaults synchronize];
    
//    [Userdefaults setObject:self.addToCartItems forKey:@"CartDetails"];
//    [Userdefaults synchronize];
    
}


- (void)minusBtnAction:(id)sender{
    
    YourCartTableViewCell *cell = (YourCartTableViewCell *)sender;
    NSMutableDictionary* dic = cell.prdDict;
    
    number = [cartDetails itemsCount:cell.prdDict];
    if (number>1) {
        [cell.minusBtnOutlet setEnabled:YES];
        [cartDetails minusItemsCount:&dic];
        number = [cartDetails itemsCount:cell.prdDict];
        cell.lblCount.text = [NSString stringWithFormat:@"%ld",number];
        totalitem = [cartDetails countCartItems];
        totalvalue = totalvalue - cell.productPrice;
        
        self.lblSubtotal.text = [NSString stringWithFormat:@"Subtotal :Rs %ld/- ",totalvalue];
        self.lblItems.text = [NSString stringWithFormat:@"Items : %ld",totalitem];
        
        lblCountStr= [NSString stringWithFormat:@"%ld",totalitem];

    } else {
        
        [cell.minusBtnOutlet setEnabled:NO];
    }
    
    /*number = (int)[[Userdefaults objectForKey:[NSString stringWithFormat:@"Product:%d",(int)cell.tag]] integerValue];
    
    if (number>1) {
        
        number--;
        
        cell.lblCount.text = [NSString stringWithFormat:@"%d",number];
        
        totalitem = totalitem - 1;
        totalvalue = totalvalue -(int)[cell.lblRupees.text integerValue];
        
        self.lblSubtotal.text = [NSString stringWithFormat:@"Subtotal : %d Rs/-",totalvalue];
        self.lblItems.text = [NSString stringWithFormat:@"Items : %d",totalitem];
        
        lblCountStr= [NSString stringWithFormat:@"%d",totalitem];
        [Userdefaults setObject:lblCountStr forKey:@"isCount"];
        [Userdefaults synchronize];
        
        [Userdefaults setObject:cell.lblCount.text forKey:[NSString stringWithFormat:@"Product:%d",(int)cell.tag]];
        
        [Userdefaults setObject:_ProductInfo forKey:@"CartDetails"];
        
        [Userdefaults synchronize];
        
    }
    else
    {
        NSIndexPath* pathOfTheCell = [_tableViewYourCart indexPathForCell:cell];
        
        //[self.ProductInfo removeObjectAtIndex:pathOfTheCell.row];
        
        NSMutableArray *arrProducts = [[NSMutableArray alloc] init];
        
        for (int i=0; i<[self.ProductInfo count]; i++) {
            
            int Count = (int)[[Userdefaults objectForKey:[NSString stringWithFormat:@"Product:%d",(int)i]]  integerValue];
            
            if (i!=(int)pathOfTheCell.row) {
                
                [arrProducts addObject:[self.ProductInfo objectAtIndex:i]];
                
                [Userdefaults setObject:[NSString stringWithFormat:@"%d",Count] forKey:[NSString stringWithFormat:@"Product:%d",i]];
            }
            else
            {
                [Userdefaults removeObjectForKey:[NSString stringWithFormat:@"Product:%d",i]];
            }
        }
        
        [Userdefaults setObject:arrProducts forKey:@"CartDetails"];
        
        [Userdefaults synchronize];
        
        _ProductInfo = [Userdefaults objectForKey:@"CartDetails"];
        
        if ([_ProductInfo count]>0) {
            
            totalitem = 0;
            totalvalue = 0;
            
            for (int i=0; i<[_ProductInfo count]; i++) {
                
                NSDictionary *dict = [_ProductInfo objectAtIndex:i];
                
                number = (int)[[Userdefaults objectForKey:[NSString stringWithFormat:@"Product:%d",i]] integerValue];
                
                if (number==0) {
                    
                    number=1;
                }
                
                [Userdefaults setObject:[NSString stringWithFormat:@"%d",number] forKey:[NSString stringWithFormat:@"Product:%d",i]];
                
                [Userdefaults synchronize];
                
                NSString *Rupees = [NSString stringWithFormat:@"%@",[dict objectForKey:@"price"]];
                
                totalitem = number + totalitem;
                totalvalue = ((int)[Rupees integerValue]*number) + totalvalue;
                
            }
            
            self.lblSubtotal.text = [NSString stringWithFormat:@"Subtotal : %d Rs/-",totalvalue];
            
            self.lblItems.text = [NSString stringWithFormat:@"Items : %d",totalitem];
            
            lblCountStr= [NSString stringWithFormat:@"%d",totalitem];
            [Userdefaults setObject:lblCountStr forKey:@"isCount"];
            [Userdefaults synchronize];
        }
        else
        {
            totalitem = 0;
            totalvalue = 0;
            
            self.lblSubtotal.text = [NSString stringWithFormat:@"Subtotal : %d Rs/-",totalvalue];
            
            self.lblItems.text = [NSString stringWithFormat:@"Items : %d",totalitem];
            
            lblCountStr= [NSString stringWithFormat:@"%d",totalitem];
            [Userdefaults setObject:lblCountStr forKey:@"isCount"];
            [Userdefaults synchronize];
        }
        
        [self.tableViewYourCart reloadData];
    }*/
}


- (void)deleteBtnAction:(id)sender{
    
    YourCartTableViewCell *cell = (YourCartTableViewCell *)sender;
    [cartDetails deleteItem:cell.prdDict];
    _ProductInfo = [Userdefaults objectForKey:@"CartDetails"];
    
    totalitem = [cartDetails countCartItems];
    totalvalue = [cartDetails totalPrice];
    
    self.lblSubtotal.text = [NSString stringWithFormat:@"Subtotal :Rs %ld/-",totalvalue];
    self.lblItems.text = [NSString stringWithFormat:@"Items : %ld",totalitem];
    
    lblCountStr= [NSString stringWithFormat:@"%ld",totalitem];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
         [self.tableViewYourCart reloadData];
        
        if (totalitem == 0) {
    
//            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"No Product are added in Your cart.Shop more to procced"
//                                                                message:nil
//                                                               delegate:nil
//                                                      cancelButtonTitle:@"Ok"
//                                                      otherButtonTitles:nil];
//            [alertView show];
            
            UIAlertController * alert = [UIAlertController
                                         alertControllerWithTitle:@"No Product are added in Your cart.Shop more to procced."
                                         message:nil
                                         preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* ok = [UIAlertAction
                                 actionWithTitle:@"OK"
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action)
                                 {
                                     [alert dismissViewControllerAnimated:YES completion:nil];
                                     dispatch_async(dispatch_get_main_queue(), ^{
                                         
                                         QuickCheckOutViewController *quickCheckOutViewControllerScreen = [[QuickCheckOutViewController alloc]initWithNibName:@"QuickCheckOutViewController" bundle:nil];
                                         [self.navigationController pushViewController:quickCheckOutViewControllerScreen animated:YES];
                                         
                                     });
                                     
                                 }];
            
            [alert addAction:ok];
            
            [self presentViewController:alert animated:YES completion:nil];
            
        }
        
    });
    
//    NSIndexPath* pathOfTheCell = [_tableViewYourCart indexPathForCell:cell];
//
//    //[self.ProductInfo removeObjectAtIndex:pathOfTheCell.row];
//
//    NSMutableArray *arrProducts = [[NSMutableArray alloc] init];
//
//    for (int i=0; i<[self.ProductInfo count]; i++) {
//
//        int Count = (int)[[Userdefaults objectForKey:[NSString stringWithFormat:@"Product:%d",(int)i]]  integerValue];
//
//        if (i!=(int)pathOfTheCell.row) {
//
//            [arrProducts addObject:[self.ProductInfo objectAtIndex:i]];
//
//            [Userdefaults setObject:[NSString stringWithFormat:@"%d",Count] forKey:[NSString stringWithFormat:@"Product:%d",i]];
//        }
//        else
//        {
//            [Userdefaults removeObjectForKey:[NSString stringWithFormat:@"Product:%d",i]];
//        }
//    }
//
//    [Userdefaults setObject:arrProducts forKey:@"CartDetails"];
//
//    [Userdefaults synchronize];
//
//    _ProductInfo = [Userdefaults objectForKey:@"CartDetails"];
//
//    if ([_ProductInfo count]>0) {
//
//        totalitem = 0;
//        totalvalue = 0;
//
//        for (int i=0; i<[_ProductInfo count]; i++) {
//
//            NSDictionary *dict = [_ProductInfo objectAtIndex:i];
//
//            number = (int)[[Userdefaults objectForKey:[NSString stringWithFormat:@"Product:%d",i]] integerValue];
//
//            if (number==0) {
//
//                number=1;
//            }
//
//            [Userdefaults setObject:[NSString stringWithFormat:@"%d",number] forKey:[NSString stringWithFormat:@"Product:%d",i]];
//
//            [Userdefaults synchronize];
//
//            NSString *Rupees = [NSString stringWithFormat:@"%@",[dict objectForKey:@"price"]];
//
//            totalitem = number + totalitem;
//            totalvalue = ((int)[Rupees integerValue]*number) + totalvalue;
//
//        }
//
//        self.lblSubtotal.text = [NSString stringWithFormat:@"Subtotal : %d Rs/-",totalvalue];
//        self.lblItems.text = [NSString stringWithFormat:@"Items : %d",totalitem];
//
//        lblCountStr= [NSString stringWithFormat:@"%d",totalitem];
//        [Userdefaults setObject:lblCountStr forKey:@"isCount"];
//        [Userdefaults synchronize];
//    }
//    else
//    {
//        totalitem = 0;
//        totalvalue = 0;
//
//        self.lblSubtotal.text = [NSString stringWithFormat:@"Subtotal : %d Rs/-",totalvalue];
//        self.lblItems.text = [NSString stringWithFormat:@"Items : %d",totalitem];
//
//        lblCountStr= [NSString stringWithFormat:@"%d",totalitem];
//        [Userdefaults setObject:lblCountStr forKey:@"isCount"];
//        [Userdefaults synchronize];
//    }
    
}

- (IBAction)crossBtn:(id)sender {
    
//    [self.navigationController popViewControllerAnimated:YES];
    
    ProductCategoryViewController *ProductCategoryViewScreen = [[ProductCategoryViewController alloc]initWithNibName:@"ProductCategoryViewController" bundle:nil];
    
    [self.navigationController pushViewController:ProductCategoryViewScreen animated:YES];
    
}

- (IBAction)continueBtn:(id)sender {
    
    ProductCategoryViewController *productCategoryViewControllerScreen = [[ProductCategoryViewController alloc]initWithNibName:@"ProductCategoryViewController" bundle:nil];
    
    [self.navigationController pushViewController:productCategoryViewControllerScreen animated:YES];
    
}

- (IBAction)checkoutBtn:(id)sender {
    
    [self orderCreat];
    
}

-(void)orderCreat
{
    [SVProgressHUD show];
    
    NSString *dictall = @"";
    _ProductInfo = [Userdefaults objectForKey:@"CartDetails"];
    for (int i=0; i<[_ProductInfo count]; i++) {
        
        NSDictionary *dict = [_ProductInfo objectAtIndex:i];
        
        NSInteger quantity = [[dict objectForKey:@"prdQuentity"] integerValue];//(int)[[Userdefaults objectForKey:[NSString stringWithFormat:@"Product:%d",i]] integerValue];
        
        NSString *dictStr = [NSString stringWithFormat:@"{\"product_id\":%@,\"quantity\": %ld,\"price_per_unit\":%@}",[dict objectForKey:@"id"],quantity,[dict objectForKey:@"price"]];
        
        if ([dictall isEqualToString:@""]) {
            
            dictall = [NSString stringWithFormat:@"%@",dictStr];
        }
        else
        {
            dictall = [NSString stringWithFormat:@"%@,%@",dictall,dictStr];
        }
        
    }
    
//    NSString *productStr = [NSString stringWithFormat:@"\"product\":[%@]",dictall];
    NSString *productStr = [NSString stringWithFormat:@"[%@]",dictall];
    
    NSString *userUpdate = [NSString stringWithFormat:@"user_id=%@&total_quantity=%ld&total_amount=%ld&buyer_name=%@&delivery_address=%@&landmark=%@&pincode=%@&phone=%@&order_date=%@&order_current_status=0&product=%@",[NSString stringWithFormat:@"%@",userId],totalitem,totalvalue,[NSString stringWithFormat:@"%@",fname],[NSString stringWithFormat:@"%@",address],[NSString stringWithFormat:@"aaaa"],[NSString stringWithFormat:@"%@",pincode],[NSString stringWithFormat:@"%@",phone],[NSString stringWithFormat:@"%@",currentDateStr],productStr];

     NSLog(@"%@",userUpdate);
    
    //Convert the String to Data
    NSData *data = [userUpdate dataUsingEncoding:NSUTF8StringEncoding];
    
    [api ApiRequestPOSTwithPostdata:data WithUrlLastPart:@"ordercreat.php" completion:^(NSDictionary * dict, NSError *error) {
        [SVProgressHUD dismiss];
        
        NSLog(@"%@",dict);
        
        NSLog(@"%@",error);
        
        if (!error) {
            
            NSString *successStr = [dict objectForKey:@"status"];
            
            if ([successStr isEqualToString:@"success"]) {
                
                createOrderuniqueId=[dict objectForKey:@"createOrder_uniqueid"];
                
                createOrderId= [NSString stringWithFormat:@"%d",(int)[[dict objectForKey:@"createOrder_id"] integerValue]];
                
                UIAlertController * alert=   [UIAlertController
                                              alertControllerWithTitle:@"Hipla Retail"
                                              message:[NSString stringWithFormat:@"Total Pay %ld by cash",totalvalue]
                                              preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction* ok = [UIAlertAction
                                     actionWithTitle:@"OK"
                                     style:UIAlertActionStyleDefault
                                     handler:^(UIAlertAction * action)
                                     {
                                         [alert dismissViewControllerAnimated:YES completion:nil];
                                         
                                         [self tranerCreat];
                                         
                                     }];
                
                [alert addAction:ok];
                
                [self presentViewController:alert animated:YES completion:nil];
                
                [SVProgressHUD dismiss];
                
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
        
    }];
    
}

-(void)tranerCreat
{
    [SVProgressHUD show];
    
    NSString *userUpdate = [NSString stringWithFormat:@"user_id=%@&order_id=%@&transaction_type=COD&transaction_amount=%ld&transaction_date=%@",userId,createOrderId,totalvalue,[NSString stringWithFormat:@"%@",currentDateStr]];
    NSLog(@"tranerCreat==%@",userUpdate);
    //Convert the String to Data
    NSData *data = [userUpdate dataUsingEncoding:NSUTF8StringEncoding];
    
    [api ApiRequestPOSTwithPostdata:data WithUrlLastPart:@"tranercreat.php" completion:^(NSDictionary * dict, NSError *error) {
        [SVProgressHUD dismiss];
        
        NSLog(@"%@",dict);
        
        NSLog(@"%@",error);
        
        if (!error) {
            
            NSString *successStr = [dict objectForKey:@"status"];
            
            if ([successStr isEqualToString:@"success"]) {
                
//                NSMutableArray *arrProducts = [Userdefaults objectForKey:@"CartDetails"];
//
//                for (int i=0; i<[arrProducts count]; i++) {
//
//                    [Userdefaults removeObjectForKey:[NSString stringWithFormat:@"Product:%d",i]];
//
//                }
                
                [Userdefaults removeObjectForKey:@"CartDetails"];
                
                cartDetails.addToCartItems = [[NSMutableArray alloc]init];
                
//                int totalcount = (int)[cartDetails countCartItems];
                
//                [Userdefaults removeObjectForKey:@"isCount"];
//                [Userdefaults synchronize];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    ProductCategoryViewController *productCategoryScreen = [[ProductCategoryViewController alloc]initWithNibName:@"ProductCategoryViewController" bundle:nil];
                    [self.navigationController pushViewController:productCategoryScreen animated:YES];                });
                
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
        
    }];
    
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

@end

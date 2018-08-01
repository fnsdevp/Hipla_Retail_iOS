//
//  ViewController.m
//  HiplaRetail
//
//  Created by fnspl3 on 07/02/18.
//  Copyright © 2018 fnspl3. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}
- (IBAction)clickedOpen:(id)sender {
    
    KYDrawerController *elDrawer = (KYDrawerController*)self.navigationController.parentViewController;
    
    [elDrawer setDrawerState:KYDrawerControllerDrawerStateOpened animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

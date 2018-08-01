//
//  CartDetails.m
//  Jing
//
//  Created by fnspl3 on 15/11/17.
//  Copyright © 2017 fnspl3. All rights reserved.
//

#import "CartDetails.h"

static CartDetails *sharedInstanceCartDetails;

@implementation CartDetails

+(CartDetails *)sharedInstanceCartDetails
{
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        sharedInstanceCartDetails=[[CartDetails alloc] init];
    });
    
    return sharedInstanceCartDetails;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.addToCartItems = [[NSMutableArray alloc] init];
    }
    return self;
}

- (NSInteger)countCartItems {
    
    NSInteger countCardItems = 0;
    self.addToCartItems = [Userdefaults objectForKey:@"CartDetails"];
    if (self.addToCartItems && [self.addToCartItems count]) {
        
        for (NSDictionary *dictPrd in self.addToCartItems)
        {
            NSInteger prdQuentity = [[dictPrd objectForKey:@"prdQuentity"] integerValue];
            countCardItems += prdQuentity;
        }
        return countCardItems;
        
    } else {
        
        return countCardItems;
    }
}

- (void)addItemsInCard:(NSDictionary *)prdDict {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:prdDict];
    self.addToCartItems = [NSMutableArray array];
    
    NSMutableArray *ProductInfo = [Userdefaults objectForKey:@"CartDetails"];
    
    BOOL isSamePrd = NO;
    for (NSDictionary *dictPrd2 in ProductInfo)
    {
        
        NSMutableDictionary *dictPrd = [NSMutableDictionary dictionaryWithDictionary:dictPrd2];
        if ([[dictPrd objectForKey:@"bar_code"] integerValue] == [[dict objectForKey:@"bar_code"] integerValue]) {
            
            isSamePrd = YES;
            NSInteger prdQuentity = [[dictPrd objectForKey:@"prdQuentity"] integerValue];
            prdQuentity++;
            [dictPrd setValue:@(prdQuentity) forKey:@"prdQuentity"];
            
        }
        [self.addToCartItems addObject:dictPrd];
    }
    
    if (!isSamePrd) {
        
        NSInteger prdQuentity = 1;
        [dict setValue:@(prdQuentity) forKey:@"prdQuentity"];
        [self.addToCartItems addObject:dict];
        
    }
    
    [Userdefaults setObject:self.addToCartItems forKey:@"CartDetails"];
    [Userdefaults synchronize];
    
}

-(void)plusItemsCount:(NSMutableDictionary **)prdDict {
    
    self.addToCartItems = [NSMutableArray array];
    NSMutableArray *ProductInfo = [Userdefaults objectForKey:@"CartDetails"];
    for (NSDictionary *dictPrd2 in ProductInfo)
    {
        
        NSMutableDictionary *dictPrd = [NSMutableDictionary dictionaryWithDictionary:dictPrd2];
        if ([[dictPrd objectForKey:@"bar_code"] integerValue] == [[*prdDict objectForKey:@"bar_code"] integerValue]) {
            
            NSInteger prdQuentity = [[dictPrd objectForKey:@"prdQuentity"] integerValue];
            prdQuentity++;
            [dictPrd setValue:@(prdQuentity) forKey:@"prdQuentity"];
            [*prdDict setValue:@(prdQuentity) forKey:@"prdQuentity"];
            
        }
        [self.addToCartItems addObject:dictPrd];
    }
    
    [Userdefaults setObject:self.addToCartItems forKey:@"CartDetails"];
    [Userdefaults synchronize];
}

-(void)minusItemsCount:(NSMutableDictionary **)prdDict {
    
    self.addToCartItems = [NSMutableArray array];
    NSMutableArray *ProductInfo = [Userdefaults objectForKey:@"CartDetails"];
    for (NSDictionary *dictPrd2 in ProductInfo)
    {
        
        NSMutableDictionary *dictPrd = [NSMutableDictionary dictionaryWithDictionary:dictPrd2];
        if ([[dictPrd objectForKey:@"bar_code"] integerValue] == [[*prdDict objectForKey:@"bar_code"] integerValue]) {
            
            NSInteger prdQuentity = [[dictPrd objectForKey:@"prdQuentity"] integerValue];
            prdQuentity--;
            [dictPrd setValue:@(prdQuentity) forKey:@"prdQuentity"];
            [*prdDict setValue:@(prdQuentity) forKey:@"prdQuentity"];
            
        }
        [self.addToCartItems addObject:dictPrd];
    }
    
    [Userdefaults setObject:self.addToCartItems forKey:@"CartDetails"];
    [Userdefaults synchronize];
}


-(void)deleteItem:(NSMutableDictionary *)prdDict {
    
    self.addToCartItems = [NSMutableArray array];
    NSMutableArray *ProductInfo = [Userdefaults objectForKey:@"CartDetails"];
    for (NSDictionary *dictPrd2 in ProductInfo)
    {
        
        NSMutableDictionary *dictPrd = [NSMutableDictionary dictionaryWithDictionary:dictPrd2];
        if ([[dictPrd objectForKey:@"bar_code"] integerValue] != [[prdDict objectForKey:@"bar_code"] integerValue]) {
            
            [self.addToCartItems addObject:dictPrd];
            
        }
    }
    
    [Userdefaults setObject:self.addToCartItems forKey:@"CartDetails"];
    [Userdefaults synchronize];
}

-(NSInteger)itemsCount:(NSDictionary *)prdDict {
    
    NSInteger prdQuentity = [[prdDict objectForKey:@"prdQuentity"] integerValue];
    return prdQuentity;
    
//    [Userdefaults setObject:prdQuentity forKey:@"prdQuentity"];
//    [Userdefaults synchronize];
}

- (double)totalPrice {
    
    double totalPrice = 0.0;
    NSMutableArray *ProductInfo = [Userdefaults objectForKey:@"CartDetails"];
    for (NSDictionary *dictPrd in ProductInfo)
    {
        NSInteger prdQuentity = [[dictPrd objectForKey:@"prdQuentity"] integerValue];
        double prdPrice = [[dictPrd objectForKey:@"price"] doubleValue];
        
        totalPrice += prdPrice * prdQuentity;
    }
    
    return totalPrice;
}


@end

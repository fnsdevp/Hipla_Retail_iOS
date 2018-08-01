//
//  CartDetails.h
//  Jing
//
//  Created by fnspl3 on 15/11/17.
//  Copyright © 2017 fnspl3. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"

@interface CartDetails : NSObject

+(CartDetails *)sharedInstanceCartDetails;
- (NSInteger)countCartItems;
- (void)addItemsInCard:(NSDictionary *)prdDict;
-(void)plusItemsCount:(NSMutableDictionary **)prdDict;
-(void)minusItemsCount:(NSMutableDictionary **)prdDict;
-(NSInteger)itemsCount:(NSDictionary *)prdDict;
-(void)deleteItem:(NSMutableDictionary *)prdDict;
- (double)totalPrice;

@property (nonatomic, strong) NSMutableArray* addToCartItems;

@end

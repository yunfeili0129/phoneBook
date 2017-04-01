//
//  PHoneBook.h
//  商信
//  手机通讯录管理类
//  Created by liyunfei on 16/6/6.
//  Copyright © 2016年 liyunfei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
typedef void(^pbBlock)(NSArray *arr);
@interface PHoneBook : NSObject
+(instancetype)shardPhoneBook;
-(void)getAllAddressBook:(pbBlock)block;
@end

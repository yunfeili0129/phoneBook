//  PHoneBook.m
//  Created by liyunfei on 16/6/6.
//  Copyright © 2016年 liyunfei. All rights reserved.

#import "PBClass.h"
#import "NSString+regX.h"
static PHoneBook *BookManager=nil;

@implementation PHoneBook
+(instancetype)shardPhoneBook
{
    static dispatch_once_t oneToken;
    dispatch_once(&oneToken, ^{
        if (BookManager==nil) {
            BookManager=[[PHoneBook alloc]init];
        }
    });
    return BookManager;
}
-(void)getAllAddressBook:(pbBlock)block
{
     ABAddressBookRef addressBook = ABAddressBookCreate();
    
     ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
             if (granted){
                 NSLog(@"授权成功！");
                 // 2. 获取所有联系人记录
                 
                 CFArrayRef array = ABAddressBookCopyArrayOfAllPeople(addressBook);
                 NSInteger  count = CFArrayGetCount(array);
                 NSMutableArray *bookArr=[NSMutableArray array];
                 
                  for (NSInteger i = 0; i < count; i++) {
                      // 取出一条记录
                           ABRecordRef person = CFArrayGetValueAtIndex(array, i);
                      
                        // 取出个人记录中的详细信息
                        CFStringRef firstName = ABRecordCopyValue(person, kABPersonFirstNameProperty);
                        // 姓
                        CFStringRef lastName = ABRecordCopyValue(person, kABPersonLastNameProperty);
                      NSString *fname=(__bridge NSString *)firstName;
                      NSString *lname=(__bridge NSString *)lastName;
                        //NSLog(@"%@ %@ - %@ %@", firstNameLabel,firstName ,lastNameLabel, lastName);
                      //拼装姓名
                      NSString *username=@"";
                      if (lastName!=NULL) {
                          username=[username stringByAppendingString:[NSString stringWithFormat:@"%@",lname]];
                      }
                      if (firstName!=NULL) {
                          username=[username stringByAppendingString:[NSString stringWithFormat:@"%@",fname]];
                      }
                      
                      NSLog(@"%@",username);
                      // 取电话号码
                        ABMultiValueRef phones = ABRecordCopyValue(person, kABPersonPhoneProperty);
                       // 取记录数量
                       NSInteger phoneCount = ABMultiValueGetCount(phones);
                     
                       // 遍历所有的电话号码
                       NSMutableArray *numdic=[NSMutableArray array];
                       for (NSInteger i = 0; i < phoneCount; i++)
                            {
                                
                                // 电话标签
                                 //CFStringRef phoneLabel = ABMultiValueCopyLabelAtIndex(phones, i);
                                 // 本地化电话标签
                                 //CFStringRef phoneLocalLabel = ABAddressBookCopyLocalizedLabel(phoneLabel);
                                 // 电话号码
                                CFStringRef phoneNumber = ABMultiValueCopyValueAtIndex(phones, i);
                                NSLog(@"%@",phoneNumber);
                                NSString *pnum=(__bridge NSString *)phoneNumber;
                                if ([pnum isTelephone])
                                {
                                    [numdic addObject:pnum];
                                }
                                
                           }
                     
                       NSDictionary *personDict=@{@"username":username,@"phoneNumber":numdic};
                      [bookArr addObject:personDict];
                      
                  }
                  block(bookArr);
                  CFRelease(array);
                  CFRelease(addressBook);
             }
         
            else{
                  NSLog(@"授权失败!");
                
              }
         });
    
}
@end



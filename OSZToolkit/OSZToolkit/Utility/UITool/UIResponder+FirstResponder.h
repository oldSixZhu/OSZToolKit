//
//  UIResponder+FirstResponder.h
//  FeedSystem
//
//  Created by Mac on 2017/5/13.
//  Copyright © 2017年 bigtutu. All rights reserved.
//
//返回第一响应者,与滚轮式图pickerView配合使用

#import <UIKit/UIKit.h>

@interface UIResponder (FirstResponder)

+ (id)currentFirstResponder; 

@end

/*

 //指定每个表盘上有几行数据
 -(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
 {
 return self.fodderArr.count;
 }
 
 //指定每行几个数据
 -(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
 {
 
 return self.fodderArr[row];
 }
 
 -(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
 {
 //获取对应列，对应行的数据
 //    NSString *name=self.foods[component][row];
 if ([[UIResponder currentFirstResponder] isKindOfClass:[UITextField class]])
 {
 UITextField *tf = [UIResponder currentFirstResponder];
 tf.text = self.fodderArr[row];
 }
 
 }
 
 
*/

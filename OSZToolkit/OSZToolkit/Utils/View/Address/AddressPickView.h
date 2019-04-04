//
//  AddressPickView.h
//  FitForceCoach
//
//  Created by fun on 2019/1/2.
//

#import <UIKit/UIKit.h>


typedef void(^confirmBlock)(NSString *shengName, NSString *shiName, NSString *xianName);


@interface AddressPickView : UIView

@property (nonatomic, copy) confirmBlock confirmBlock;  /**< 确定回调 */

- (instancetype)initWithFrame:(CGRect)frame;
- (void)show;
- (void)dismiss;

@end


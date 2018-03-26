//
//  OSZRulerModel.h
//  TYFitFore
//
//  Created by TanYun on 2018/1/17.
//  Copyright © 2018年 tangpeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OSZRulerModel : NSObject

@property (nonatomic,strong) NSString *value;                    /**< 要显示的数字 */
@property (nonatomic,strong) NSString *unit;                    /**< 单位 */
@property (nonatomic,assign) BOOL isCenter;                    /**< 是否是中间的cell */


@end

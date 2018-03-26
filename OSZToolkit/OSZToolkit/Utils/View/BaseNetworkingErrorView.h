//
//  BaseNetworkingErrorView.h
//  FitForceCoach
//
//  Created by xuyang on 2017/12/4.
//

#import <UIKit/UIKit.h>

typedef void(^ErrorViewReloadClosure)(void);

@interface BaseNetworkingErrorView : UIView

@property (nonatomic, copy) ErrorViewReloadClosure reloadClosure;                   /**< 重新加载 */

@end  

//
//  BaseLoadingView.h
//  FitForceCoach
//
//  Created by xuyang on 2017/12/4.
//

#import <UIKit/UIKit.h>

@interface BaseLoadingView : UIView

@property (nonatomic, strong) UIImageView *loadingView;                             /**< 加载的gif图 */
@property (nonatomic, strong) UILabel *loadingTextLabel;                            /**< 加载中... */

+ (NSArray *)gifImagesWithImage;

@end

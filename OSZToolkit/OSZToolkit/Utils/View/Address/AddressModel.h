//
//  AddressModel.h
//  FitForceCoach
//
//  Created by fun on 2019/1/2.
//

#import <Foundation/Foundation.h>


@interface AddressModel : NSObject

@property (nonatomic, strong) NSString *citycode;   /**< 城市编码 */
@property (nonatomic, strong) NSString *adcode;     /**< 区域编码 */
@property (nonatomic, strong) NSString *name;       /**< 区域名称 */
@property (nonatomic, strong) NSString *center;     /**< 城市中心点 */
@property (nonatomic, strong) NSString *level;      /**< 行政区级别划分：{ province:省份（直辖市会在province和city显示）、city:市、district:区县 } */
@property (nonatomic, strong) NSArray<AddressModel *> *districts;   /**< 下级列表 */

@end


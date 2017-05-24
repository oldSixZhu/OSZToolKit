//
//  OSZCoreDataStackManager.h
//  CoreData练习1
//
//  Created by oldSix_Zhu on 16/9/25.
//  Copyright © 2016年 oldSix_Zhu. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <CoreData/CoreData.h>

//文件名
#define kFileName @"sqlit"

//管理者
#define kOSZCoreDataStackManager [OSZCoreDataStackManager sharedOSZCoreDataStackManager]

@interface OSZCoreDataStackManager : NSObject

//单例
+(OSZCoreDataStackManager *)sharedOSZCoreDataStackManager;

//管理对象上下文
@property (nonatomic,strong)NSManagedObjectContext *managedObjectContext;

//模型对象
@property (nonatomic,strong)NSManagedObjectModel *managedObjectModel;

//存储调度器
@property (nonatomic,strong)NSPersistentStoreCoordinator *persistentStoreCoordinator;

//保存
-(void)save;

//清空
- (void)deleteAllEntities;
@end

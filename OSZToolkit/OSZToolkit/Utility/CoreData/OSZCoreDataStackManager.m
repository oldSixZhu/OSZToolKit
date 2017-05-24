//
//  OSZCoreDataStackManager.m
//  CoreData练习1
//
//  Created by oldSix_Zhu on 16/9/25.
//  Copyright © 2016年 oldSix_Zhu. All rights reserved.
//

#import "OSZCoreDataStackManager.h"

@implementation OSZCoreDataStackManager

//单例
+ (OSZCoreDataStackManager *)sharedOSZCoreDataStackManager
{
    static OSZCoreDataStackManager *manager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[OSZCoreDataStackManager alloc]init];
    });
    
    return manager;
}

//获取沙盒路径
-(NSURL *)getDocumentUrlPath
{
    return [[[NSFileManager defaultManager]URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask]lastObject];
}

//懒加载管理对象上下文
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil)
    {
        return _managedObjectContext;
    }
    
    //初始化管理对象上下文
    _managedObjectContext = [[NSManagedObjectContext alloc]initWithConcurrencyType:NSMainQueueConcurrencyType];
    
    //设置存储调度器
    [_managedObjectContext setPersistentStoreCoordinator:self.persistentStoreCoordinator];
    
    return _managedObjectContext;
}

//懒加载模型对象
-(NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil)
    {
        return _managedObjectModel;
    }
    
    //自动获取所有的模型文件
    _managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
    
    return _managedObjectModel;
}

//懒加载存储调度器
-(NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil)
    {
        return _persistentStoreCoordinator;
    }
    
    //初始化存储调度器
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc]initWithManagedObjectModel:self.managedObjectModel];
    
    //添加存储器
    NSURL *url = [[self getDocumentUrlPath]URLByAppendingPathComponent:[NSString stringWithFormat:@"%@.db",kFileName] isDirectory:NO];
//    NSLog(@"-------------------------%@",url);
    //存储方式  配置信息    保存路径    参数信息
    [_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:url options:nil error:nil];
    
    return _persistentStoreCoordinator;
}

//保存数据
-(void)save
{
    [self.managedObjectContext save:nil];
}

//清除数据库
- (void)deleteAllEntities
{
    NSString *path1 = [NSString stringWithFormat:@"%@/Documents/%@.db",NSHomeDirectory(),kFileName];
    NSString *path2 = [NSString stringWithFormat:@"%@/Documents/%@.db-shm",NSHomeDirectory(),kFileName];
    NSString *path3 = [NSString stringWithFormat:@"%@/Documents/%@.db-wal",NSHomeDirectory(),kFileName];
    
    [[NSFileManager defaultManager] removeItemAtPath:path1 error:nil];
    [[NSFileManager defaultManager] removeItemAtPath:path2 error:nil];
    [[NSFileManager defaultManager]removeItemAtPath:path3 error:nil];
}
@end









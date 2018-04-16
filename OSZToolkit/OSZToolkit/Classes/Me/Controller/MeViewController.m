//
//  MeViewController.m
//  demo
//
//  Created by TanYun on 2018/4/16.
//  Copyright © 2018年 icarbonx. All rights reserved.
//

#import "MeViewController.h"
#import "MeNetworkManager.h"

@interface MeViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *friendsTableView;  /**< 朋友列表 */
@property (nonatomic, strong) NSArray *friends;               /**< 数据源 */


@end

@implementation MeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //加载动画 loading...
    [self getData];
}

- (void)getData {
    @weakify(self)
    [[MeNetworkManager getAllFriends] subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        //加载动画loading...消失
        //拿到数据,更新数据源,刷新tableView
        FriendModel *friendModel = (FriendModel *)x;
        if (friendModel.friends.count > 0) {
            self.friends = friendModel.friends;
            [self.friendsTableView reloadData];
        }
    } error:^(NSError * _Nullable error) {
        //失败处理
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

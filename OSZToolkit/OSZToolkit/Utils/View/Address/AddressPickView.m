//
//  AddressPickView.m
//  FitForceCoach
//
//  Created by fun on 2019/1/2.
//

#import "AddressPickView.h"
#import "AddressModel.h"



@interface AddressPickView ()<UIPickerViewDelegate,UIPickerViewDataSource>

@property (nonatomic,strong) UIView *darkView;
@property (nonatomic,strong) UIView *backView;
@property (nonatomic,strong) UIPickerView *pickerView;
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UIButton *cancelButton;
@property (nonatomic,strong) UIButton *doneButton;

@property (nonatomic,strong) NSArray *provinceArray;  /**< 数据源 */
@property (nonatomic,assign) NSInteger selectRowWithProvince; //选中的省份对应的下标
@property (nonatomic,assign) NSInteger selectRowWithCity; //选中的市级对应的下标
@property (nonatomic,assign) NSInteger selectRowWithTown; //选中的县级对应的下标

@end



@implementation AddressPickView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT + 300);
        
        self.selectRowWithProvince = 0;
        self.selectRowWithCity = 0;
        self.selectRowWithTown = 0;
        [self initGesture];
    }
    return self;
}

- (void)show{
    [self initView];
}

- (void)initView{
    [self showInView:[[UIApplication sharedApplication].windows lastObject]];
    
    [self addSubview:self.darkView];
    [self addSubview:self.backView];
    [self.backView addSubview:self.cancelButton];
    [self.backView addSubview:self.doneButton];
    [self.backView addSubview:self.titleLabel];
    [self.backView addSubview:self.pickerView];
}

- (void)initGesture {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
    [self addGestureRecognizer:tap];
}

- (void)showInView:(UIView *)view{
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = CGRectMake(0, -250, SCREEN_WIDTH, SCREEN_HEIGHT + 300);
    } completion:^(BOOL finished) {
        
    }];
    [view addSubview:self];
}

//消失/取消
- (void)dismiss {
    [UIView animateWithDuration:0.3 animations:^{
        self.frame =CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT + 300);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

//确定
- (void)didClickDone {
    NSInteger shengRow = [self.pickerView selectedRowInComponent:0];
    NSInteger shiRow = [self.pickerView selectedRowInComponent:1];
    NSInteger xianRow = [self.pickerView selectedRowInComponent:2];
    
    AddressModel *provinceModel = self.provinceArray[shengRow];
    AddressModel *cityModel = provinceModel.districts[shiRow];
    //防止某些市没有区
    NSString *areaName = cityModel.name;
    if (cityModel.districts.count > 0) {
         AddressModel *areaModel = cityModel.districts[xianRow];
        areaName = areaModel.name;
    }
    if (self.confirmBlock) {
        self.confirmBlock(provinceModel.name, cityModel.name, areaName);
    }
    [self dismiss];
}


#pragma mark - UIPickerViewDelegate
//返回选择器有几列
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 3;
}

//返回每组有几行
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    NSInteger integer = 0;
    if (component == 0) {
        integer = self.provinceArray.count;
    } else if (component == 1){
        AddressModel *model = self.provinceArray[self.selectRowWithProvince];
        integer = model.districts.count;
    } else if (component == 2) {
        AddressModel *model = self.provinceArray[self.selectRowWithProvince];
        AddressModel *cityModel = model.districts[self.selectRowWithCity];
        //防止某些市没有区
        if (cityModel.districts.count > 0) {
            integer = cityModel.districts.count;
        } else {
            integer = 1;
        }
    }
    return integer;
}

//返回第component列第row行的内容(标题)
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    switch (component) {
        case 0:{
            AddressModel *model = self.provinceArray[row];
            return model.name;
        }
            break;
            
        case 1:{
            AddressModel *model = self.provinceArray[self.selectRowWithProvince];
            AddressModel *citymodel = model.districts[row];
            return citymodel.name;
        }
            break;
            
        case 2: {
            AddressModel *model = self.provinceArray[self.selectRowWithProvince];
            AddressModel *citymodel = model.districts[self.selectRowWithCity];
            //防止某些市没有区
            if (citymodel.districts.count > 0) {
                AddressModel *teanmodel = citymodel.districts[row];
                return teanmodel.name;
            } else {
                return citymodel.name;
            }
        }
            break;
            
        default:
            break;
    }
    return nil;
}

//设置row字体，颜色
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    UILabel *pickerLabel = (UILabel *)view;
    if (!pickerLabel) {
        pickerLabel = [[UILabel alloc] init];
        pickerLabel.textAlignment = NSTextAlignmentCenter;
        pickerLabel.backgroundColor = [UIColor clearColor];
        pickerLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:kFloat(16)];
        pickerLabel.textColor = UIColorFromHex(0x34353B);
    }
    pickerLabel.text = [self pickerView:pickerView titleForRow:row forComponent:component];
    return pickerLabel;
}


//选中第component第row的时候调用
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (component == 0) {
        self.selectRowWithProvince = row;
        self.selectRowWithCity = 0;
        self.selectRowWithTown = 0;
        [pickerView reloadAllComponents];
        [pickerView selectRow:0 inComponent:1 animated:YES];
        [pickerView selectRow:0 inComponent:2 animated:YES];
    } else if (component == 1) {
        self.selectRowWithCity = row;
        [pickerView reloadAllComponents];
        [pickerView selectRow:0 inComponent:2 animated:YES];
    } else {
        self.selectRowWithTown = row;
    }
}

#pragma mark - getter
- (UIView *)darkView {
    if (!_darkView) {
        _darkView = [[UIView alloc] init];
        _darkView.frame = self.frame;
        _darkView.backgroundColor = [UIColor blackColor];
        _darkView.alpha = 0.3;
    }
    return _darkView;
    
}

- (UIView *)backView {
    if (!_backView) {
        _backView = [[UIView alloc] init];
        _backView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 250);
        _backView.backgroundColor = [UIColor whiteColor];
    }
    return _backView;
}

- (UIPickerView *)pickerView{
    if(!_pickerView) {
        _pickerView = [[UIPickerView alloc] init];
        _pickerView.frame = CGRectMake(0, 50, SCREEN_WIDTH, 200);
        _pickerView.backgroundColor =[UIColor whiteColor];
        _pickerView.dataSource = self;
        _pickerView.delegate = self;
    }
    return _pickerView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - 110) * 0.5, 15, 110, 25)];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.text = ZYSString(@"me_selectAddress");
        _titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:18];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (UIButton *)cancelButton {
    if (!_cancelButton) {
        _cancelButton = [[UIButton alloc]initWithFrame:CGRectMake(23, 18, 30, 21)];
        _cancelButton.touchAreaInsets = UIEdgeInsetsMake(10, 10, 10, 10);
        [_cancelButton setTitleColor:UIColorFromHex(0x20C6BA) forState:UIControlStateNormal];
        [_cancelButton setTitle:ZYSString(@"me_home_tabBar_cancel") forState:UIControlStateNormal];
        _cancelButton.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
        [_cancelButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelButton;
}

- (UIButton *)doneButton {
    if (!_doneButton) {
        _doneButton = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 30 - 23, 18, 30, 21)];
        _doneButton.touchAreaInsets = UIEdgeInsetsMake(10, 10, 10, 10);
        [_doneButton setTitleColor:UIColorFromHex(0x20C6BA) forState:UIControlStateNormal];
        [_doneButton setTitle:ZYSString(@"me_home_tabBar_finish") forState:UIControlStateNormal];
        _doneButton.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
        [_doneButton addTarget:self action:@selector(didClickDone) forControlEvents:UIControlEventTouchUpInside];
    }
    return _doneButton;
}


- (NSArray *)provinceArray {
    if (!_provinceArray) {
        NSString *jsonPath = [[NSBundle mainBundle] pathForResource:@"addressData.json" ofType:nil];
        NSData *jsonData = [[NSData alloc] initWithContentsOfFile:jsonPath];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
        _provinceArray = [NSArray yy_modelArrayWithClass:[AddressModel class] json:dic];
    }
    return _provinceArray;
}


@end

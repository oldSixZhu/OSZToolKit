//
//  HealthRecordMacro.h
//  FitForceCoach
//
//  Created by xuyang on 2017/12/5.
//

#ifndef HealthRecordMacro_h
#define HealthRecordMacro_h

#define Query_BiGu_Buy_Url(personID) ([NSString stringWithFormat:@"https://mainapi.icarbonx.com/health/fasting/userBatch?personId=%@",personID])

#define Query_JoinBiGuPlan_Url(personID) ([NSString stringWithFormat:@"https://mainapi.icarbonx.com/health/fasting/userBatch?personId=%@",personID])

#define Query_JoinBloodSugarPlan_Url(personID) ([NSString stringWithFormat:@"https://mainapi.icarbonx.com/health/bloodGlucose/userBatch?personId=%@",personID])


#define Query_JoinAllPlan_Url(personID) ([NSString stringWithFormat:@"https://mainapi.icarbonx.com/health/batch/userBatch?personId=%@",personID])
static NSString *PlanType_BiGu = @"fasting";
static NSString *PlanType_BloodSugar = @"bloodGlucose";


static NSString *Load_Member_Data_Url = @"https://mainapi.icarbonx.com/account-api/people/account/family?pageSize=1000&pageNum=1";

static NSString *Product_List_ID_Url = @"https://mainapi.icarbonx.com/product/list?categoryKey=health-manager";


//觅我数字生命包
static NSString *Num_Life_Plan_Url = @"https://main.icarbonx.com/v2/#/report2";

//精准断食
static NSString *BiGu_Manage_Plan_Url = @"https://main.icarbonx.com/inedia/home";

//叶酸
static NSString *YeSuan_Url = @"https://main.icarbonx.com/v2/#/report-single/folic-acid";

//核心营养检测包
static NSString *HeXinYingYang_Url = @"https://main.icarbonx.com/mall/2000139";

//瘦身检测包
static NSString *ShouShen_Url = @"https://main.icarbonx.com/mall/2000140";

//乳腺癌风险评估
static NSString *RuXianAi_Url = @"https://main.icarbonx.com/mall/2000141";

//饮食结果页
static NSString *YinShiResult_Url = @"https://main.icarbonx.com/v2/#/digital-manager/diet-record";

//运动结果页
static NSString *SportResult_Url = @"https://meum.icarbonx.com/record/#/sport/records";

//情绪结果页
static NSString *MoodResult_Url = @"https://meum.icarbonx.com/record/#/mood/records";

//睡眠结果页
static NSString *SleepResult_Url = @"https://meum.icarbonx.com/record/#/sleep/records";

//心率贴
static NSString *HeartRate_Url = @"https://meum.icarbonx.com/record/#/heart-rate";

//就诊轨迹结果页
static NSString *JiuZhenResult_Url = @"https://meum.icarbonx.com/record/#/treatment";

//饮食记录
static NSString *YinShiRecord_Url = @"https://main.icarbonx.com/v2/#/digital-manager";

//运动记录
static NSString *SportRecord_Url = @"https://meum.icarbonx.com/record/#/sport";

//情绪记录
static NSString *MoodRecord_Url = @"https://meum.icarbonx.com/record/#/mood";

//睡眠记录
static NSString *SleepRecord_Url = @"https://meum.icarbonx.com/record/#/sleep";

//就诊轨迹记录
static NSString *JiuZhenRecord_Url = @"https://meum.icarbonx.com/record/#/treatment-upload";

#endif /* HealthRecordMacro_h */

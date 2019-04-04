//
//  BaseUrlConstant.h
//  TYFitFore
//
//  Created by xuyang on 2017/11/24.
//  Copyright © 2017年 tangpeng. All rights reserved.
//

#ifndef BaseUrlConstant_h
#define BaseUrlConstant_h

#define kMakeErrorAndCode(errorMsg, errorCode) [[NSError alloc] initWithDomain:@"error message" code:errorCode userInfo:@{NSLocalizedDescriptionKey: errorMsg}]
//#define Basic_Authrization @"Basic Y29tLmljYXJib254LmlwaG9uZTp4SXI3YmQxOXVoTTVrNmxY=="
//没有登录时，错误代码
#define kNotLoginCode 1000
//加载视图的tag值
#define kLoadingViewTag 10001
#define kRegisterErrorCode -100                     //用户需要注册的状态码
#define kWechatBindErrorCode -200                   //用户微信和手机绑定的状态码
#define kForgetKeyInvalid -300                      //修改密码的key失效
//数据中心，没有添加数据时，错误码
#define kNoDataCode 5

//获取用户信息
static NSString *const TY_USERINFO_URL = @"https://mainapi.icarbonx.com/account-api/people/account";
//H5交互获取授权码接口
static NSString *const H5_WEBCODE_URL = @"https://api.icarbonx.com/auth/web-code/request";

#pragma mark - HOST
//域名
static NSString *const TY_DEBUG_HOST = @"https://mainapi.icarbonx.com/sport";
static NSString *const TY_MEMU_HOST = @"https://api.icarbonx.com";
static NSString *const TY_FITFORCE_HOST = @"https://mainapi.icarbonx.com";
//觅我账号信息host
static NSString *const TY_USER_HOST = @"https://api.icarbonx.com/oauth2";
//推送
static NSString *const TY_USER_PUSH = @"https://api.icarbonx.com/push";

#pragma mark - 用户信息
//用户 -- 登录、刷新token
static NSString *const TY_LOGINORREFRESH_TOKEN = @"/token";
//登录 -- 获取短信验证码
static NSString *const TY_USER_GETCODE = @"/sms_verify_code";
////用户 -- 获取他人头像  禁用,已废弃
//static NSString *const DOWNLOAD_OTHER_MEDIA_IMAGE = @"/media/user/";
//用户 -- 登录 -- 注册推送id
static NSString *const TY_USER_PUSHREGISTER = @"/registry";
//用户 -- 退出登录 -- 注销推送id
static NSString *const TY_USER_PUSHUNREGISTER = @"/unRegistry";
//验证码 -- 新接口
static NSString *const TY_USER_SENDCODE = @"/send_verify_code";
//找回密码 -- 校验验证码
static NSString *const TY_USER_FINDPASSWORD = @"/account/check_code";
//重置密码 -- 提交修改
static NSString *const TY_USER_RESET = @"/account/reset_password";
//登录 -- 微信授权
static NSString *const TY_WECHAT_LOGIN = @"/connect/wechat";
//个人中心 -- 修改用户账号
static NSString *const TY_USER_UPDATEACCOUNT = @"/account/update_username";
//个人中心 -- 用户微信绑定状态
static NSString *const TY_USER_WECHATSTATUS = @"/people/account";
//个人中心 -- 解除微信绑定
static NSString *const TY_USER_UNBINDWECHAT = @"/account/wechat/unbind";
//个人中心 -- 绑定微信
static NSString *const TY_USER_BINDWECHAT = @"/oauth/wechat/bind";
// 教练获得配置信息
static NSString *const SETTING_INFO = @"/setting";
//教练端，统计教练课时
static NSString *const COURSE_PERIOD = @"/coach/course/period";
//教练端，统计教练课时，并返回学员课时列表
static NSString *const COURSE_PERIOD_DETAIL = @"/coach/course/period/detail";

#pragma mark - 版本更新
//检查版本更新
static NSString *const SPORT_FITFORCE_VERSION = @"/version";
//版本升级
static NSString *const SPORT_FITFORCE_LATEST = @"/latest";

#pragma mark - 课程首页
//课程首页 -- 获取指定日期内每天的预约记录数
static NSString *const SPORT_COURSE_COUNT = @"/reserve/coach/count";
//课程首页 -- 查询指定日期的预约记录
static NSString *const SPORT_QUERY_APPOINTMENTRECORD = @"/reserve/coach/list";
//课程首页 -- 教练训练总览
static NSString *const SPORT_TRAINING_OVERVIEW = @"/coach/course/amount";
//课程首页 -- 通过预约id获取预约信息
static NSString *const SPORT_APPOINTMENT_DETAIL = @"/reserve/coach/one";

#pragma mark - 课程详情
//课程 -- 课程详情 -- 特色课
static NSString *const SPORT_COURSEDETAIL_SPECIAL = @"https://main.icarbonx.com/sporth5/#/specailDetail?courseCode=%@";
//课程 -- 课程详情 -- 团课
static NSString *const SPORT_COURSEDETAIL_GROUP = @"/coach/course/group/info";

#pragma mark - 学员
//搜索学员
static NSString *const STUDENT_SEARCH_LIST = @"/coach/search/student/by";
//添加学员
static NSString *const STUDENT_ADD = @"/push/to/student";
//学员列表
static NSString *const STUDENT_LIST = @"/coach/list/V19/students";
//查询指定时间段的预约以及邀约
static NSString *const STUDENT_ALL_BOOKED_TIME = @"/appointment/invitation/coach/query/"; 
//教练添加邀约
static NSString *const ASK_STUDENT = @"/appointment/invitation//coach/add/";
//获取学员信息
static NSString *const QUERY_STUDENT_INFO = @"/student/query/info";
//教练添加学员的备注
static NSString *const REMARK_STUDENT_NAME = @"/coach/add/note/";
//学员预约教练教练预约学生(教练帮学生约课)
static NSString *const REPLACE_BOOK_COURSE = @"/reserve/coach";
//查看指定学员指定日期所有预约信息
static NSString *const QUERY_STUDENT_APPOINTMENT_INFO = @"/reserve/coach/list";
//教练查看学员的会员卡（次卡）
static NSString *const STUDENT_MEMBERCARD_TIMES = @"/card/times/info";

#pragma mark - 排课
//排课 -- 排课页面 -- 教练动作是否有更新
static NSString *const SCHEDULE_ACTIONS_UPDATE = @"/coach/updateActions";
//排课 -- 排课页面 -- 获取所有的动作信息
//static NSString *const SCHEDULE_ACTIONS_ALL = @"/actions/coach";
static NSString *const SCHEDULE_ACTIONS_ALL = @"/actions/coach/actionList";
//排课 -- 排课页面 -- 获取所有的训练部位
static NSString *const SCHEDULE_TRAININGPARTS_ALL = @"/actions/bodyPart";
//排课 -- 排课页面 -- 获取指定时间内的课程信息
static NSString *const SCHEDULE_TRAININGCOURSE_ALL = @"/course/getStudentScheduleByCoach";
//排课 -- 排课页面 -- 提交训练方案(已废弃)
//static NSString *const SCHEDULE_SUBMITTRAININGPLAN = @"/course/submitStudentSchedule";
//排课 -- 排课页面 -- 提交课程
static NSString *const SCHEDULE_NEW_PLAN = @"/course/submit";
//排课 -- 排课页面 -- 修改课程
static NSString *const SCHEDULE_NEW_UPDATE = @"/course/update";

//排课 -- 排课首页 -- 获取学员列表
static NSString *const SCHEDULE_STUDENTLIST = @"/sessions/coach";
//排课 -- 排课首页 -- 获取预约学员列表
static NSString *const SCHEDULECOURSE_STUDENTLIST = @"/queryAllAppointmentByCoachPId";
//排课 -- 排课首页 -- 待办预约
static NSString *const SCHEDULE_UNCONFIRMED = @"/queryUnconfirmedAppointmentByCoachPId";
//排课 -- 排课首页 -- 待确认的总和,24小时内未制定方案的数量+17-15分钟内待上课的数量
static NSString *const SCHEDULE_COURSEBADGE = @"/appointmentCount";
//排课 -- 排课首页 -- 已完成的历史课程
static NSString *const SCHEDULE_HISTORYCOURSE = @"/finishedAppointmentRecord";
//排课 -- 排课首页 -- 同意或拒绝预约
static NSString *const SCHEDULE_AGREEORREFUSE = @"/coachDisposeAppointment";
//排课 -- 教练上课 -- 完成动作，提交反馈
static NSString *const ACTION_FEEDBACK = @"/practice/saveActionFeedback";
//排课 -- 新排课页面 -- 获取教练指定学员的预约课程时间
static NSString *const APPOINTMENT_ALL_TIME = @"/queryRangeAppointment";
//排课 -- 新排课页面 -- 根据课程id，获取排课方案
static NSString *const SCHEDULE_TRAININGPLAN_COURSEID = @"/course/getCourseScheduleByCourseId";
//排课 -- 新排课页面 -- 根据课程id，获取排课方案(参数是在path后面拼接)
static NSString *const SCHEDULE_NEW_COURSEPLAN = @"/practice/getCourse";
//排课 -- 待办课程列表 -- 判断预约课程的状态
static NSString *const SCHEDULE_APPOINTMENT_COURSESTATUS = @"/getAppointmentById";
//上课 -- 教练上课页面 -- 动作反馈 + 动作信息修改
static NSString *const ACTION_FEEDBACK_UPDATE = @"/practice/action/feedback";
//上课 -- 教练上课页面 -- 课程提前结束
static NSString *const COURSE_END = @"/practice/termination";
//上课 -- 教练上课完成 -- 评价课程
static NSString *const COURSE_COACH_COMMENT = @"/course/addCoachComment";
static NSString *const COURSE_COACH_EVALUATION = @"/evaluation/coach/evaluatestudent";
//上课 -- 教练上课页面 -- 检查已删除的动作
static NSString *const COURSE_CHECK_ACTION = @"/actions/removing";
//排课 -- 排课首页 -- 待办预约 (新增邀约信息)
static NSString *const SCHEDULE_UNCONFIRMED_EVENT = @"/appointment/coach/query/invitation/reserved";
//排课 -- 排课首页 -- 获取预约信息
static NSString *const APPOINTMENT_QUERY = @"/appointment/student/list";
//排课 -- 预排课 -- 教练给学员的预排课列表 scheduleInAdvance
static NSString *const SCHEDULE_COURSE_ADVANCE = @"/course/student";
//上课 -- 动作总览模式 -- 开始课程
static NSString *const COURSE_ALLACTION_START = @"/course/begin/training";
//上课 -- 动作总览模式 -- 结束课程
static NSString *const COURSE_ALLACTION_END = @"/course/finish/training";
//课程 -- 通过预约id查询课程信息
static NSString *const COURSE_INFO_CODE = @"/reserve/coach/one";
//课程 -- 历史 -- 学员评价列表
static NSString *const COURSE_HISTORY_STUDENTEVALUATION = @"/evaluation/coach";

#pragma mark - 历史
//课程 -- 历史 -- 邀约历史
static NSString *const COURSE_HISTORY_INVITATION = @"/appointment/invitation/coach/query";

#pragma mark - 数据中心
//数据中心 -- 首页 -- 获取用户所有数据
static NSString *const DATA_HOME_ALL = @"/accurateSportData/findAllNewestData";
//数据中心 -- 添加 -- 添加记录
static NSString *const DATA_ADD_RECORD = @"/accurateSportData/insertDataRecord";
//数据中心 -- 查询数据 -- 查询单项所有数据
static NSString *const DATA_FIND_ITEM = @"/accurateSportData/V32/findListById";
//数据中心 -- 删除数据 -- 删除单项数据的某条记录
static NSString *const DATA_DELETE_ITEM = @"/accurateSportData/deleteSingleRecord";
//基因报告 https://main.icarbonx.com/v2/#/Meum/Exercise/3122?studentId=1000000001005012
static NSString *const GENE_REPORT_URL = @"https://main.icarbonx.com/v2/#/Meum/Exercise/%ld?studentId=%ld&ad=2";//@"https://main.icarbonx.com/v2/#/report2/%zd";
//-----------新接口-----------
//数据中心 -- 查询 -- 查询某个时间段内的数据
static NSString *const DATA_QUERY_DURATION = @"/accurateSportData/V32/records/duration";
//数据中心 -- 查询 -- 按页数查询一组数据
static NSString *const DATA_QUERY_GROUPDATA = @"/accurateSportData/V32/items/line/chart";
//上传多项数据
static NSString *const USER_SMARTMIRROR_UPLOAD = @"/accurateSportData/evaluation/items";

#pragma mark - 调查问卷
static NSString *const TY_SURVEY_HOST = @"https://mainapi.icarbonx.com/survey";
//调查问卷的问题及选项
static NSString *const SURVEY_QUESTIONNAIRE = @"/surveyController/getSurveyAllInfoBySurveyId.do";
//获取用户调查问卷的版本号
static NSString *const SURVEY_GETVERSION = @"/surveyController/listUserState.do";
//获取用户填写的最新版本的问卷选项信息
static NSString *const SURVEY_OPTIONS = @"/survey/answers";
//新接口,问卷及其答案供教练使用
static NSString *const SURVEY_ANSWERS = @"/survey/show/answers/";

#pragma mark - 基因报告
//学员信息 -- 基因报告 -- 判断是否有基因报告
static NSString *const SCHEDULE_GENEREPORT_OWNER = @"https://mainapi.icarbonx.com/digital/v2/report/data/%ld?productPlan=Meum&reportType=Exercise";
//学员信息 -- 基因报告 -- 教练查看学员的基因报告如果存在适当关系
static NSString *const COACH_REVIEW_GENEREPORT = @"/coach/check/relation/%ld";
//学员信息 -- 基因报告 -- 查看个人基因报告是否已出
static NSString *const GENEREPORT_STATUS = @"/gene/report/status";
//学员信息 -- 基因报告、运动专项、运动处方 -- 教练查看学员的哪些数据项
static NSString *const COACH_AVAULABLE_VIEW = @"/student/show/labels";
//学员信息 -- 课程记录
static NSString *const STUDENT_INFO_RECORD = @"/course/query/gymnasium/course";
static NSString *const STUDENT_INFO_RECORDGROUP = @"/course/query/gymnasium/course/grouping/";
//学员信息 -- 最近一个月的课程记录
static NSString *const STUDENT_INFO_RECORDRECENTLY = @"/course/query/gymnasium/course/number/";

#pragma mark - 教练认证
//教练首次登陆设置名称
static NSString *const SAVE_COACH_NAME_FIRST = @"/coach/first/init/";
//教练首次登陆完善健身房信息
static NSString *const SAVE_COACH_INFO_FIRST = @"/coach/update/gym/info";
//申请成为教练
static NSString *const SAVE_COACH_INFO = @"/coach/saveCoachInfo";
//设置教练头像
static NSString *const UPDATE_COACH_PHOTO = @"/coach/saveOrUpdateCoachPhoto";
//审核后更新验证状态
static NSString *const UPDATE_VALIDATION_STATUS = @"/coach/updateValidationStatus";
//上传图片
static NSString *const UPLOAD_MEDIA_IMAGE = @"/media/image";
//下载图片(其他人的)
static NSString *const DOWNLOAD_MEDIA_IMAGE = @"/media/user/";
//下载图片(自己的)
static NSString *const DOWNLOAD_SELF_IMAGE = @"/media/";
//更新教练任一单项信息
static NSString *const UPDATE_COACH_ANYONE_ITEM = @"/coach/updateCoachAnyOneItem";
//获取教练资料
static NSString *const GET_COACH_SELF_INFO = @"/coach/getCoachSelfInfo";
//教练端获取申请资料
static NSString *const GET_COACH_AUTH_INFO = @"/coach/application/info";
//获取可选的健身房
static NSString *const GET_GYMNAMES = @"/coach/option/gymnasium";
//获取可选的健身房分店
static NSString *const GET_OPTION_GYMNAMES = @"/coach/option/office/";

#pragma mark - 我的健身房
//获取教练工作的所有健身房信息
static NSString *const COACH_ALL_GYMS = @"/coach/work/gymnasium/v22";
//获取教练工作的指定健身房信息
static NSString *const COACH_ONE_GYM = @"/coach/work/gymnasium/";
//设置教练所在健身房的工作时间段
static NSString *const COACH_WORKTIME = @"/coach/work/time/";
//获取教练所在健身房当天的休假,请假,已预约等信息
static NSString *const COACH_ALL_LEAVETIME = @"/reserve/coach/busyness/time";
//设置教练所在健身房的请假时间段
static NSString *const COACH_LEAVETIME = @"/coach/leave/time/";
//根据日期月份获取本月休假时间
static NSString *const COACH_VOCATION_MONTH = @"/coach/vocation/month/";
//设置教练所在健身房的休假时间段
static NSString *const COACH_VOCATION_TIME = @"/coach/vocation/time/";

#pragma mark - 反馈
//添加反馈记录
static NSString *const USER_FEEDBACK = @"/feedback/insertFeedback";
//上传日志链接
static NSString *const USER_UPLOAD_LOG = @"/log/access/url";

#pragma mark - 动作库
//获取来自标准动作库的所有动作
static NSString *const ACTION_LIBRARY_ALL = @"/actions/standard/search";
//保存来自标准动作库对应的所有动作数据
static NSString *const SUBMIT_ACTIONS = @"/actions/coach";
//获取教练动作库所有数据或根据条件查询,默认第一页,每页20条
static NSString *const GET_COACH_ACTIONS = @"/actions/search";
//删除教练动作库对应的动作数据
static NSString *const DELETE_COACH_ACTION = @"/actions/";
//保存教练新添加的动作到待审核库
static NSString *const ADD_COACH_ACTION = @"/actions/coach/new";
//修改教练动作库对应的动作数据
static NSString *const UPDATE_COACH_ACTION = @"/actions/coach/update";

//************客户端自定义错误码*******************

/** 普通失败错误码 */
#define GJNotErrorCode       (-2016)
/** 没有网络时默认错误码 (客户端定义)*/
#define GJNoInterneErrorCode (-2015)

//************ 服务端返回错误码 *************************

#define Code_AgainLoginThree  (30003)//异常重新登录(无效Cookie)
#define Code_AgainLoginFour   (30004)//异常重新登录(请求错误需要重新登录)
#define Code_AgainLoginsFifth (30005)//异常重新登录
#define Code_ShopUExist       (50001)//商铺id不存在(请求错误需要重新登录) <警告:正式打包要干掉50001错误码的判断>

//************ 客户端自定义错误提示语 ********************

#define NetworkConnectFail          @"网络连接失败,请检查网络"
#define ServerConnectFail           @"程序小哥出小差，请稍后再试"
#define RequestTimeOut              @"请求超时，请稍后再试"
#define Dataparsingerror            @"服务器内部错误"

#define HasSameShopNameError        @"该帐号已存在同名商铺"

#endif /* BaseUrlConstant_h */

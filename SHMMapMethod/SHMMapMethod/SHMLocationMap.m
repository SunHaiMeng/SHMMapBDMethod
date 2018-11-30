//
//  SHMLocationMap.m
//  MinSu
//
//  Created by apple on 2018/8/21.
//  Copyright © 2018年 GXT. All rights reserved.
//

#import "SHMLocationMap.h"
//#import "terminus.h"
//
//#import "MSLoginSetting.h"


static SHMLocationMap* instance;

@interface SHMLocationMap()
//<CLLocationManagerDelegate>
{
//    CLLocationManager *locManager;
//    BOOL bIsUpLoading;
//    CLLocationCoordinate2D lastCoor;
//
//    void(^callback_)(bool);
}
@end
@implementation SHMLocationMap
#pragma mark - 公共接口
//-(void)getLocation:(void(^)(double,double,NSError *))callback
//{
//    if(bIsUpLoading)
//    {
//        NSDictionary* testdic = BMKConvertBaiduCoorFrom(lastCoor,BMK_COORDTYPE_GPS);
//        CLLocationCoordinate2D co=BMKCoorDictionaryDecode(testdic);
//        
//        
//        NSLog(@"x=%f,y=%f",co.latitude,co.longitude);
//        
//        
//        // [self sendLocation:co.latitude longitude:co.longitude];
//        callback(co.longitude,co.latitude,nil);
//    }
//    else
//        callback(0,0,[NSError errorWithDomain:@"com.gtzt.terminus" code:-1 userInfo:nil]);
//}
//+(instancetype)defaultManager
//{
//    static dispatch_once_t t;
//    dispatch_once(&t, ^{
//        instance = [[SHMLocationMap alloc] init];
//    });
//    return instance;
//}
//
//-(void)startUploadLocation:(void(^)(bool))callback;
//{
//    dispatch_async(dispatch_get_main_queue(), ^{
//        
//        if([CLLocationManager authorizationStatus]==kCLAuthorizationStatusDenied)
//        {
//            NSLog(@"auth denied!");
//            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"已屏蔽定位功能，请到系统设置中开启。" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
//            [alert show];
//            callback(NO);
//        }
//        else if([CLLocationManager authorizationStatus]==kCLAuthorizationStatusNotDetermined)
//        {
//            callback_=callback;
//            if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
//                [locManager requestAlwaysAuthorization];
//        }
//        else
//        {
//            [locManager startUpdatingLocation];
//            
//            bIsUpLoading=YES;
//        }
//        
//    });
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [self getLocation:^(double longitude, double latitude, NSError *err) {
//            if(err==nil)
//            {
//                [self locationRequstLocation:latitude longitude:longitude];
////                [self sendLocation:latitude longitude:longitude];
//            }
//        }];
//    });
//}
//-(void)stopUploadLocation
//{
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [locManager stopUpdatingLocation];
//        bIsUpLoading=NO;
//    });
//}
//-(BOOL)isUploadingLocation
//{
//    return bIsUpLoading;
//}
//#pragma mark - 私有接口
//-(instancetype)init
//{
//    self = [super init];
//    if(self)
//    {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            locManager = [[CLLocationManager alloc] init] ;
//            locManager.delegate = self;
//            
//            if ([CLLocationManager locationServicesEnabled]) {
//                // 创建位置管理者对象
//                locManager = [[CLLocationManager alloc] init];
//                locManager.delegate = self; // 设置代理
//                // 设置定位距离过滤参数 (当本次定位和上次定位之间的距离大于或等于这个值时，调用代理方法)
//                locManager.distanceFilter = 10;
//                //locManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;//导航级别的精确度
////                locManager.allowsBackgroundLocationUpdates = YES; //允许后台刷新
//                //locManager.pausesLocationUpdatesAutomatically = NO; //不允许自动暂停刷新
//                //locManager.distanceFilter = kCLDistanceFilterNone;  //不需要移动都可以刷新
//                //locManager.desiredAccuracy = kCLLocationAccuracyBest; // 设置定位精度(精度越高越耗电)
//                //[self.lcManager startUpdatingLocation]; // 开始更新位置
//            }
//            
//            bIsUpLoading = NO;
//        });
//        
//    }
//    return self;
//}
///***********
// *@计算距离
// *****************/
//
//-(float)getDistanceBetweenTwoPont:(CLLocationCoordinate2D)fristCoor secondCoor:(CLLocationCoordinate2D)secondCoor
//{
//    NSDictionary* testdic = BMKConvertBaiduCoorFrom(fristCoor,BMK_COORDTYPE_GPS);
//    CLLocationCoordinate2D fisrtBMKCoor =BMKCoorDictionaryDecode(testdic);
//    
//    NSDictionary* testdic2 = BMKConvertBaiduCoorFrom(secondCoor,BMK_COORDTYPE_GPS);
//    CLLocationCoordinate2D secondBMKCoor =BMKCoorDictionaryDecode(testdic2);
//    
//    BMKMapPoint point1 = BMKMapPointForCoordinate(fisrtBMKCoor);
//    BMKMapPoint point2 = BMKMapPointForCoordinate(secondBMKCoor);
//    
//    float distance =      BMKMetersBetweenMapPoints(point1,point2);
//    
//    NSLog(@"*******%f*******",distance);
//    
//    return distance;
//}
////-(void)sendLocation:(float)latitude longitude:(float)longitude
////{
////    // LocationMessage *LM=
////    [[Terminus sharedInstance] sendLocation:latitude longitude:longitude];
////}
//
//#pragma mark - delegate
///**************
// *@
// *************/
//- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation
//
//           fromLocation:(CLLocation *)oldLocation {
//    
//    
//    if([self getDistanceBetweenTwoPont:lastCoor secondCoor:newLocation.coordinate] < 30.0)
//        return;
//    
//    NSLog(@"last.x = %f,last.y = %f",lastCoor.latitude,lastCoor.longitude);
//    
//    lastCoor = newLocation.coordinate;
//    NSLog(@"newLocation.x = %f,newLocation.y = %f",newLocation.coordinate.latitude,newLocation.coordinate.longitude);
//    
//    //CLLocationCoordinate2D test = CLLocationCoordinate2DMake(39.90868, 116.3956);
//    //转换 google地图、soso地图、aliyun地图、mapabc地图和amap地图所用坐标至百度坐标
//    NSDictionary* testdic = BMKConvertBaiduCoorFrom(newLocation.coordinate,BMK_COORDTYPE_GPS);
//    CLLocationCoordinate2D co=BMKCoorDictionaryDecode(testdic);
//    
//    
//    NSLog(@"x=%f,y=%f",co.latitude,co.longitude);
//    
//    [self locationRequstLocation:co.latitude longitude:co.longitude];
////    [self sendLocation:co.latitude longitude:co.longitude];
//    
//    
//}
//
///** 不能获取位置信息时调用*/
//-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
//{
//    NSLog(@"获取定位失败:%@",error.localizedDescription);
//}
//
////-locationManager:didChangeAuthorizationStatus
//-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
//{
//    if(status==kCLAuthorizationStatusDenied)
//    {
//        if(callback_)
//            callback_(NO);
//    }
//}
//-(void)locationRequstLocation:(double)latitude longitude:(double)longitude{
////    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
////    NSString *lng = [NSString stringWithFormat:@"%f",longitude];
////    NSString *lat = [NSString stringWithFormat:@"%f",latitude];
//    NSDictionary *ditM = [self bdMapSwitchggMap:latitude mapLong:longitude];
//    NSString * lo = [ditM objectForKey:@"log"];
//    NSString * la = [ditM objectForKey:@"lat"];
//    NSString * time = [MSTimeDate currentTimeStr];
//    NSString *uuid = [MSLoginSetting getUserId];
//    NSDictionary *newParams=@{@"timestamp":time,
//                              @"lng":lo,
//                              @"lat":la,
//                              @"uuid":uuid
//                              };
//    NSString *sign = [lockSign crrateSign:newParams];
//    NSDictionary *params=@{@"timestamp":time,
//                           @"lng":lo,
//                           @"lat":la,
//                           @"uuid":uuid,
//                           @"sign":sign
//                           };
//    NSString *url = [NSString stringWithFormat:@"%s/locker/geo/save",URLHEAD];
//    [[AFNetWorkHttps setHttpsMange] POST:url parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
//        
//    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers|NSJSONReadingMutableLeaves error:nil];
//        BOOL success = [[dict objectForKey:@"success"] boolValue];
//        if (success)
//        {
//            
//        }else{
//            
//        }
//        
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        
//    }];
//
//}
////百度转腾讯坐标  BD-09（百度地图）转 GCJ-02(火星)
//-(NSDictionary *)bdMapSwitchggMap:(double )bd_lat mapLong:(double)bd_lon{
//    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
//
//    double x_pi=3.14159265358979324;
//    double x = bd_lon  - 0.0065, y = bd_lat  - 0.006;
//    double z = sqrt(x * x + y * y) - 0.00002 * sin(y * x_pi);
//    double theta = atan2(y, x) - 0.000003 * cos(x * x_pi);
//    NSNumber * gg_lon = [NSNumber numberWithDouble:z * cos(theta)];
//    NSNumber * gg_lat = [NSNumber numberWithDouble:z * sin(theta)];
//    NSString *gg_lo = [gg_lon stringValue];
//    NSString *gg_la = [gg_lat stringValue];
//    [dict setValue:gg_la forKey:@"lat"];
//    [dict setValue:gg_lo forKey:@"log"];
//    return  dict;
//}
@end

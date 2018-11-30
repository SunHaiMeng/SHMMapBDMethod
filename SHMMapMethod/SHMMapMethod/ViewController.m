//
//  ViewController.m
//  SHMMapMethod
//
//  Created by apple on 2018/11/29.
//  Copyright © 2018年 GXT. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}
//**********************本章节写的是百度地图的功能封装 *******************方法一：以某点为中心并放大固定倍数 方法二：以某点为中心画圆、两点之间联系连线折现 方法三：路径规划 方法四：封装大头针 方法五：气泡 方法六：移动100（可修改）米上传坐标位置 计算两个坐标的h距离

/*
    方法一：以某点为中心并放大固定倍数
    clLocationCoordinate2DE.latitude = [_orderInfor.lat doubleValue];
    clLocationCoordinate2DE.longitude = [_orderInfor.log doubleValue];
    BMKPointAnnotation *annotation = [[BMKPointAnnotation alloc] init];
    annotation.coordinate = clLocationCoordinate2DE;
    [_mapView addAnnotation:annotation];
    BMKCoordinateRegion region ;//表示范围的结构体
    region.center = clLocationCoordinate2DE;//中心点
    region.span.latitudeDelta = 0.1;//经度范围（设置为0.1表示显示范围为0.2的纬度范围）
    region.span.longitudeDelta = 0.1;//纬度范围
    [_mapView setRegion:region animated:YES];
    _mapView.zoomLevel = 13;

 
 方法二：以某点为中心画圆、两点之间联系连线折现
    radius：半径大小
    BMKCircle* circle = [BMKCircle circleWithCenterCoordinate:clLocationCoordinate2DE radius:100];
    [_mapView addOverlay:circle];
 
    // 通过points构建BMKPolyline xh折线（下面路径规划时有示例）
    BMKPolyline* polyLine = [BMKPolyline polylineWithPoints:temppoints count:planPointCounts];
    [_mapView addOverlay:polyLine];
 
 
 
    百度地图画圆、折线触发发的方法，可以改变圆的颜色等属性
    - (BMKOverlayView*)mapView:(BMKMapView *)map viewForOverlay:(id<BMKOverlay>)overlay
    {
    if ([overlay isKindOfClass:[BMKPolyline class]]) {
    BMKPolylineView* polylineView = [[BMKPolylineView alloc] initWithOverlay:overlay];
    polylineView.fillColor = [[UIColor alloc] initWithRed:0 green:1 blue:1 alpha:1];
    polylineView.strokeColor = [[UIColor alloc] initWithRed:105/255.0 green:222/255.0 blue:66/255.0 alpha:0.9];
    polylineView.lineWidth = 5.0;
    return polylineView;
    }
    if ([overlay isKindOfClass:[BMKCircle class]]){
    BMKCircleView* circleView = [[BMKCircleView alloc] initWithOverlay:overlay];
    circleView.fillColor = [UIBackColor colorWithAlphaComponent:0.5];
    circleView.lineWidth = 0.0;

    return circleView;
    }
    return nil;
    }

方法三：路径规划
 调用此方法
     -(void)creatDrivingUI{
     locationS = YES;
     BMKPlanNode* start = [[BMKPlanNode alloc]init];
     start.pt = clLocationCoordinate2DS;
 
     BMKPlanNode* end = [[BMKPlanNode alloc]init];
     end.pt = clLocationCoordinate2DE;
 
     BMKDrivingRoutePlanOption *drivingRouteSearchOption = [[BMKDrivingRoutePlanOption alloc]init];
     drivingRouteSearchOption.from = start;
     drivingRouteSearchOption.to = end;
     drivingRouteSearchOption.drivingRequestTrafficType = BMK_DRIVING_REQUEST_TRAFFICE_TYPE_NONE;//不获取路况信息
     BOOL flag = [_routesearch drivingSearch:drivingRouteSearchOption];
     _mapView.userTrackingMode = BMKUserTrackingModeNone;//设置定位的状态为定位跟随
     _mapView.showsUserLocation = YES;//显示定位图层
     if(flag)
     {
     NSLog(@"car检索发送成功");
     }
     else
     {
     NSLog(@"car检索发送失败");
     }
     }
 触发下面方法
    #pragma mark - BMKRouteSearchDelegate  百度框架有这个协议
    - (void)onGetDrivingRouteResult:(BMKRouteSearch*)searcher result:(BMKDrivingRouteResult*)result errorCode:(BMKSearchErrorCode)error
    {
    NSLog(@"onGetDrivingRouteResult error:%d", (int)error);
    NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
    [_mapView removeAnnotations:array];
    array = [NSArray arrayWithArray:_mapView.overlays];
    [_mapView removeOverlays:array];
    if (error == BMK_SEARCH_NO_ERROR) {
    BMKDrivingRouteLine* plan = (BMKDrivingRouteLine*)[result.routes objectAtIndex:0];
    // 计算路线方案中的路段数目
    NSInteger size = [plan.steps count];
    int planPointCounts = 0;
    for (int i = 0; i < size; i++) {
    BMKDrivingStep* transitStep = [plan.steps objectAtIndex:i];
    if(i==0){
 //方法四有解释
    RouteAnnotation* item = [[RouteAnnotation alloc]init];
    item.coordinate = plan.starting.location;
    item.title = @"起点";
    item.type = 0;
    [_mapView addAnnotation:item]; // 添加起点标注

    }
    if(i==size-1){
    RouteAnnotation* item = [[RouteAnnotation alloc]init];
    item.coordinate = plan.terminal.location;
    item.title = @"终点";
    item.type = 1;
    [_mapView addAnnotation:item]; // 添加起点标注
    }
    //添加annotation节点
    RouteAnnotation* item = [[RouteAnnotation alloc]init];
    item.coordinate = transitStep.entrace.location;
    item.title = transitStep.entraceInstruction;
    item.degree = transitStep.direction * 30;
    item.type = 4;
    [_mapView addAnnotation:item];

    NSLog(@"%@   %@    %@", transitStep.entraceInstruction, transitStep.exitInstruction, transitStep.instruction);

    //轨迹点总数累计
    planPointCounts += transitStep.pointsCount;
    }
    //轨迹点
    BMKMapPoint * temppoints = new BMKMapPoint[planPointCounts];
    int i = 0;
    for (int j = 0; j < size; j++) {
    BMKDrivingStep* transitStep = [plan.steps objectAtIndex:j];
    int k=0;
    for(k=0;k<transitStep.pointsCount;k++) {
    temppoints[i].x = transitStep.points[k].x;
    temppoints[i].y = transitStep.points[k].y;
    i++;
    }

    }
    // 通过points构建BMKPolyline
    BMKPolyline* polyLine = [BMKPolyline polylineWithPoints:temppoints count:planPointCounts];
    [_mapView addOverlay:polyLine]; // 添加路线overlay
    BMKCircle* circle = [BMKCircle circleWithCenterCoordinate:clLocationCoordinate2DE radius:100];
    [_mapView addOverlay:circle];
    delete []temppoints;
    [self mapViewFitPolyLine:polyLine];
    }else if (error == BMK_SEARCH_AMBIGUOUS_ROURE_ADDR) {
    [self resetSearch:result.suggestAddrResult];
    }else{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"网络不可用，不能绘画路径。" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert show];
    }
    }
 
 
    #pragma mark - 私有

    //根据polyline设置地图范围
    - (void)mapViewFitPolyLine:(BMKPolyline *) polyLine {
    CGFloat leftTopX, leftTopY, rightBottomX, rightBottomY;
    if (polyLine.pointCount < 1) {
    return;
    }
    BMKMapPoint pt = polyLine.points[0];
    // 左上角顶点
    leftTopX = pt.x;
    leftTopY = pt.y;
    // 右下角顶点
    rightBottomX = pt.x;
    rightBottomY = pt.y;
    for (int i = 1; i < polyLine.pointCount; i++) {
    BMKMapPoint pt = polyLine.points[i];
    leftTopX = pt.x < leftTopX ? pt.x : leftTopX;
    leftTopY = pt.y < leftTopY ? pt.y : leftTopY;
    rightBottomX = pt.x > rightBottomX ? pt.x : rightBottomX;
    rightBottomY = pt.y > rightBottomY ? pt.y : rightBottomY;
    }
    BMKMapRect rect;
    rect.origin = BMKMapPointMake(leftTopX, leftTopY);
    rect.size = BMKMapSizeMake(rightBottomX - leftTopX, rightBottomY - leftTopY);
    UIEdgeInsets padding = UIEdgeInsetsMake(30, 0, 100, 0);
    BMKMapRect fitRect = [_mapView mapRectThatFits:rect edgePadding:padding];
    [_mapView setVisibleMapRect:fitRect];
    }

    //输入的起终点有歧义，取返回poilist其他点重新发起检索
    - (void)resetSearch:(BMKSuggestAddrInfo*)suggestInfo {
    NSString *startAddrTextEr;
    NSString *endAddrTextEr;
    if (suggestInfo.startPoiList.count > 0) {
    BMKPoiInfo *starPoi = [[BMKPoiInfo alloc] init];
    starPoi = suggestInfo.startPoiList[1];
    startAddrTextEr = starPoi.name;
    }
    if (suggestInfo.endPoiList.count > 0) {
    BMKPoiInfo *endPoi = [[BMKPoiInfo alloc] init];
    endPoi = suggestInfo.endPoiList[1];
    endAddrTextEr = endPoi.name;
    }
    NSString *showWar = [NSString stringWithFormat:@"输入的起终点(%@,%@)有歧义，取返回poilist其他点重新发起检索",startAddrTextEr,endAddrTextEr];
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:showWar delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert show];
    }
方法四：封装大头针
    RouteAnnotation* item = [[RouteAnnotation alloc]init];
    item.coordinate = plan.starting.location;
    item.title = @"起点";
    item.type = 0;
    [_mapView addAnnotation:item]; // 添加起点标注
 触发方法
     - (BMKAnnotationView *)mapView:(BMKMapView *)view viewForAnnotation:(id <BMKAnnotation>)annotation
     {
     if ([annotation isKindOfClass:[RouteAnnotation class]]) {
     return [(RouteAnnotation*)annotation getRouteAnnotationView:view];
     }
     return nil;
     }
 方法五：气泡
    //添加大头针
    -(void)addAnnotation{

    NSMutableArray *annotations = [[NSMutableArray alloc]init];

    for (NSDictionary * textDic in lockAnnota) {
    SHMpopTextAnnotation *annotation = [[SHMpopTextAnnotation alloc]init];
    CLLocationCoordinate2D coor;
    NSDictionary *map = [self ggMapSwitchbdMap:[textDic objectForKey:@"lat"] mapLong:[textDic objectForKey:@"lng"]];
    coor.latitude = [[map objectForKey:@"lat"] doubleValue];
    coor.longitude = [[map objectForKey:@"log"] doubleValue];
    annotation.coordinate = coor;
    annotation.title = @"lock";
    NSString *an_money;
    if([[textDic objectForKey:@"statisticalPayAmount"]class]==[NSNull class]){
    an_money = @"0";
    }else{
    an_money = [textDic objectForKey:@"statisticalPayAmount"];
    }
    annotation.money = [NSString stringWithFormat:@"%@元",@([an_money floatValue]/100)];
    annotation.orderNum = [NSString stringWithFormat:@"%@单",[[textDic objectForKey:@"statisticalOrder"]class]==[NSNull class]?@"0":[textDic objectForKey:@"statisticalOrder"]];
    annotation.name = [NSString stringWithFormat:@"%@",[[textDic objectForKey:@"name"]class]==[NSNull class]?@"暂无":[textDic objectForKey:@"name"]];
    [annotations addObject:annotation];
    }

    SHMpopTextAnnotation *annotation0 = [[SHMpopTextAnnotation alloc]init];
    CLLocationCoordinate2D coor0;
    NSDictionary *mapc = [self ggMapSwitchbdMap:[companyAnnota objectForKey:@"latitude"] mapLong:[companyAnnota objectForKey:@"longitude"]];
    coor0.latitude = [[mapc objectForKey:@"lat"] doubleValue];
    coor0.longitude = [[mapc objectForKey:@"log"] doubleValue];
    annotation0.coordinate = coor0;
    annotation0.title = @"company";
    annotation0.name = [NSString stringWithFormat:@"%@",[[companyAnnota objectForKey:@"fullName"]class]==[NSNull class]?@"无名":[companyAnnota objectForKey:@"fullName"]];
    [annotations addObject:annotation0];

    [_mapView addAnnotations:annotations];
    //    设置地图使显示区域显示所有annotations
    [_mapView showAnnotations:annotations animated:YES];



    }
 
 
    - (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
    {
    if ([annotation isKindOfClass:[BMKPointAnnotation class]])
    {
    SHMpopTextAnnotation* ff = (SHMpopTextAnnotation*)annotation;
    NSLog(@"******%@***********",ff.title);
    NSLog(@"******%@***********",ff.subtitle);

    BMKPinAnnotationView *newAnnotationView ;

    static NSString* lockAnnotationId = @"lock";
    newAnnotationView = (BMKPinAnnotationView*)[_mapView dequeueReusableAnnotationViewWithIdentifier:lockAnnotationId];
    newAnnotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:lockAnnotationId];
    if([annotation.title isEqualToString:@"lock"]) 好友位置location
    {
    newAnnotationView.image = [UIImage imageNamed:@"icon_unlocker_d"];
    UIView *popView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 150,60)];
    popView.backgroundColor = [UIColor clearColor];

    UIImageView* showImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0, 150,80)];
    showImageView.image = [UIImage imageNamed:@"bg_img_qp"];
    [popView addSubview:showImageView];
    UILabel* nameLabel0 = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 80,20)];
    nameLabel0.text = @"今日流水：";
    nameLabel0.textColor = [UIColor whiteColor];
    nameLabel0.layer.cornerRadius = 6;
    nameLabel0.layer.masksToBounds = YES;
    nameLabel0.font = [UIFont systemFontOfSize:14.0];
    nameLabel0.textAlignment = NSTextAlignmentCenter;
    [showImageView addSubview:nameLabel0];
    UILabel* nameLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(5, 28, 80,20)];
    nameLabel1.text = @"今日接单：";
    nameLabel1.textColor = [UIColor whiteColor];
    nameLabel1.layer.cornerRadius = 6;
    nameLabel1.layer.masksToBounds = YES;
    nameLabel1.font = [UIFont systemFontOfSize:14.0];
    nameLabel1.textAlignment = NSTextAlignmentCenter;
    [showImageView addSubview:nameLabel1];
    UILabel* nameLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(5, 51, 80,20)];
    nameLabel2.text = @"锁匠姓名：";
    nameLabel2.textColor = [UIColor whiteColor];
    nameLabel2.layer.cornerRadius = 6;
    nameLabel2.layer.masksToBounds = YES;
    nameLabel2.font = [UIFont systemFontOfSize:14.0];
    nameLabel2.textAlignment = NSTextAlignmentCenter;
    [showImageView addSubview:nameLabel2];

    UILabel* moneyL = [[UILabel alloc] initWithFrame:CGRectMake(85, 5, 60,20)];
    moneyL.text = ff.money;
    moneyL.textColor = [UIColor whiteColor];
    moneyL.layer.cornerRadius = 6;
    moneyL.layer.masksToBounds = YES;
    moneyL.font = [UIFont systemFontOfSize:14.0];
    moneyL.textAlignment = NSTextAlignmentCenter;
    [showImageView addSubview:moneyL];
    UILabel* orderNL = [[UILabel alloc] initWithFrame:CGRectMake(85, 28, 60,20)];
    orderNL.text = ff.orderNum;
    orderNL.textColor = [UIColor whiteColor];
    orderNL.layer.cornerRadius = 6;
    orderNL.layer.masksToBounds = YES;
    orderNL.font = [UIFont systemFontOfSize:14.0];
    orderNL.textAlignment = NSTextAlignmentCenter;
    [showImageView addSubview:orderNL];
    UILabel* nameNL = [[UILabel alloc] initWithFrame:CGRectMake(85, 51, 60,20)];
    nameNL.text = ff.name;
    nameNL.textColor = [UIColor whiteColor];
    nameNL.layer.cornerRadius = 6;
    nameNL.layer.masksToBounds = YES;
    nameNL.font = [UIFont systemFontOfSize:14.0];
    nameNL.textAlignment = NSTextAlignmentCenter;
    [showImageView addSubview:nameNL];

    BMKActionPaopaoView *pView = [[BMKActionPaopaoView alloc]initWithCustomView:popView];
    pView.frame = CGRectMake(0, 0, 150, 80);
    newAnnotationView.paopaoView = pView;
    newAnnotationView.annotation = annotation;
    }else{
    newAnnotationView.image = [UIImage imageNamed:@"icon_map_dw"];
    UIView *popView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 220,60)];
    popView.backgroundColor = [UIColor clearColor];

    UIImageView* showImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0, 220,40)];
    showImageView.image = [UIImage imageNamed:@"bg_img_qp"];
    [popView addSubview:showImageView];


    UILabel* nameL = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 220,40)];
    nameL.text = ff.name;
    nameL.textColor = [UIColor whiteColor];
    nameL.layer.cornerRadius = 6;
    nameL.layer.masksToBounds = YES;
    nameL.font = [UIFont systemFontOfSize:14.0];
    nameL.textAlignment = NSTextAlignmentCenter;
    [showImageView addSubview:nameL];

    BMKActionPaopaoView *pView = [[BMKActionPaopaoView alloc]initWithCustomView:popView];
    pView.frame = CGRectMake(0, 0, 220, 40);
    newAnnotationView.paopaoView = pView;
    newAnnotationView.annotation = annotation;
    }

    newAnnotationView.canShowCallout = YES;
    newAnnotationView.animatesDrop = YES; 设置该标注点动画显示
    return newAnnotationView;
    }

    return nil;
    }
 
方法六：移动100（可修改）米上传坐标位置 计算两个坐标的h距离
 SHMMLocationMap
 
 
*/

@end

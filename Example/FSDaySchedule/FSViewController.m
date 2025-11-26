//
//  FSViewController.m
//  FSDaySchedule
//
//  Created by liaoyu on 2025/11/26.
//

#import "FSViewController.h"
#import <FSDaySchedule-Swift.h>
#import "NSDate+MKObjcSugar.h"

#define WIDTH  [UIScreen mainScreen].bounds.size.width
#define HEIGHT [UIScreen mainScreen].bounds.size.height

@interface FSViewController ()<FSDayScheduleViewDelegateObjc>

@property (nonatomic, copy) NSString *dayScheduleYMD;

@property (nonatomic, strong) FSDayScheduleView *daySchedule;

@property (nonatomic, strong) NSMutableArray<ScheduleObjcModel *> *models;

@end

@implementation FSViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"--- viewDidLoad ---");
    _models = [NSMutableArray new];
    _dayScheduleYMD = [NSDate mk_date:[NSDate date] format:@"yyyy-MM-dd"];
    
    FSDayScheduleView *daySchedule = [[FSDayScheduleView alloc] initWithFrame:CGRectMake(0, 100, WIDTH, HEIGHT - 160)];
    daySchedule.delegateObjc = self;
    daySchedule.datasourceObjc = _models;
    [self.view addSubview:daySchedule];
    self.daySchedule = daySchedule;
    
    // Do any additional setup after loading the view.
}

#pragma FSDayScheduleViewDelegateObjc
- (void)dayScheduleView:(FSDayScheduleView *)dayScheduleView willEditItem:(ScheduleObjcModel *)model {

}

- (void)dayScheduleViewWithStartStr:(NSString *)startStr endStr:(NSString *)endStr {
    NSString *start = [NSString stringWithFormat:@"%@ %@",_dayScheduleYMD,startStr];
    NSString *end = [NSString stringWithFormat:@"%@ %@",_dayScheduleYMD,endStr];
    //
    ScheduleObjcModel *model = [ScheduleObjcModel new];
    model.id = random() % 100000000;
    model.sId = [NSString stringWithFormat:@"%ld", random() / 10000];
    model.name = @"schedule title";
    model.start = [NSDate mk_formatDaySchedule:start ymd:self.dayScheduleYMD isStart:YES];
    model.end = [NSDate mk_formatDaySchedule:end ymd:self.dayScheduleYMD isStart:NO];
    [_models addObject:model];
    self.daySchedule.datasourceObjc = _models;
}

- (void)dayScheduleView:(FSDayScheduleView *)dayScheduleView didSelectItem:(ScheduleObjcModel *)model {
    
}

- (void)dayScheduleView:(FSDayScheduleView *)dayScheduleView editItem:(ScheduleObjcModel *)model {
    self.daySchedule.datasourceObjc = _models;
    ScheduleObjcModel *sModel = [self findModelByModel:model];
    if (!sModel) { return; }
    sModel.start = model.start;
    sModel.startStr = model.startStr;
    sModel.end = model.end;
    sModel.endStr = model.endStr;
    self.daySchedule.datasourceObjc = _models;
}

//-------------------------------------------------------------------------------------------------------------//
- (ScheduleObjcModel *)findModelByModel:(ScheduleObjcModel *)model {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"id == %ld", (long)model.id];
    NSArray *filtered = [self.models filteredArrayUsingPredicate:predicate];
    return filtered.firstObject;
}


@end


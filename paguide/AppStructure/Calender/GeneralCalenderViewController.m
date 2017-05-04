//
//  GeneralCalenderViewController.m
//  paguide
//
//  Created by Evan Beh on 03/05/2017.
//  Copyright © 2017 Evan Beh. All rights reserved.
//

#import "GeneralCalenderViewController.h"
#import <JTCalendar/JTCalendar.h>

@interface GeneralCalenderViewController () <JTCalendarDelegate>
{
    NSMutableDictionary *_eventsByDate;
    
    NSDate *_dateSelected;
    
    NSDate *_minDate;
    
    NSDate *_maxDate;
    
    NSDate *_todayDate;

}
@property (weak, nonatomic) IBOutlet JTCalendarMenuView *calendarMenuView;
@property (weak, nonatomic) IBOutlet JTHorizontalCalendarView *calendarContentView;
@property (nonatomic) JTCalendarManager *calendarManager;
@property (weak, nonatomic) IBOutlet UIButton *btnContinue;

@end

@implementation GeneralCalenderViewController
- (IBAction)btnBackClicked:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)btnContinueClicked:(id)sender {
    
    if (self.didContinueWithDateBlock) {
                
        self.didContinueWithDateBlock(_dateSelected);
    }
}


-(void)setupDateSelected:(NSDate*)date
{
    _dateSelected = date;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initSelfView];
    
    _calendarManager = [JTCalendarManager new];
    _calendarManager.delegate = self;
    
    [self createMinAndMaxDate];
    
    _calendarMenuView.contentRatio = .75;
    _calendarManager.settings.weekDayFormat = JTCalendarWeekDayFormatSingle;
    
    [_calendarManager setMenuView:_calendarMenuView];
    [_calendarManager setContentView:_calendarContentView];
    
    
    if (_dateSelected) {
        [_calendarManager setDate:_dateSelected];

    }
    else{
        [_calendarManager setDate:[NSDate date]];

    }
}

-(void)initSelfView
{
    [Utils setRoundBorder:self.btnContinue color:[UIColor clearColor] borderRadius:5.0f];
}



// Exemple of implementation of prepareDayView method
// Used to customize the appearance of dayView
- (void)calendar:(JTCalendarManager *)calendar prepareDayView:(JTCalendarDayView *)dayView
{
    dayView.hidden = NO;
    
    // Other month
    if([dayView isFromAnotherMonth]){
        dayView.hidden = YES;
    }
    //    // Today
    //    else if([_calendarManager.dateHelper date:[NSDate date] isTheSameDayThan:dayView.date]){
    //        dayView.circleView.hidden = YES;
    //        dayView.circleView.backgroundColor = [UIColor whiteColor];
    //        dayView.dotView.backgroundColor = [UIColor whiteColor];
    //        dayView.textLabel.textColor = [UIColor blackColor];
    //    }
    // Selected date
    else if(_dateSelected && [_calendarManager.dateHelper date:_dateSelected isTheSameDayThan:dayView.date]){
        dayView.circleView.hidden = NO;
        dayView.circleView.backgroundColor = [UIColor redColor];
        dayView.dotView.backgroundColor = [UIColor whiteColor];
        dayView.textLabel.textColor = [UIColor whiteColor];
    }
    // Another day of the current month
    else{
        dayView.circleView.hidden = YES;
        dayView.dotView.backgroundColor = [UIColor redColor];
        dayView.textLabel.textColor = [UIColor blackColor];
        
    }
    
    dayView.dotView.hidden = YES;

   
}

- (void)calendar:(JTCalendarManager *)calendar didTouchDayView:(JTCalendarDayView *)dayView
{
    _dateSelected = dayView.date;
    
    // Animation for the circleView
    dayView.circleView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.1, 0.1);
    [UIView transitionWithView:dayView
                      duration:.3
                       options:0
                    animations:^{
                        dayView.circleView.transform = CGAffineTransformIdentity;
                        [_calendarManager reload];
                    } completion:nil];
    
    
    // Don't change page in week mode because block the selection of days in first and last weeks of the month
    if(_calendarManager.settings.weekModeEnabled){
        return;
    }
    
    // Load the previous or next page if touch a day from another month
    
    if(![_calendarManager.dateHelper date:_calendarContentView.date isTheSameMonthThan:dayView.date]){
        if([_calendarContentView.date compare:dayView.date] == NSOrderedAscending){
            [_calendarContentView loadNextPageWithAnimation];
        }
        else{
            [_calendarContentView loadPreviousPageWithAnimation];
        }
    }
}

#pragma mark - Views customization

- (UIView *)calendarBuildMenuItemView:(JTCalendarManager *)calendar
{
    UILabel *label = [UILabel new];
    
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont fontWithName:@"Avenir-Medium" size:16];
    
    return label;
}

- (void)calendar:(JTCalendarManager *)calendar prepareMenuItemView:(UILabel *)menuItemView date:(NSDate *)date
{
    static NSDateFormatter *dateFormatter;
    if(!dateFormatter){
        dateFormatter = [NSDateFormatter new];
        dateFormatter.dateFormat = @"MMMM yyyy";
        
        dateFormatter.locale = _calendarManager.dateHelper.calendar.locale;
        dateFormatter.timeZone = _calendarManager.dateHelper.calendar.timeZone;
    }
    
    menuItemView.text = [dateFormatter stringFromDate:date];
}

//- (UIView<JTCalendarWeekDay> *)calendarBuildWeekDayView:(JTCalendarManager *)calendar
//{
//    JTCalendarWeekDayView *view = [JTCalendarWeekDayView new];
//
//    for(UILabel *label in view.dayViews){
//        label.textColor = [UIColor blackColor];
//        label.font = [UIFont fontWithName:@"Avenir-Light" size:14];
//    }
//
//    return view;
//}
//
//- (UIView<JTCalendarDay> *)calendarBuildDayView:(JTCalendarManager *)calendar
//{
//    JTCalendarDayView *view = [JTCalendarDayView new];
//
//    view.textLabel.font = [UIFont fontWithName:@"Avenir-Light" size:13];
//
//    view.circleRatio = .8;
//    view.dotRatio = 1. / .9;
//
//    return view;
//}

#pragma mark - Calender Delegate
- (void)calendarDidLoadPreviousPage:(JTCalendarManager *)calendar
{
    // NSLog(@"calendarDidLoadPreviousPage : %@",calendar.date);
}

- (void)calendarDidLoadNextPage:(JTCalendarManager *)calendar
{
    // NSLog(@"calendarDidLoadNextPage : %@",calendar.date);
    
}

// Used to limit the date for the calendar, optional
- (BOOL)calendar:(JTCalendarManager *)calendar canDisplayPageWithDate:(NSDate *)date
{
    return [_calendarManager.dateHelper date:date isEqualOrAfter:_minDate andEqualOrBefore:_maxDate];
}

#pragma mark - Fake data

- (void)createMinAndMaxDate
{
    _todayDate = [NSDate date];
    
    // Min date will be 2 month before today
    _minDate = [_calendarManager.dateHelper addToDate:_todayDate days:1];
    
    // Max date will be 2 month after today
    _maxDate = [_calendarManager.dateHelper addToDate:_todayDate months:24];
}
// Used only to have a key for _eventsByDate
+ (NSDateFormatter *)dateFormatter
{
    static NSDateFormatter *dateFormatter;
    if(!dateFormatter){
        dateFormatter = [NSDateFormatter new];
        dateFormatter.dateFormat = @"dd-MM-yyyy";
    }
    
    return dateFormatter;
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

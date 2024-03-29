//
//  SACalendarConstants.h
//  SACalendar
//
//  User Interface constants. Customize your calendar here.
//
//  Created by Nop Shusang on 7/14/14.
//  Copyright (c) 2014 SyncoApp. All rights reserved.
//
//  Distributed under MIT License

#import <Foundation/Foundation.h>

/**
 *  Constants. Do not change
 */
#define MAX_MONTH 12
#define MIN_MONTH 1
#define MAX_CELL 42
#define DESELECT_ROW -1
#define DAYS_IN_WEEKS 7
#define MAX_WEEK 6

/**
 *  Calendar's proportion
 */
#define calendarToHeaderRatio 7
#define headerFontRatio 0.4

#define cellFontRatio 0.2
#define labelToCellRatio 0.7
#define circleToCellRatio 0.8

/**
 * Calendar's color
 */

// There are 3 layers view in SACalendar, the default UIView, the scroll view, and the collection view.
// Change their colors here

#define viewBackgroundColor [UIColor blackColor]
#define scrollViewBackgroundColor [UIColor whiteColor]
#define calendarBackgroundColor [UIColor lightGrayColor]

#define headerTextColor TABBAR_BACKGROUND_SELECTED

/**
 *  Cell's property
 */

// All cells
#define cellFont [UIFont systemFontOfSize:desiredFontSize * cellFontRatio]
#define cellBoldFont [UIFont boldSystemFontOfSize:desiredFontSize * cellFontRatio]

#define cellBackgroundColor [UIColor whiteColor]
#define cellTopLineColor [UIColor lightGrayColor]

#define dateTextColor rgb(91, 91, 91, 1.0) //[UIColor blackColor]

// Current date's cell
#define currentDateCircleColor TABBAR_BACKGROUND_SELECTED
#define currentDateTextColor [UIColor whiteColor]

// Selected date's cell
//#define selectedDateCircleColor [UIColor blackColor]
#define selectedDateCircleColor [UIColor clearColor]
//#define selectedDateTextColor [UIColor whiteColor]
#define selectedDateTextColor [UIColor lightGrayColor]


#define taskOneColor   rgb(176, 200, 232, 1.0)
#define taskTwoColor   rgb(45, 45, 148, 1.0)
#define taskThreeColor rgb(243, 146, 132, 1.0)
#define taskFourColor  rgb(219, 23, 37, 1.0)
#define taskFiveColor  rgb(52, 184, 172, 1.0)
#define taskSixColor   rgb(181, 222, 217, 1.0)
#define taskSevenColor rgb(252, 196, 0, 1.0)
#define taskEightColor rgb(249, 227, 152, 1.0)



/*
 * Loading states for infinite scroll view is to load the scroll view on the left (previous) first
 * the load the scroll view on the right (next) and finally load the scroll view in the middle (current)
 */
typedef enum {LOADSTATESTART = -1, LOADSTATEPREVIOUS = 0, LOADSTATENEXT, LOADSTATECURRENT} loadStates;

/*
 * Since we are reusing the scroll views, we need to define the three possible scroll views' position
 * Assuming that the scroll views are called 0,1,2 then the three states are
 * 0 1 2, 2 0 1, and 1 2 0
 */
typedef enum {SCROLLSTATE_120 = 0, SCROLLSTATE_201 = 1, SCROLLSTATE_012} scrollStates;

/**
 *  Scroll view's scroll direction
 */
typedef enum {ScrollDirectionHorizontal = 0, ScrollDirectionVertical = 1} scrollDirection;


//
//  WUDemoKeyboardBuilder.m
//  ChangShuo
//
//  Created by ctkj on 14-4-14.
//  Copyright (c) 2014年 ctkj. All rights reserved.
//

#import "CSKeyboardBuilder.h"
#import "CSKeyboardTextKeyCell.h"
#import "CSKeyboardPressedCellPopupView.h"

@implementation CSKeyboardBuilder

+ (WUEmoticonsKeyboard *)sharedEmoticonsKeyboard {
    static WUEmoticonsKeyboard *_sharedEmoticonsKeyboard;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //create a keyboard of default size
        WUEmoticonsKeyboard *keyboard = [WUEmoticonsKeyboard keyboard];
        
        
        //Icon keys
        
        NSDictionary *iconKeys = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"EmotionIconKeys" ofType:@"plist"]];
        
        NSMutableArray *iconKeyItems = [NSMutableArray array];
        
        for (NSString *key in iconKeys) {
            WUEmoticonsKeyboardKeyItem *keyItem = [[WUEmoticonsKeyboardKeyItem alloc] init];
            keyItem.image = [UIImage imageNamed:iconKeys[key]];
            keyItem.textToInput = key;
            [iconKeyItems addObject:keyItem];
        }
//        
//        WUEmoticonsKeyboardKeyItem *loveKey = [[WUEmoticonsKeyboardKeyItem alloc] init];
//        loveKey.image = [UIImage imageNamed:@"love"];
//        loveKey.textToInput = @"[love]";
//        
//        WUEmoticonsKeyboardKeyItem *applaudKey = [[WUEmoticonsKeyboardKeyItem alloc] init];
//        applaudKey.image = [UIImage imageNamed:@"applaud"];
//        applaudKey.textToInput = @"[applaud]";
//        
        WUEmoticonsKeyboardKeyItem *weicoKey = [[WUEmoticonsKeyboardKeyItem alloc] init];
        weicoKey.image = [UIImage imageNamed:@"weico@2x.png"];
        weicoKey.textToInput = @"[weico]";
        [iconKeyItems addObject:weicoKey];
        
        //Icon key group
        WUEmoticonsKeyboardKeyItemGroup *imageIconsGroup = [[WUEmoticonsKeyboardKeyItemGroup alloc] init];
        imageIconsGroup.keyItems = iconKeyItems;//@[loveKey,applaudKey,weicoKey];
        UIImage *keyboardEmotionImage = [UIImage imageNamed:@"keyboard_emotion"];
        UIImage *keyboardEmotionSelectedImage = [UIImage imageNamed:@"keyboard_emotion_selected"];
        if ([UIImage instancesRespondToSelector:@selector(imageWithRenderingMode:)]) {
            keyboardEmotionImage = [keyboardEmotionImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            keyboardEmotionSelectedImage = [keyboardEmotionSelectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        }
        imageIconsGroup.image = keyboardEmotionImage;
        imageIconsGroup.selectedImage = keyboardEmotionSelectedImage;
        
        //Text keys
        NSArray *textKeys = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"EmotionTextKeys" ofType:@"plist"]];
        
        NSMutableArray *textKeyItems = [NSMutableArray array];
        for (NSString *text in textKeys) {
            WUEmoticonsKeyboardKeyItem *keyItem = [[WUEmoticonsKeyboardKeyItem alloc] init];
            keyItem.title = text;
            keyItem.textToInput = text;
            [textKeyItems addObject:keyItem];
        }
        
        //Text key group
        WUEmoticonsKeyboardKeysPageFlowLayout *textIconsLayout = [[WUEmoticonsKeyboardKeysPageFlowLayout alloc] init];
        textIconsLayout.itemSize = CGSizeMake(80, 142/3.0);
        textIconsLayout.itemSpacing = 0;
        textIconsLayout.lineSpacing = 0;
        textIconsLayout.pageContentInsets = UIEdgeInsetsMake(0,0,0,0);
        
        WUEmoticonsKeyboardKeyItemGroup *textIconsGroup = [[WUEmoticonsKeyboardKeyItemGroup alloc] init];
        textIconsGroup.keyItems = textKeyItems;
        textIconsGroup.keyItemsLayout = textIconsLayout;
        textIconsGroup.keyItemCellClass = CSKeyboardTextKeyCell.class;
        UIImage *keyboardTextImage = [UIImage imageNamed:@"keyboard_text"];
        UIImage *keyboardTextSelectedImage = [UIImage imageNamed:@"keyboard_text_selected"];
        if ([UIImage instancesRespondToSelector:@selector(imageWithRenderingMode:)]) {
            keyboardTextImage = [keyboardTextImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            keyboardTextSelectedImage = [keyboardTextSelectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        }
        textIconsGroup.image = keyboardTextImage;
        textIconsGroup.selectedImage = keyboardTextSelectedImage;
        
        //Set keyItemGroups
        keyboard.keyItemGroups = @[imageIconsGroup,textIconsGroup];
        
        //Setup cell popup view
        [keyboard setKeyItemGroupPressedKeyCellChangedBlock:^(WUEmoticonsKeyboardKeyItemGroup *keyItemGroup, WUEmoticonsKeyboardKeyCell *fromCell, WUEmoticonsKeyboardKeyCell *toCell) {
            [CSKeyboardBuilder sharedEmotionsKeyboardKeyItemGroup:keyItemGroup pressedKeyCellChangedFromCell:fromCell toCell:toCell];
        }];

        //Keyboard appearance
        
        //Custom text icons scroll background
        UIView *textGridBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [textIconsLayout collectionViewContentSize].width, [textIconsLayout collectionViewContentSize].height)];
        textGridBackgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        textGridBackgroundView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"keyboard_grid_bg"]];
        [textIconsLayout.collectionView addSubview:textGridBackgroundView];
        
        //Custom utility keys
        //[keyboard setImage:[UIImage imageNamed:@"keyboard_switch"] forButton:WUEmoticonsKeyboardButtonSpace state:UIControlStateNormal];
        [keyboard setImage:[UIImage imageNamed:@"keyboard_del"] forButton:WUEmoticonsKeyboardButtonBackspace state:UIControlStateNormal];
        //[keyboard setImage:[UIImage imageNamed:@"keyboard_switch_pressed"] forButton:WUEmoticonsKeyboardButtonSpace state:UIControlStateHighlighted];
        [keyboard setImage:[UIImage imageNamed:@"keyboard_del_pressed"] forButton:WUEmoticonsKeyboardButtonBackspace state:UIControlStateHighlighted];
        
        //Keyboard background
        [keyboard setBackgroundImage:[[UIImage imageNamed:@"keyboard_bg"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 1, 0, 1)]];
        
        //SegmentedControl
        [[UISegmentedControl appearanceWhenContainedIn:[WUEmoticonsKeyboard class], nil] setBackgroundImage:[[UIImage imageNamed:@"keyboard_segment_normal"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 10, 0, 10)] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
        [[UISegmentedControl appearanceWhenContainedIn:[WUEmoticonsKeyboard class], nil] setBackgroundImage:[[UIImage imageNamed:@"keyboard_segment_selected"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 10, 0, 10)] forState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
        [[UISegmentedControl appearanceWhenContainedIn:[WUEmoticonsKeyboard class], nil] setDividerImage:[UIImage imageNamed:@"keyboard_segment_normal_selected"] forLeftSegmentState:UIControlStateNormal rightSegmentState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
        [[UISegmentedControl appearanceWhenContainedIn:[WUEmoticonsKeyboard class], nil] setDividerImage:[UIImage imageNamed:@"keyboard_segment_selected_normal"] forLeftSegmentState:UIControlStateSelected rightSegmentState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
                
        _sharedEmoticonsKeyboard = keyboard;
    });
    return _sharedEmoticonsKeyboard;
}

+ (void)sharedEmotionsKeyboardKeyItemGroup:(WUEmoticonsKeyboardKeyItemGroup *)keyItemGroup
             pressedKeyCellChangedFromCell:(WUEmoticonsKeyboardKeyCell *)fromCell
                                    toCell:(WUEmoticonsKeyboardKeyCell *)toCell
{
    static CSKeyboardPressedCellPopupView *pressedKeyCellPopupView;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        pressedKeyCellPopupView = [[CSKeyboardPressedCellPopupView alloc] initWithFrame:CGRectMake(0, 0, 83, 110)];
        pressedKeyCellPopupView.hidden = YES;
        [[self sharedEmoticonsKeyboard] addSubview:pressedKeyCellPopupView];
    });
    
    if ([[self sharedEmoticonsKeyboard].keyItemGroups indexOfObject:keyItemGroup] == 0) {
        [[self sharedEmoticonsKeyboard] bringSubviewToFront:pressedKeyCellPopupView];
        if (toCell) {
            pressedKeyCellPopupView.keyItem = toCell.keyItem;
            pressedKeyCellPopupView.hidden = NO;
            CGRect frame = [[self sharedEmoticonsKeyboard] convertRect:toCell.bounds fromView:toCell];
            pressedKeyCellPopupView.center = CGPointMake(CGRectGetMidX(frame), CGRectGetMaxY(frame)-CGRectGetHeight(pressedKeyCellPopupView.frame)/2);
        }else{
            pressedKeyCellPopupView.hidden = YES;
        }
    }
}

@end

//
//  YHELabel.h
//  YHELabelTest
//
//  Created by Christ on 14/9/19.
//  Copyright (c) 2014年 NewPower Co. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YHELabel;
@protocol YHELabelDelegate <NSObject>

- (void)YHELabel:(YHELabel *)label didSelectMention:(NSString *)nickname;
- (void)YHELabel:(YHELabel *)label didSelectTag:(NSString *)tagTitle;
// 增加链接的回调 lypl
- (void)YHELabel:(YHELabel *)label didSelectURL:(NSString *)url;

@end

//用于执行绘制自定义表情的询问和图片源
@protocol YHELabelDrawDelegate <NSObject>

@required

- (BOOL)YHELabel:(YHELabel *)label shouldDrawEmotionWithTag:(NSString *)tag;

- (UIImage *)YHELabel:(YHELabel *)label willDrawEmotionWithTag:(NSString *)tag;

@end

@interface YHELabel : UILabel

@property (nonatomic, weak) id <YHELabelDelegate> delegate;

@property (nonatomic, weak) id<YHELabelDrawDelegate> drawDelegate;


@end

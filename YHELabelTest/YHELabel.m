//
//  YHELabel.m
//  YHELabelTest
//
//  Created by Christ on 14/9/19.
//  Copyright (c) 2014年 NewPower Co. All rights reserved.
//

#import "YHELabel.h"
#import <CoreText/CoreText.h>
#import <QuartzCore/QuartzCore.h>

static inline NSAttributedString * AttributedStringSetParaStyle(NSAttributedString *attributedString)
{
    NSMutableAttributedString *mutableAttributedString = [attributedString mutableCopy];
    NSDictionary *attrDict = [mutableAttributedString attributesAtIndex:0 effectiveRange:NULL];
    NSParagraphStyle *attributedStringParaStyle = attrDict[NSParagraphStyleAttributeName];
    if (attributedStringParaStyle) {
        NSMutableParagraphStyle *paraStyle = [attributedStringParaStyle mutableCopy];
        [mutableAttributedString addAttributes:@{NSParagraphStyleAttributeName:paraStyle} range:NSMakeRange(0, attributedString.length)];
    }
    return mutableAttributedString;
    
}

@interface YHELabel ()
{
    @private
    CTFramesetterRef _drawFrameSetter;
    CTFramesetterRef _highlightedDrawFrameSetter;
}

@property (nonatomic,assign) CTFramesetterRef drawFrameSetter;
@property (nonatomic,assign) CTFramesetterRef highlightedDrawFrameSetter;

@end

@implementation YHELabel
@dynamic drawFrameSetter;
@dynamic highlightedDrawFrameSetter;

- (void)dealloc
{
    if (_drawFrameSetter) {
        CFRelease(_drawFrameSetter);
    }
    if (_highlightedDrawFrameSetter) {
        CFRelease(_highlightedDrawFrameSetter);
    }
}

- (CTFramesetterRef)drawFrameSetter
{
    @synchronized(self){
        NSAttributedString *attributedString = AttributedStringSetParaStyle(self.attributedText);
        CTFramesetterRef frameSetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)attributedString);
        [self setDrawFrameSetter:frameSetter];
        if (frameSetter) {
            CFRelease(frameSetter);
        }
    }
    return _drawFrameSetter;
}

- (void)setDrawFrameSetter:(CTFramesetterRef)drawFrameSetter
{
    if (drawFrameSetter) {
        CFRetain(drawFrameSetter);
    }
    if (_drawFrameSetter) {
        CFRelease(_drawFrameSetter);
    }
    _drawFrameSetter = drawFrameSetter;
}

- (void)setHilightedDrawFrameSetter:(CTFramesetterRef)highlightedDrawFrameSetter {
    if (highlightedDrawFrameSetter) {
        CFRetain(highlightedDrawFrameSetter);
    }
    
    if (_highlightedDrawFrameSetter) {
        CFRelease(_highlightedDrawFrameSetter);
    }
    
    _highlightedDrawFrameSetter = highlightedDrawFrameSetter;
}

- (CTFramesetterRef)highlightedDrawFrameSetter {
    return _highlightedDrawFrameSetter;
}

- (void)drawTextInRect:(CGRect)rect
{
    [super drawTextInRect:rect];
    return;
    
    NSAttributedString *originalAttributedText = nil;
    
    //调整字体大小使之适配当前的视图尺寸
    if (self.adjustsFontSizeToFitWidth && self.numberOfLines > 0) {
        CGSize maxSize = (self.numberOfLines > 1)?CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX):CGSizeZero;
        CGFloat textWidth = [self sizeThatFits:maxSize].width;
        CGFloat availableWidth = CGRectGetWidth(self.frame) * self.numberOfLines;
        if (self.numberOfLines > 1 && self.lineBreakMode == NSLineBreakByWordWrapping) {
            textWidth *= (M_PI/M_E);
        }
        
        if (textWidth > availableWidth && textWidth > 0) {
            originalAttributedText = [self.attributedText copy];
            
        }
    }
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    {
        CGContextSetTextMatrix(context, CGAffineTransformIdentity);
        CGContextTranslateCTM(context, 0.0f, CGRectGetHeight(rect));
        CGContextScaleCTM(context, 1.0f, -1.0f);
        
        CFRange textRange = CFRangeMake(0,(CFIndex)self.attributedText.length);
        
        CGRect textRect = [self textRectForBounds:rect limitedToNumberOfLines:self.numberOfLines];
        
        CGContextTranslateCTM(context,CGRectGetMinX(textRect), (CGRectGetHeight(rect)-CGRectGetHeight(textRect))/2);
        
        if (self.shadowColor && !self.highlighted) {
            CGContextSetShadowWithColor(context, self.shadowOffset, 0.0f, self.shadowColor.CGColor);
        }
        
        //绘制高亮时的文本
        if (self.highlightedTextColor && self.highlighted) {
            NSMutableAttributedString *highlightAttributedString = [self.attributedText mutableCopy];
            [highlightAttributedString addAttribute:NSForegroundColorAttributeName value:self.highlightedTextColor range:NSMakeRange(0, highlightAttributedString.length)];
            
            if (!self.highlightedDrawFrameSetter) {
                CTFramesetterRef highlightFrameSetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)highlightAttributedString);
                [self setHighlightedDrawFrameSetter:highlightFrameSetter];
                CFRelease(highlightFrameSetter);
            }
            
            [self drawFramesetter:self.highlightedDrawFrameSetter attributedString:highlightAttributedString textRange:textRange inRect:textRect context:context];
        }
        else
        {
            [self drawFramesetter:self.drawFrameSetter attributedString:self.attributedText textRange:textRange inRect:textRect context:context];
        }
        
        // If we adjusted the font size, set it back to its original size
        if (originalAttributedText) {
            // Use ivar directly to avoid clearing out framesetter and renderedAttributedText
            self.attributedText = originalAttributedText;
        }
    }

    CGContextRestoreGState(context);
    
    
}

- (void)drawFramesetter:(CTFramesetterRef)framesetter
       attributedString:(NSAttributedString *)attributedString
              textRange:(CFRange)textRange
                 inRect:(CGRect)rect
                context:(CGContextRef)context
{
    CGSize suggestSize = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, textRange, NULL, CGSizeMake(rect.size.width, CGFLOAT_MAX), NULL);
    
    NSLog(@"Suggest size = %@ \n Draw Rect = %@",NSStringFromCGSize(suggestSize),NSStringFromCGRect(rect));
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, CGRectMake(0, 0, suggestSize.width, suggestSize.height));
    CTFrameRef frame = CTFramesetterCreateFrame(framesetter, textRange, path, NULL);
    
    CFArrayRef lines = CTFrameGetLines(frame);
    NSInteger numberOfLines = self.numberOfLines > 0 ? MIN(self.numberOfLines, CFArrayGetCount(lines)) : CFArrayGetCount(lines);
    BOOL truncateLastLine = (self.lineBreakMode == NSLineBreakByTruncatingHead || self.lineBreakMode == NSLineBreakByTruncatingMiddle || self.lineBreakMode == NSLineBreakByTruncatingTail);
    
    CGPoint lineOrigins[numberOfLines];
    CTFrameGetLineOrigins(frame, CFRangeMake(0, numberOfLines), lineOrigins);
    
    //计算边缘使其居中
    CGFloat bottomMargin = (rect.size.height - numberOfLines*self.font.lineHeight)/2;
    bottomMargin = MAX(bottomMargin, 0);
    
    //开始绘制每一行
    for (CFIndex lineIndex = 0; lineIndex < numberOfLines; lineIndex++) {
        CGPoint lineOrigin = lineOrigins[lineIndex];
        
        
        CTLineRef line = CFArrayGetValueAtIndex(lines, lineIndex);
        CGFloat ascent,descent,leading;
        CTLineGetTypographicBounds(line, &ascent, &descent, &leading);
        CGRect lineRect =  CTLineGetBoundsWithOptions(line, 0);
        NSLog(@"suggest line draw y = %f",rect.size.height - lineOrigin.y);
        lineOrigin.y = self.font.lineHeight*(numberOfLines-lineIndex)-self.font.ascender;
//                lineOrigin.y += bottomMargin;
        
        CGContextSetTextPosition(context, lineOrigin.x, lineOrigin.y);
        
        
        
        NSLog(@"---%.2f,%.2f,%.2f,%.2f---%@",ascent,descent,leading,rect.size.height - lineOrigin.y,NSStringFromCGRect(lineRect));
        NSLog(@"Draw line origin = %.2f",lineOrigin.y);
        if (lineIndex == numberOfLines - 1 && truncateLastLine) {
            CFRange lastLineRange = CTLineGetStringRange(line);
            //画省略号的条件
            if (!(lastLineRange.length==0 && lastLineRange.location == 0) && lastLineRange.location + lastLineRange.length < textRange.location + textRange.length)
            {
                CTLineTruncationType truncationType;
                CFIndex truncationAttributePosition = lastLineRange.location;
                NSLineBreakMode lineBreakMode = self.lineBreakMode;
                //多行时只能用NSLineBreakByTruncatingTail
                if (numberOfLines != 1) {
                    lineBreakMode = NSLineBreakByTruncatingTail;
                }
                switch (lineBreakMode) {
                    case NSLineBreakByTruncatingHead:
                        truncationType = kCTLineTruncationStart;
                        break;
                    case NSLineBreakByTruncatingMiddle:
                        truncationType = kCTLineTruncationMiddle;
                        truncationAttributePosition += (lastLineRange.length/2);
                        break;
                    case NSLineBreakByTruncatingTail:
                        truncationType = kCTLineTruncationEnd;
                        truncationAttributePosition += (lastLineRange.length-1);
                        break;
                        
                    default:
                        break;
                }
                
                NSString *truncationTokenString = @"\u2026";
                
                NSDictionary *truncationTokenStringAttributes = [attributedString attributesAtIndex:(NSUInteger)truncationAttributePosition effectiveRange:NULL];
                
                NSAttributedString *attributedTokenString = [[NSAttributedString alloc] initWithString:truncationTokenString attributes:truncationTokenStringAttributes];
                
                CTLineRef truncationToken = CTLineCreateWithAttributedString((__bridge CFAttributedStringRef)attributedTokenString);
                
                
                NSMutableAttributedString *truncationString = [[attributedString attributedSubstringFromRange:NSMakeRange(lastLineRange.location, lastLineRange.length)] mutableCopy];
                if (lastLineRange.length > 0)
                {
                    unichar lastCharacter = [[truncationString string] characterAtIndex:(NSUInteger)(lastLineRange.length-1)];
                    if ([[NSCharacterSet newlineCharacterSet] characterIsMember:lastCharacter]) {
                        [truncationString deleteCharactersInRange:NSMakeRange((NSUInteger)(lastLineRange.length-1),1)];
                    }
                }
                [truncationString appendAttributedString:attributedTokenString];
                
                CTLineRef truncationLine = CTLineCreateWithAttributedString((__bridge CFAttributedStringRef)truncationString);
                
                CTLineRef truncatedLine = CTLineCreateTruncatedLine(truncationLine, rect.size.width, truncationType, truncationToken);
                if (!truncatedLine) {
                    truncatedLine = CFRetain(truncationToken);
                }
                
                CGFloat flushFactor = 0.0f;
                switch (self.textAlignment) {
                    case NSTextAlignmentCenter:
                        flushFactor = 0.5f;
                        break;
                    case NSTextAlignmentRight:
                        flushFactor = 1.0f;
                        break;
                        
                    default:
                        break;
                }
                
                CGFloat penOffset = (CGFloat)CTLineGetPenOffsetForFlush(truncatedLine, flushFactor, rect.size.width);
                CGContextSetTextPosition(context, penOffset, lineOrigin.y);
                
                CTLineDraw(truncatedLine, context);
                
                CFRelease(truncatedLine);
                CFRelease(truncationLine);
                CFRelease(truncationToken);
            }
            else
            {
                CTLineDraw(line, context);
            }
        }
        else
        {
            CTLineDraw(line, context);
        }
        
    }
    
    CFRelease(frame);
    CFRelease(path);
}

- (CGRect)textRectForBounds:(CGRect)bounds limitedToNumberOfLines:(NSInteger)numberOfLines
{
    CGRect aTextRect = [super textRectForBounds:bounds limitedToNumberOfLines:numberOfLines];
    return aTextRect;
    
    CGRect textRect = bounds;
    // Calculate height with a minimum of double the font pointSize, to ensure that CTFramesetterSuggestFrameSizeWithConstraints doesn't return CGSizeZero, as it would if textRect height is insufficient.
    textRect.size.height = MAX(self.font.pointSize*2, CGRectGetHeight(bounds));
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, textRect);
    CTFrameRef frame = CTFramesetterCreateFrame(self.drawFrameSetter, CFRangeMake(0, 0), path, NULL);
    CFArrayRef lines = CTFrameGetLines(frame);
    CFRange textRange = CTFrameGetStringRange(frame);
    if (numberOfLines != 0) {
        textRange.length = 0;
    }
    for (CFIndex lineIndex = 0; lineIndex < numberOfLines; lineIndex ++) {
        CTLineRef line = (CTLineRef)CFArrayGetValueAtIndex(lines, lineIndex);
        CFRange lineRange = CTLineGetStringRange(line);
        textRange.location = MIN(textRange.location, lineRange.location);
        textRange.length += lineRange.length;
    }

    NSAttributedString *clipAttributedString = [self.attributedText attributedSubstringFromRange:NSMakeRange(textRange.location, textRange.length)];
    clipAttributedString = AttributedStringSetParaStyle(clipAttributedString);
    CTFramesetterRef clipFrameSetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)clipAttributedString);
    
    CGSize textSize = CTFramesetterSuggestFrameSizeWithConstraints(clipFrameSetter, CFRangeMake(0, 0), NULL,textRect.size, NULL);
    
    //去小数点
    textSize = CGSizeMake(ceil(textSize.width), ceil(textSize.height));
    
    if (textSize.height<textRect.size.height) {
        CGFloat yOffset = floor((bounds.size.height-textSize.height)/2.0f);
        textRect.origin.y += yOffset;
        textRect.origin.x = ceil((CGRectGetWidth(bounds)-textSize.width)/2);
//        textRect.size.height = textSize.height;
    }
    return textRect;
}

@end

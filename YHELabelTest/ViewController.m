//
//  ViewController.m
//  YHELabelTest
//
//  Created by Christ on 14/9/19.
//  Copyright (c) 2014年 NewPower Co. All rights reserved.
//

#import "ViewController.h"
#import "YHELabel.h"
#import "TTTAttributedLabel.h"
#import "OHAttributedLabel.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    NSString *str = @"昨天在微風曬了一天大太陽就是為了這雙美鞋❤️看到照片這麼美也值得了❤️😍偶像關史蒂芬妮的鞋子品牌L.A.M.B~微風[MADISON]獨賣~墊子好軟好好走～今年鞋子一定要選尖頭的唷～❤️女人穿上高跟鞋才可以看到全世界阿❤️😍";
    
    YHELabel *alabel = [[YHELabel alloc] initWithFrame:CGRectMake(50, 100, 100, 200)];
    alabel.font = [UIFont systemFontOfSize:10.0f];
    alabel.textColor = [UIColor blueColor];
    alabel.textAlignment = NSTextAlignmentCenter;
    alabel.numberOfLines = 0;
    alabel.lineBreakMode = NSLineBreakByCharWrapping;
    alabel.text =str;// @"原成都工投集团董事长戴晓明落马，牵出原四川省委副书记李春城，之后多名周永康旧部被查；原北方国际信托公司董事长霍津义出事后，原天津市委常委皮黔生、原天津检察长李宝金、原市政协主席宋平顺悉数落马";
    alabel.backgroundColor = [UIColor redColor];
    [self.view addSubview:alabel];
    
    UILabel *blabel = [[UILabel alloc] initWithFrame:CGRectMake(160, 100, 100, 200)];
    blabel.font = [UIFont systemFontOfSize:10.0f];
    blabel.textColor = [UIColor blueColor];
    blabel.textAlignment = NSTextAlignmentCenter;
    blabel.numberOfLines = 0;
    blabel.lineBreakMode = NSLineBreakByCharWrapping;
    blabel.text = str;//@"原成都工投集团董事长戴晓明落马，牵出原四川省委副书记李春城，之后多名周永康旧部被查；原北方国际信托公司董事长霍津义出事后，原天津市委常委皮黔生、原天津检察长李宝金、原市政协主席宋平顺悉数落马";
//    [blabel setAttributedText:attrStr];
    blabel.backgroundColor = [UIColor cyanColor];
    [self.view addSubview:blabel];
    
    TTTAttributedLabel *clabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectMake(50, 310, 100, 200)];
    clabel.font = [UIFont systemFontOfSize:12.0f];
    clabel.textColor = [UIColor blueColor];
    clabel.textAlignment = NSTextAlignmentCenter;
    clabel.verticalAlignment = TTTAttributedLabelVerticalAlignmentBottom;
    clabel.numberOfLines = 0;
    clabel.lineBreakMode = NSLineBreakByCharWrapping;
//    clabel.text = @"原成都工投集团董事长戴晓明落马，牵出原四川省委副书记李春城，之后多名周永康旧部被查；原北方国际信托公司董事长霍津义出事后，原天津市委常委皮黔生、原天津检察长李宝金、原市政协主席宋平顺悉数落马";
//    clabel.attributedText = attrStr;
    clabel.backgroundColor = [UIColor redColor];
    [self.view addSubview:clabel];
    
    OHAttributedLabel *dlabel = [[OHAttributedLabel alloc] initWithFrame:CGRectMake(160, 400, 100, 200)];
    dlabel.font = [UIFont systemFontOfSize:12.0f];
    dlabel.textColor = [UIColor blueColor];
    dlabel.textAlignment = NSTextAlignmentCenter;
    dlabel.numberOfLines = 0;
    dlabel.lineBreakMode = NSLineBreakByCharWrapping;
    dlabel.text = @"原成都工投集团董事长戴晓明落马，牵出原四川省委副书记李春城，之后多名周永康旧部被查；原北方国际信托公司董事长霍津义出事后，原天津市委常委皮黔生、原天津检察长李宝金、原市政协主席宋平顺悉数落马";
    dlabel.backgroundColor = [UIColor redColor];
    [self.view addSubview:dlabel];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

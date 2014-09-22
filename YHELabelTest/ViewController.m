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
    
    NSString *str = @"原成都工投集团董事长戴晓明落马，牵出原四川省委副书记李春城，之后多名周永康旧部被查；原北方国际信托公司董事长霍津义出事后，原天津市委常委皮黔生、原天津检察长李宝金、原市政协主席宋平顺悉数落马";
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineBreakMode = NSLineBreakByWordWrapping;
    paraStyle.lineSpacing = 2.0f;
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:str attributes:@{NSParagraphStyleAttributeName:paraStyle,NSFontAttributeName:[UIFont systemFontOfSize:12.0f]}];
    [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15.0f] range:NSMakeRange(0, 10)];
    
    
    YHELabel *alabel = [[YHELabel alloc] initWithFrame:CGRectMake(50, 100, 100, 200)];
    alabel.font = [UIFont systemFontOfSize:12.0f];
    alabel.textColor = [UIColor greenColor];
    alabel.textAlignment = NSTextAlignmentCenter;
    alabel.numberOfLines = 0;
    alabel.lineBreakMode = NSLineBreakByCharWrapping;
//    alabel.text = @"原成都工投集团董事长戴晓明落马，牵出原四川省委副书记李春城，之后多名周永康旧部被查；原北方国际信托公司董事长霍津义出事后，原天津市委常委皮黔生、原天津检察长李宝金、原市政协主席宋平顺悉数落马";
    [alabel setAttributedText:attrStr];
    alabel.backgroundColor = [UIColor redColor];
    [self.view addSubview:alabel];
    
    UILabel *blabel = [[UILabel alloc] initWithFrame:CGRectMake(150, 100, 100, 200)];
    blabel.font = [UIFont systemFontOfSize:12.0f];
    blabel.textColor = [UIColor blueColor];
    blabel.textAlignment = NSTextAlignmentCenter;
    blabel.numberOfLines = 0;
    blabel.lineBreakMode = NSLineBreakByCharWrapping;
//    blabel.text = @"原成都工投集团董事长戴晓明落马，牵出原四川省委副书记李春城，之后多名周永康旧部被查；原北方国际信托公司董事长霍津义出事后，原天津市委常委皮黔生、原天津检察长李宝金、原市政协主席宋平顺悉数落马";
    [blabel setAttributedText:attrStr];
    blabel.backgroundColor = [UIColor cyanColor];
    [self.view addSubview:blabel];
    
    TTTAttributedLabel *clabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectMake(50, 300, 100, 80)];
    clabel.font = [UIFont systemFontOfSize:12.0f];
    clabel.textColor = [UIColor blueColor];
    clabel.textAlignment = NSTextAlignmentCenter;
    clabel.verticalAlignment = TTTAttributedLabelVerticalAlignmentBottom;
    clabel.numberOfLines = 2;
    clabel.lineBreakMode = NSLineBreakByCharWrapping;
    clabel.text = @"原成都工投集团董事长戴晓明落马，牵出原四川省委副书记李春城，之后多名周永康旧部被查；原北方国际信托公司董事长霍津义出事后，原天津市委常委皮黔生、原天津检察长李宝金、原市政协主席宋平顺悉数落马";
    clabel.backgroundColor = [UIColor redColor];
    [self.view addSubview:clabel];
    
    OHAttributedLabel *dlabel = [[OHAttributedLabel alloc] initWithFrame:CGRectMake(50, 400, 100, 80)];
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

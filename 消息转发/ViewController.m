

#import "ViewController.h"
#import "Person.h"
#import <objc/message.h>
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [[Person new] sendMessage:@"hello"];
    
//    OC里面   调用方法 就是给对象发送消息
    
    /**
     

     @param   给那个对象发送消息
     @param  给那个方法发消息
     @return 发消息带的参数
     */
//    objc_msgSend([Person new],@selector(sendMessage:),@"kaipai");
   
}


@end

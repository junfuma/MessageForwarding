/**
   * 消息转发机制
      *  动态方法解析 （resolveInstanceMethod）
      *  快速转发    （forwardingTargetForSelector）
      *  慢速转发
             methodSignatureForSelector
             forwardInvocation
 */

#import "Person.h"
#import "SpareWheel.h"
#import <objc/runtime.h>

@implementation Person

/*
// 调用的方法
 [person performSelector:@selector(eat) withObject:@"minzhe"];
 
+ (BOOL)resolveInstanceMethod:(SEL)sel {
    Method exchangeM = class_getInstanceMethod([self class], @selector(eatWithPersonName:));
    class_addMethod([self class], sel, class_getMethodImplementation(self, @selector(eatWithPersonName:)),method_getTypeEncoding(exchangeM));
    return YES;
}

- (void)eatWithPersonName:(NSString *)name {
    NSLog(@"Person %@ start eat ",name);
}
 
 
 Method exchangeM = class_getInstanceMethod([self class], @selector(eatWithPersonName:));
 
 是为下面method_getTypeEncoding(exchangeM) 做铺垫  这样就拿到了eatWithPersonName方法的type encodings 用作class_addMethod的第四个参数，就是上面我提到的不用暴力手打的获取type encodings的方法
 
 然后调用 class_addMethod  为当前类[self class] 的sel 方法 添加实现 class_getMethodImplementation(self, @selector(eatWithPersonName:)) 这一串就是拿到方法eatWithPersonName的IMP指针  然后最后一个参数是  type encodings

*/

/**
 @param   给那个对象发送消息
 @param  给那个方法发消息
 @param   发消息带的参数
 */
void sendMessage(id self ,SEL _cmd ,NSString* msg){
    NSLog(@"--%@",msg);
}


/**
 class_addMethod(Class cls, SEL name, IMP imp, const char *types)
   * cls ： 你要添加新方法的那个类
   * name ：要添加的方法
   * imp ： 指向实现方法的指针   就是要添加的方法的实现部分
   * types：我们要添加的方法的返回值和参数   叫 type encodings
 */
//动态方法解析
+ (BOOL)resolveInstanceMethod:(SEL)sel
{
   
//    匹配方法
    NSString *methodName = NSStringFromSelector(sel);
    if ([methodName isEqualToString:@"sendMessage:"]) {
      return   class_addMethod(self, sel, (IMP)sendMessage, "v@:@");
    /**
     "v@:@"
          * 1 方法返回值 void   v表示
          * 2 参数 ID类型  @
          * 3  方法编号  :
          * 4 NSString @
      */
    
    }
    return NO;

}

// 快速转发(找备用的接受者)  速记方法  Target  接受者
- (id)forwardingTargetForSelector:(SEL)aSelector
{
    NSString *methodName = NSStringFromSelector(aSelector);
    if ([methodName isEqualToString:@"sendMessage:"]) {
        return [SpareWheel new];
        }
    return [super forwardingTargetForSelector:aSelector];
     
}
/*  慢速转发
     * 1 方法签名
     *  2 消息转发
*/
- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector
{
    NSString *methodName = NSStringFromSelector(aSelector);
    if ([methodName isEqualToString:@"sendMessage:"]) {
//        "v@:@" 方法信息
        return [NSMethodSignature signatureWithObjCTypes:"v@:@"];
    }
    return [super methodSignatureForSelector:aSelector];//走继承树
}
//所有的方法签名保存在NSInvocation里面  速记方法  签名调用 Invocation
- (void)forwardInvocation:(NSInvocation *)anInvocation
{
    /*
    //获得对应的方法编号
    SEL  sel = [anInvocation selector];
    //找一个处理者
    SpareWheel *tempObj = [SpareWheel new];
    if ([tempObj respondsToSelector:sel]) {
//        指定方法的接受者为当前对象
        [anInvocation invokeWithTarget:tempObj];
    }else{
        [super forwardInvocation:anInvocation];//走继承树
    }
     */
    [super forwardInvocation:anInvocation];
}
//如果以上都没有处理   提供报错信息
- (void)doesNotRecognizeSelector:(SEL)aSelector
{
    NSLog(@"找不到方法");
}
@end

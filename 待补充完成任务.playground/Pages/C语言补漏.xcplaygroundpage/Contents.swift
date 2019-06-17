//: [Previous](@previous)

import Foundation


/*:
Xcode -> new MACOS -> commandLine 选择C语言
 1. C 语言中常量的构造方式，及与静态变量优势点在哪里？
 */

/*:
 #### static的两个作用
 1. 修饰变量【存储功能】，无论是局部变量还是全局变量，他们都存在内存的静态区
    1. 可以不初始化，默认为0， 一旦初始化
    2. 效果与全局变量相似，但是位于函数体内部，有利于程序的模块化
    3. 修饰的变量不能被其他文件访问【不能被extern修饰】，相当于私有变量，
 2. 修饰函数【访问限制功能】， 函数前加static使得称为静态函数，但是此处的静态函数值得是存储，而是只对函数的作用域仅限于本文本中，所以有内部函数之称。
    1. 相当于私有函数
 
 ```
 
 void fn_static(void) {
 // 第一次执行声明后，下次进来就不会再去声明了，会直接去获取这个值
 // 其实功能相当于是个【只能在这个方法使用的全局变量】，有利于程序的模块化
 // 注意点：如果在其他地方声明同名的静态变量不会共用同一块内存哦，会在创建一块内存区域来存储
 
 static int n = 10;          // 初始化一次，如果未初始化，默认为0,
 printf("n = %d\n",n);
 n ++;
 printf("n = %d\n",n);
 }
 ```
*/


/*:
 静态变量可以理解为私有，而常量则理解为不变
常量：常量侧重点为不变的量，从创建之后到销毁都不会出现值得改变
 */


// 静态存储方式是指在程序云南行期间由系统分配固定的存储空间的方式
// 动态存储方式则是在程序运行期间根据需要进行动态的分配存储空间的方式
// 【全局变量全是静态变量】，再程序开始执行时给全局变量分配存储区，程序执行完毕就释放。再程序执行过程中，他们占据固定的存储单元，而不是动态的进行分配和释放。

var str = "Hello, playground"

//: [Next](@next)

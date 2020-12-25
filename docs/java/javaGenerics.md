# java泛型
#### 什么是泛型？

​		写在前边，原始文档参考oracle JDK文档：[泛型学习](https://docs.oracle.com/javase/tutorial/java/generics/types.html)

​		泛型是java SE 1.5的新特性，泛型的本质是参数化类型，也就是说所操作的数据类型被指定为一个参数。这种参数类型可以用在类、接口和方法创建中，分别为泛型类、泛型接口、泛型方法。java语言引入泛型的好处是简单安全。

泛型的是在编译的时候检查类型安全，并且所有的强制转换都是自动和隐式的，一遍提高代码的重用率；



#### 泛型解决什么问题/为何出现泛型？

​		例如有些结合中的元素类型是Byte，有的可能是String，java允许程序员构建一个元素类型为Object的Collection，其中的元素可以是任意类型，没有泛型的情况下通过对Object的引用来实现参数的 任意化，需要作显示的强制类型转换，而这种转换要求开发者对实际参数类型必须是在提前预知的情况下进行的。

 对于强制类型转换的错误情况，编译器是不可能提示错误的，而在运行时才会暴露出来，所以为了解决上述问题引入泛型

The following code snippet without generics requires casting:

```java
List list = new ArrayList();
list.add("hello");
String s = (String) list.get(0);
```

When re-written to use generics, the code does not require casting:

```java
List<String> list = new ArrayList<String>();
list.add("hello");
String s = list.get(0);   // no cast
```



#### 为什么使用泛型？

- 在编译时期进行更强的类型检查；这样修复编译时错误鼻修复运行时错误容易；
- 消除类型转换
- 使程序员能够实现通用算法



#### 如何使用泛型？

```java
// 我们创建一个盒子类，里面可以放置任何类型的东西
public class Box {
    private Object object;

    public void set(Object object) { this.object = object; }
    public Object get() { return object; }
}

// 使用泛型改造后，T是可以声明你要放置东西的类型 
public class Box<T> {
    // T stands for "Type"
    private T t;

    public void set(T t) { this.t = t; }
    public T get() { return t; }
}
```

##### 类型参数命名约定

​		按照约定，类型参数名称是单个大写字母。这与您已经知道的变量[命名](https://docs.oracle.com/javase/tutorial/java/nutsandbolts/variables.html#naming)约定形成鲜明对比 ，并且有充分的理由：没有该约定，将很难分辨类型变量与普通类或接口名称之间的区别。

最常用的类型参数名称为：

- E-元素（由Java Collections Framework广泛使用）
- K键
- N-号码
- T型
- V-值
- S，U，V等-第二，第三，第四类型

您将看到在Java SE API以及本课程其余部分中使用的这些名称。

##### 泛型方法

```java
public class Util {
		// 泛型方法
    public static <K, V> boolean compare(Pair<K, V> p1, Pair<K, V> p2) {
        return p1.getKey().equals(p2.getKey()) &&
               p1.getValue().equals(p2.getValue());
    }
}

public class Pair<K, V> {

    private K key;
    private V value;

    public Pair(K key, V value) {
        this.key = key;
        this.value = value;
    }

    public void setKey(K key) { this.key = key; }
    public void setValue(V value) { this.value = value; }
    public K getKey()   { return key; }
    public V getValue() { return value; }
}

// 使用 The complete syntax for invoking this method would be:
Pair<Integer, String> p1 = new Pair<>(1, "apple");
Pair<Integer, String> p2 = new Pair<>(2, "pear");

boolean same = Util.<Integer, String>compare(p1, p2);
boolean same = Util.compare(p1, p2);
```

##### 有界类型参数

​		泛型使用中，可以限定泛型的范围

```java
// 这个类型对象，内部只想存放Integer类型的，此时编译后，取得是Integer类型
public class NaturalNumber<T extends Integer> { .....}

// 多边界类型，此时编译后，字节码取得是B1类型 这需要注意一下   接口和类都存在的情况下，先指定类，否则会编译报错
	<T extends B1 & B2 & B3> 
```

##### 通配符

​		在通用代码中，称为*通配符的*问号（`？`）表示未知类型。通配符可以在多种情况下使用：作为参数，字段或局部变量的类型；有时作为返回类型（尽管更具体的做法是更好的编程习惯）。通配符从不用作泛型方法调用，泛型类实例创建或超类型的类型参数。



```java
// 上界通配符
public static void process(List<? extends Foo> list) { /* ... */ }

// 无界通配符
public static void process(List<?> list) { /* ... */ }

// 下界通配符
//假设您要编写一种将Integer对象放入列表的方法。您希望该方法可用于<Integer>，<Number>和<Object> —可以容纳Integer值的任何内容。
public static void addNumbers(List<? super Integer> list) {
    for (int i = 1; i <= 10; i++) {
        list.add(i);
    }
}
```

#### 类型擦除

##### 类型擦除原理介绍

​	Java语言引入了泛型，以在编译时提供更严格的类型检查并支持泛型编程。为了实现泛型，Java编译器将类型擦除应用于：

- 如果类型参数不受限制，则将通用类型中的所有类型参数替换为其边界或`对象`。因此，产生的字节码仅包含普通的类，接口和方法。
- 必要时插入**类型转换**，以保持类型安全。
- 生成**桥接方法**以在扩展的泛型类型中保留多态。

类型擦除可确保不会为参数化类型创建新的类；因此，泛型不会产生运行时开销。



下边来介绍一下什么是必要时插入类型转换，首先先了解一下什么是类型擦除

```java
// 我们定义了一个泛型类 Pair
public class Pair<T> {
    private T first;
    private T second;
    public Pair() {
    }
    public Pair(T first, T second){
        this.first = first;
        this.second = second;
    }

    public void setFirst(T first) {
        this.first = first;
    }

    public void setSecond(T second) {
        this.second = second;
    }

    public T getFirst() {
        return first;
    }


    public T getSecond() {
        return second;
    }
}

// 通过 javac Pair.java  指令 生成class文件
// 通过 javap -c Pair.class 反编译

Compiled from "Pair.java"
public class com.zhangjp.base.oo.genericParam.Pair<T> {
  public com.zhangjp.base.oo.genericParam.Pair();
    Code:
       0: aload_0
       1: invokespecial #1                  // Method java/lang/Object."<init>":()V
       4: return

  public com.zhangjp.base.oo.genericParam.Pair(T, T);
    Code:
       0: aload_0
       1: invokespecial #1                  // Method java/lang/Object."<init>":()V
       4: aload_0
       5: aload_1
       6: putfield      #2                  // Field first:Ljava/lang/Object;
       9: aload_0
      10: aload_2
      11: putfield      #3                  // Field second:Ljava/lang/Object;
      14: return

  public void setFirst(T);
    Code:
       0: aload_0
       1: aload_1
       2: putfield      #2                  // Field first:Ljava/lang/Object;
       5: return

  public void setSecond(T);
    Code:
       0: aload_0
       1: aload_1
       2: putfield      #3                  // Field second:Ljava/lang/Object;
       5: return

  public T getFirst();
    Code:
       0: aload_0
       1: getfield      #2                  // Field first:Ljava/lang/Object;
       4: areturn

  public T getSecond();
    Code:
       0: aload_0
       1: getfield      #3                  // Field second:Ljava/lang/Object;
       4: areturn
}

```

可以看到以上类由于没有指定T类型，泛型擦除后该类型的变量T将由Object代替

`javac genericParam/Pair.java genericParam/PairTest.java` 

```java
public class PairTest {

    public static void testPair() {
        Pair<String> pair = new Pair<>();
        pair.setFirst("Bob");
        pair.setSecond("Ed");

        String first = pair.getFirst();
        String second = pair.getSecond();

        System.out.println("pair1: " + pair);
        System.out.println("first: " + first);
        System.out.println("second: " + second);
    }
}

// class文件反编译后，可以看到其实真是类型还是Object，那我们声明的String类型在获取的时候是怎么获取到的呢？
//  24: checkcast     #9                  // class java/lang/String   重点关注这一行
// 这个就是官方文档上所说的   必要时插入**类型转换**，以保持类型安全。
zhangjunpingdeMacBook-Pro:oo zhangjunping$ javap -c genericParam/PairTest.class 
Compiled from "PairTest.java"
public class com.zhangjp.base.oo.genericParam.PairTest {
  public com.zhangjp.base.oo.genericParam.PairTest();
    Code:
       0: aload_0
       1: invokespecial #1                  // Method java/lang/Object."<init>":()V
       4: return

  public static void testPair();
    Code:
       0: new           #2                  // class com/zhangjp/base/oo/genericParam/Pair
       3: dup
       4: invokespecial #3                  // Method com/zhangjp/base/oo/genericParam/Pair."<init>":()V
       7: astore_0
       8: aload_0
       9: ldc           #4                  // String Bob
      11: invokevirtual #5                  // Method com/zhangjp/base/oo/genericParam/Pair.setFirst:(Ljava/lang/Object;)V
      14: aload_0
      15: ldc           #6                  // String Ed
      17: invokevirtual #7                  // Method com/zhangjp/base/oo/genericParam/Pair.setSecond:(Ljava/lang/Object;)V
      20: aload_0
      21: invokevirtual #8                  // Method com/zhangjp/base/oo/genericParam/Pair.getFirst:()Ljava/lang/Object;
      24: checkcast     #9                  // class java/lang/String
      27: astore_1
      28: aload_0
      29: invokevirtual #10                 // Method com/zhangjp/base/oo/genericParam/Pair.getSecond:()Ljava/lang/Object;
      32: checkcast     #9                  // class java/lang/String
      35: astore_2
      36: getstatic     #11                 // Field java/lang/System.out:Ljava/io/PrintStream;
      39: new           #12                 // class java/lang/StringBuilder
      42: dup
      43: invokespecial #13                 // Method java/lang/StringBuilder."<init>":()V
      46: ldc           #14                 // String pair1:
      48: invokevirtual #15                 // Method java/lang/StringBuilder.append:(Ljava/lang/String;)Ljava/lang/StringBuilder;
      51: aload_0
      52: invokevirtual #16                 // Method java/lang/StringBuilder.append:(Ljava/lang/Object;)Ljava/lang/StringBuilder;
      55: invokevirtual #17                 // Method java/lang/StringBuilder.toString:()Ljava/lang/String;
      58: invokevirtual #18                 // Method java/io/PrintStream.println:(Ljava/lang/String;)V
      61: getstatic     #11                 // Field java/lang/System.out:Ljava/io/PrintStream;
      64: new           #12                 // class java/lang/StringBuilder
      67: dup
      68: invokespecial #13                 // Method java/lang/StringBuilder."<init>":()V
      71: ldc           #19                 // String first:
      73: invokevirtual #15                 // Method java/lang/StringBuilder.append:(Ljava/lang/String;)Ljava/lang/StringBuilder;
      76: aload_1
      77: invokevirtual #15                 // Method java/lang/StringBuilder.append:(Ljava/lang/String;)Ljava/lang/StringBuilder;
      80: invokevirtual #17                 // Method java/lang/StringBuilder.toString:()Ljava/lang/String;
      83: invokevirtual #18                 // Method java/io/PrintStream.println:(Ljava/lang/String;)V
      86: getstatic     #11                 // Field java/lang/System.out:Ljava/io/PrintStream;
      89: new           #12                 // class java/lang/StringBuilder
      92: dup
      93: invokespecial #13                 // Method java/lang/StringBuilder."<init>":()V
      96: ldc           #20                 // String second:
      98: invokevirtual #15                 // Method java/lang/StringBuilder.append:(Ljava/lang/String;)Ljava/lang/StringBuilder;
     101: aload_2
     102: invokevirtual #15                 // Method java/lang/StringBuilder.append:(Ljava/lang/String;)Ljava/lang/StringBuilder;
     105: invokevirtual #17                 // Method java/lang/StringBuilder.toString:()Ljava/lang/String;
     108: invokevirtual #18                 // Method java/io/PrintStream.println:(Ljava/lang/String;)V
     111: return
}
```


好了，了解完什么是**类型擦除**   以及  **类型转换**

接下来介绍一个***类型擦除与多态***冲突问题……  这个问题作为java基础，经常会被考察到



##### 类型擦除与多态冲突以及桥连方法

```java
    // 当一个类继承泛型类时，针对泛型方法重写时
    public class NumPair extends Pair<Integer> {   
    
      @Override     
      public void setFirst(Integer first) {    
      	System.out.println("call setFirst Method of NumPair"); 
      }  
      
    }
    
// 首先要明确，重写时发生在父子类中，子类重写父类方法，前提是参数和返回值，方法名要一致，这种行为又是我们常说的多态
// 按照我们上述分析 Pair 这个父类编译后字节码中的方法入参是 Object类型，现在重写我们的入参是Integer类型，从现象上看泛型擦与多态冲突了
```

​	    

​			总结：本质上其实并没有，当我们反编译NumPair类时，编译器不仅生成我们所提供的setFirst(Integer first)方法，还帮我们自动生成了一个签名为setFirst(Object first)的新方法；确实是由于类型擦除的原因，导致我们重写方法与父类方法在编译之后出现了签名不一致的情况。**编译器为了解决这个冲突，使得多态特性不被破坏。其会自动生成一个与父类签名一致的方法setFirst(Object first)，并在其内部去调用我们期望的setFirst(Integer first)方法**。由于这个编译器自动生成的方法，一方面是负责来实际重写父类方法的，另一方面则是为了调用开发者实际提供的重写方法，故其被形象地称之为**Bridge Method 桥链方法**



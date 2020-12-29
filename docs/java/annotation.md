# java中的注解
#### 什么是java注解？

​		老样子 写在前边，原始文档参考oracle JDK文档：[注释学习](https://docs.oracle.com/javase/tutorial/java/annotations/index.html)

​        定义： *注解*是元数据的一种形式，它提供有关程序的数据，而该数据不属于程序本身。注释对其注释的代码的操作没有直接影响。注释有多种用途，其中包括：

- **供编译器**使用的**信息**-**编译器**可以使用注释来检测错误或禁止显示警告。
- **编译时和部署时处理**-软件工具可以处理注释信息以生成代码，XML文件等。
- **运行时处理**-在运行时可以检查一些注释。



#### 注解基础

##### 		注解的格式

​			以最简单的形式，注释如下所示：

```java
// 简单的说符号字符（@）向编译器指示后面是注释。
@Entity

@Override
void mySuperMethod() { ... }

@Override
void mySuperMethod() { ... }

@Author(
   name = "Benjamin Franklin",
   date = "3/27/2003"
)
class MyClass() { ... }


@Author(name = "Jane Doe")
@EBook
class MyClass { ... }

// 需要注意 从Java SE 8版本开始，支持重复注释。有关更多信息，请参见 重复注释。
@Author(name = "Jane Doe")
@Author(name = "John Smith")
class MyClass { ... }
```

**从Java SE 8版本开始，支持重复注释。有关更多信息，请参见 [重复注释](https://docs.oracle.com/javase/tutorial/java/annotations/repeating.html)。**

注释类型可以是Java SE API`java.lang`或`java.lang.annotation`包中定义的类型之一。在前面的示例中，`Override`和`SuppressWarnings`是 [预定义的Java批注](https://docs.oracle.com/javase/tutorial/java/annotations/predefined.html)。也可以定义自己的注释类型。上一个示例中的`Author`和`Ebook`注释是自定义注释类型。



##### 可以在哪里使用注释

​	注释可以应用于声明：类，字段，方法和其他程序元素的声明。当在声明上使用时，每个注释通常会按照惯例出现在自己的行上。

​	从Java SE 8发行版开始，注释也可以应用于类型的*使用*。这里有些例子：



- 类实例创建表达式：

  ```java
       new @Interned MyObject();
  ```

- 类型转换：

  ```java
       myString = (@NonNull String) str;
  ```

- 实现上：

  ```java
      class UnmodifiableList<T> implements
          @Readonly List<@Readonly T> { ... }
  ```

- 引发异常声明：

  ```java
       void monitorTemperature() throws
          @Critical TemperatureException { ... }
  ```

#### 注释的声明

​	要使用注释添加相同的元数据，必须首先定义*注释类型*。这样做的语法是：

```java
@interface ClassPreamble {
   String author();
   String date();
   int currentRevision() default 1;
   String lastModified() default "N/A";
   String lastModifiedBy() default "N/A";
   // Note use of array
   String[] reviewers();
}
```

注释类型定义看起来与接口定义相似，在接口定义中，关键字`interface`前面带有at符号（`@`）（@ = AT，与注释类型相同）。注释类型是*interface的*一种形式。

先前的注释定义的主体包含*注释类型元素*声明，它们看起来很像方法。请注意，它们可以定义可选的默认值。



#### 适用于其他注释的注释

适用于其他注释的注释称为*元注释*。中定义了几种元注释类型`java.lang.annotation`。

**@Retention** [`@Retention`](https://docs.oracle.com/javase/8/docs/api/java/lang/annotation/Retention.html)注释指定标记的注释的存储方式：

- `RetentionPolicy.SOURCE` –标记的注释仅保留在源级别中，并且被编译器忽略。

- `RetentionPolicy.CLASS` –标记的注释在编译时由编译器保留，但被Java虚拟机（JVM）忽略。

- `RetentionPolicy.RUNTIME` –标记的注释由JVM保留，因此可以由运行时环境使用。

  

**@Documented** [`@Documented`](https://docs.oracle.com/javase/8/docs/api/java/lang/annotation/Documented.html)注释表示，每当使用指定的注释时，都应使用Javadoc工具记录这些元素。（默认情况下，Javadoc中不包含注释。）有关更多信息，请参见 [Javadoc工具页面](https://docs.oracle.com/javase/8/docs/technotes/guides/javadoc/index.html)。



**@Target** [`@Target`](https://docs.oracle.com/javase/8/docs/api/java/lang/annotation/Target.html)批注标记了另一个批注，以限制该批注可以应用于哪种Java元素。目标注释将以下元素类型之一指定为其值：

- `ElementType.ANNOTATION_TYPE` 可以应用于注释类型。
- `ElementType.CONSTRUCTOR` 可以应用于构造函数。
- `ElementType.FIELD` 可以应用于字段或属性。
- `ElementType.LOCAL_VARIABLE` 可以应用于局部变量。
- `ElementType.METHOD` 可以应用于方法级注释。
- `ElementType.PACKAGE` 可以应用于包声明。
- `ElementType.PARAMETER` 可以应用于方法的参数。
- `ElementType.TYPE` 可以应用于类的任何元素。
- 

**@Inherited** [`@Inherited`](https://docs.oracle.com/javase/8/docs/api/java/lang/annotation/Inherited.html)注解表示可以从超类继承注解类型。（默认情况下，这是不正确的。）当用户查询注释类型并且类没有该类型的注释时，将查询该类的超类作为注释类型。该注释仅适用于类声明。



[`@Repeatable`](https://docs.oracle.com/javase/8/docs/api/java/lang/annotation/Repeatable.html)Java SE 8中引入的**@Repeatable**注释表示可以将标记的注释多次应用于同一声明或类型使用。有关更多信息，请参见 [重复注释](https://docs.oracle.com/javase/tutorial/java/annotations/repeating.html)。



#### 类型注释和可插入类型系统

在Java SE 8发行版之前，注释只能应用于声明。从Java SE 8发行版开始，注释也可以应用于任何*type use*。这意味着注释可以在使用类型的任何地方使用。使用类型的一些示例是类实例创建表达式（`new`），强制类型转换，`implements`子句和`throws`子句。这种形式的注释称为*类型注释*，“[注释基础”](https://docs.oracle.com/javase/tutorial/java/annotations/basics.html)中提供了几个示例 。

创建类型注释以支持对Java程序的改进分析，以确保更强的类型检查。Java SE 8发行版不提供类型检查框架，但允许您编写（或下载）类型检查框架，该框架被实现为与Java编译器结合使用的一个或多个可插拔模块。

例如，您要确保程序中的特定变量永远不会被分配为null。您要避免触发`NullPointerException`。您可以编写一个自定义插件进行检查。然后，您将修改代码以注释该特定变量，指示该变量从未分配为null。变量声明可能如下所示：

```java
@NonNull String str;
```

当您编译代码（包括`NonNull`命令行中的模块）时，如果编译器检测到潜在问题，则会打印一条警告，允许您修改代码以避免错误。您更正代码以删除所有警告后，程序运行时将不会发生此特定错误。

您可以使用多个类型检查模块，其中每个模块检查不同类型的错误。这样，您可以在Java类型系统之上构建，在需要的时间和位置添加特定的检查。

通过明智地使用类型注释和可插入类型检查器，您可以编写更强大且更不易出错的代码。

在许多情况下，您不必编写自己的类型检查模块。有第三方为您完成了工作。例如，您可能想利用华盛顿大学创建的Checker框架。该框架包括一个`NonNull`模块，一个正则表达式模块以及一个互斥锁模块。有关更多信息，请参见 [Checker Framework](http://types.cs.washington.edu/checker-framework/)。

#### 重复注释

重复注视是javaSE 1.8后支持的特性；

使用规则：

​	step1: 注释类型必须标记为`@Repeatable`元注释。以下示例定义了一个自定义的`@Schedule`可重复注释类型：

```java
import java.lang.annotation.Repeatable;

@Repeatable(Schedules.class)
public @interface Schedule {
  String dayOfMonth() default "first";
  String dayOfWeek() default "Mon";
  int hour() default 12;
}
```

​	Step 2: 声明 Containing Annotation Type

```java
public @interface Schedules {
    Schedule[] value();
}
```

​	Reflection API（java反射api）中有几种可用的方法可用于检索注解。

​	返回单个注释的方法的行为，例如 [AnnotatedElement.getAnnotation（Class ）](https://docs.oracle.com/javase/8/docs/api/java/lang/reflect/AnnotatedElement.html#getAnnotation-java.lang.Class-)，没有改变，因为它们仅在存在所请求类型的*一个*注释时才返回单个注释。



​	如果存在多个所请求类型的注释，则可以通过首先获取其容器注释来获取它们。这样，旧代码将继续起作用。Java SE 8中引入了其他方法，这些方法可扫描容器注释以一次返回多个注释，例如 [AnnotatedElement.getAnnotationsByType（Class ）](https://docs.oracle.com/javase/8/docs/api/java/lang/reflect/AnnotatedElement.html#getAnnotationsByType-java.lang.Class-)。参见 [AnnotatedElement](https://docs.oracle.com/javase/8/docs/api/java/lang/reflect/AnnotatedElement.html) 有关所有可用方法的信息的类规范。



#### 总结

​   注释（annotations）：Java 从1.5开始提供了 Annotation （注释，标注），它用来修饰应用程序的元素（类，方法，参数，本地变量，包、元数据），编译器将其与元数据一同存储在 class 文件中，
   运行期间通过 Java 的反射来处理对其修饰元素的访问。Annotation 仅仅用来修饰元素，而不能影响代码的执行。只有通过其配套的框架或工具才能对其信息进行访问和处理。
    
   而@interface 是用来修饰 Annotation 的，请注意，它不是 interface。这个关键字声明隐含了一个信息：它是继承了 java.lang.annotation.Annotation 接口，而不是声明了一个 interface。


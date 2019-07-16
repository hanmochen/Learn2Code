# Python Notes

[TOC]

来自[Python教程 - 廖雪峰的官方网站](https://www.liaoxuefeng.com/wiki/0014316089557264a6b348958f449949df42a6d3a2e542c000)

Created by ChenHanmo.

All Rights Reserved.



## 引言

- 直接运行 py 文件

Mac 或 Linux 下在`.py`文件的第一行加上一个特殊的注释：

```python
#!/usr/bin/env python3

print('hello, world')
```

然后，通过命令给`hello.py`以执行权限：

```bash
$ chmod a+x hello.py
```

- 输入

```python
>>> name = input()
Michael
```

显示变量

```python
>>> name
'Michael'
```

输入提示

```python
name = input('please enter your name: ')
print('hello,', name)
```



- 注释 `#` 开始

- 缩进 
  - 其他每一行都是一个语句，当语句以冒号`:`结尾时，缩进的语句视为代码块。

## Python 基础



### 数据类型和变量

#### 数据类型

- 整数
  - 十进制
  - 十六进制：`0xff00`，`0xa5b4c3d2` 
- 浮点数
  - `1.23`，`3.14`，`-9.01`，
  - `1.23e9`
- 字符串
  - 字符串是以单引号`'`或双引号`"`括起来的任意文本，比如`'abc'`，`"xyz"`等等。请注意，`''`或`""`本身只是一种表示方式，不是字符串的一部分，因此，字符串`'abc'`只有`a`，`b`，`c`这3个字符。如果`'`本身也是一个字符，那就可以用`""`括起来，比如`"I'm OK"`包含的字符是`I`，`'`，`m`，空格，`O`，`K`这6个字符。
  - 如果字符串内部既包含`'`又包含`"`，可以用转义字符`\`来标识
  - 如果字符串内部有很多换行，用`\n`写在一行里不好阅读，为了简化，Python允许用`'''...'''`的格式表示多行内容，可以自己试试：
- 布尔值
  - 布尔值可以用`and`、`or`和`not`运算。
- 空值
  - 空值是Python里一个特殊的值，用`None`表示

#### 变量

- 在Python中，等号`=`是赋值语句，可以把任意数据类型赋值给变量，同一个变量可以反复赋值，而且可以是不同类型的变量。
- 这种变量本身类型不固定的语言称之为*动态语言*，与之对应的是*静态语言*。静态语言在定义变量时必须指定变量类型，如果赋值的时候类型不匹配，就会报错。
- 两种除法
  - `/`除法计算结果是浮点数
  - 还有一种除法是`//`，称为地板除
- Python的整数没有大小限制，Python的浮点数也没有大小限制，但是超出一定范围就直接表示为`inf` 。



### 字符串和编码

#### 字符编码

> 最早的计算机在设计时采用8个比特（bit）作为一个字节（byte），所以，一个字节能表示的最大的整数就是255（二进制11111111=十进制255），如果要表示更大的整数，就必须用更多的字节。比如两个字节可以表示的最大整数是`65535`，4个字节可以表示的最大整数是`4294967295`。

- ASCII: 由于计算机是美国人发明的，因此，最早只有127个字符被编码到计算机里，也就是大小写英文字母、数字和一些符号，这个编码表被称为`ASCII`编码，比如大写字母`A`的编码是`65`，小写字母`z`的编码是`122`。
- 但是要处理中文显然一个字节是不够的，至少需要两个字节，而且还不能和ASCII编码冲突，所以，中国制定了`GB2312`编码，用来把中文编进去。
- Unicode把所有语言都统一到一套编码里，这样就不会再有乱码问题了.最常用的是用两个字节表示一个字符（如果要用到非常偏僻的字符，就需要4个字节）。现代操作系统和大多数编程语言都直接支持Unicode。
- 如果你写的文本基本上全部是英文的话，用Unicode编码比ASCII编码需要多一倍的存储空间，在存储和传输上就十分不划算.本着节约的精神，又出现了把Unicode编码转化为“可变长编码”的`UTF-8`编码。UTF-8编码把一个Unicode字符根据不同的数字大小编码成1-6个字节，常用的英文字母被编码成1个字节，汉字通常是3个字节，只有很生僻的字符才会被编码成4-6个字节。
- 在计算机内存中，统一使用Unicode编码，当需要保存到硬盘或者需要传输的时候，就转换为UTF-8编码。用记事本编辑的时候，从文件读取的UTF-8字符被转换为Unicode字符到内存里，编辑完成后，保存的时候再把Unicode转换为UTF-8保存到文件：浏览网页的时候，服务器会把动态生成的Unicode内容转换为UTF-8再传输到浏览器：
- 很多网页的源码上会有类似`<meta charset="UTF-8" />`的信息，表示该网页正是用的UTF-8编码。

#### Python 的字符编码

- 在最新的Python 3版本中，字符串是以Unicode编码的

- 对于单个字符的编码，Python提供了`ord()`函数获取字符的整数表示，`chr()`函数把编码转换为对应的字符

- 如果知道字符的整数编码，还可以用十六进制这么写`str`：

- ```python
  >>> '\u4e2d\u6587'
  '中文'
  ```

- 由于Python的字符串类型是`str`，在内存中以Unicode表示，一个字符对应若干个字节。如果要在网络上传输，或者保存到磁盘上，就需要把`str`变为以字节为单位的`bytes`。

- Python对`bytes`类型的数据用带`b`前缀的单引号或双引号表示：

  ```python
  x = b'ABC'
  ```

- `'ABC'`和`b'ABC'`，前者是`str`，后者虽然内容显示得和前者一样，但`bytes`的每个字符都只占用一个字节。

- 以Unicode表示的`str`通过`encode()`方法可以编码为指定的`bytes`。

  - 在`bytes`中，无法显示为ASCII字符的字节，用`\x##`显示。

- 反过来，如果我们从网络或磁盘上读取了字节流，那么读到的数据就是`bytes`。要把`bytes`变为`str`，就需要用`decode()`方法：

  - 如果`bytes`中包含无法解码的字节，`decode()`方法会报错：
  - 如果`bytes`中只有一小部分无效的字节，可以传入`errors='ignore'`忽略错误的字节：

- 要计算`str`包含多少个字符，可以用`len()`函数：

  - `len()`函数计算的是`str`的字符数，如果换成`bytes`，`len()`函数就计算字节数：
  - 在操作字符串时，我们经常遇到`str`和`bytes`的互相转换。为了避免乱码问题，应当始终坚持使用UTF-8编码对`str`和`bytes`进行转换

- 由于Python源代码也是一个文本文件，所以，当你的源代码中包含中文的时候，在保存源代码时，就需要务必指定保存为UTF-8编码。当Python解释器读取源代码时，为了让它按UTF-8编码读取，我们通常在文件开头写上这两行：

  - ```python
    #!/usr/bin/env python3
    # -*- coding: utf-8 -*-
    ```

#### 格式化输出

- 在Python中，采用的格式化方式和C语言是一致的，用`%`实现，举例如下：

  ```
  >>> 'Hello, %s' % 'world'
  'Hello, world'
  >>> 'Hi, %s, you have $%d.' % ('Michael', 1000000)
  'Hi, Michael, you have $1000000.'
  ```

  在字符串内部，`%s`表示用字符串替换，`%d`表示用整数替换，有几个`%?`占位符，后面就跟几个变量或者值，顺序要对应好。如果只有一个`%?`，括号可以省略。

  常见的占位符有：



- ```python
  >>>print('%2d-%02d' % (3, 1))
  3-01
  >>>print('%.2f' % 3.1415926)
  3.14
  ```

- 另一种格式化字符串的方法是使用字符串的`format()`方法，它会用传入的参数依次替换字符串内的占位符`{0}`、`{1}`……，不过这种方式写起来比%要麻烦得多：

- ```python
  >>> 'Hello, {0}, 成绩提升了 {1:.1f}%'.format('小明', 17.125)
  'Hello, 小明, 成绩提升了 17.1%'
  ```



#### 使用list和tuple



#### list

- Python内置的一种数据类型是列表：list。list是一种有序的集合，可以随时添加和删除其中的元素。

```python
>>> classmates = ['Michael', 'Bob', 'Tracy']
>>> classmates
['Michael', 'Bob', 'Tracy']
```

- 用`len()`函数可以获得list元素的个数：
- 用索引来访问list中每一个位置的元素，索引是从`0`开始的：
  - 当索引超出了范围时，Python会报一个`IndexError`错误
  - 如果要取最后一个元素，除了计算索引位置外，还可以用`-1`做索引，直接获取最后一个元素：
  - 以此类推，可以获取倒数第2个、倒数第3个：

#### list 操作

- list是一个可变的有序表，所以，可以往list中追加元素到末尾：

  ```python
  >>> classmates.append('Adam')
  >>> classmates
  ['Michael', 'Bob', 'Tracy', 'Adam']
  ```

- 也可以把元素插入到指定的位置，比如索引号为`1`的位置：

  ```python
  >>> classmates.insert(1, 'Jack')
  >>> classmates
  ['Michael', 'Jack', 'Bob', 'Tracy', 'Adam']
  ```

- 要删除list末尾的元素，用`pop()`方法：

  ```python
  >>> classmates.pop()
  'Adam'
  >>> classmates
  ['Michael', 'Jack', 'Bob', 'Tracy']
  ```

- 要删除指定位置的元素，用`pop(i)`方法，其中`i`是索引位置：

```
>>> classmates.pop(1)
'Jack'
>>> classmates
['Michael', 'Bob', 'Tracy']
```

- 要把某个元素替换成别的元素，可以直接赋值给对应的索引位置：

```python
>>> classmates[1] = 'Sarah'
>>> classmates
['Michael', 'Sarah', 'Tracy']
```



#### 多维数组

- list里面的元素的数据类型也可以不同，比如：

```
>>> L = ['Apple', 123, True]
```

- list元素也可以是另一个list，比如：

```
>>> s = ['python', 'java', ['asp', 'php'], 'scheme']
>>> len(s)
4
```

- 要注意`s`只有4个元素，其中`s[2]`又是一个list，如果拆开写就更容易理解了：

```
>>> p = ['asp', 'php']
>>> s = ['python', 'java', p, 'scheme']
```



### turple

- 另一种有序列表叫元组：tuple。tuple和list非常类似，但是tuple一旦初始化就不能修改.
- 只有1个元素的tuple定义时必须加一个逗号`,`，来消除歧义：
- tuple所谓的“不变”是说，tuple的每个元素，指向永远不变。即指向`'a'`，就不能改成指向`'b'`，指向一个list，就不能改成指向其他对象，但指向的这个list本身是可变的！



### 条件判断

- if else 语句

  - 冒号`：` 和缩进
  - `elif` 语句

  ```python
  if <条件判断1>:
      <执行1>
  elif <条件判断2>:
      <执行2>
  elif <条件判断3>:
      <执行3>
  else:
      <执行4>
  ```

- `if`语句执行有个特点，它是从上往下判断，如果在某个判断上是`True`，把该判断对应的语句执行后，就忽略掉剩下的`elif`和`else`。
- `input()`返回的数据类型是`str`，`str`不能直接和整数比较，必须先把`str`转换成整数。Python提供了`int()`函数来完成
- `int()`函数发现一个字符串并不是合法的数字时就会报错



### 循环

#### for/continue

- Python的循环有两种，一种是for...in循环，依次把list或tuple中的每个元素迭代出来

- ```python
  names = ['Michael', 'Bob', 'Tracy']
  for name in names:
      print(name)
  ```

- Python提供一个`range()`函数，可以生成一个整数序列，再通过`list()`函数可以转换为list。比如`range(5)`生成的序列是从0开始小于5的整数。

  ```python
  sum = 0
  for x in range(101):
      sum = sum + x
  print(sum)
  ```

- 第二种循环是while循环，只要条件满足，就不断循环，条件不满足时退出循环。



#### break/continue

- `break`的作用是提前结束循环。
- `continue`的作用是提前结束本轮循环，并直接开始下一轮循环。



### dict 和 set

#### dict

- Python内置了字典：dict的支持，dict全称dictionary，在其他语言中也称为map，使用键-值（key-value）存储，具有极快的查找速度。

- 假设要根据同学的名字查找对应的成绩，如果用list实现，需要两个list：

  ```python
  names = ['Michael', 'Bob', 'Tracy']
  scores = [95, 75, 85]
  ```

  如果用dict实现，只需要一个“名字”-“成绩”的对照表，直接根据名字查找成绩，无论这个表有多大，查找速度都不会变慢。用Python写一个dict如下：

  ```python
  >>> d = {'Michael': 95, 'Bob': 75, 'Tracy': 85}
  >>> d['Michael']
  95
  ```

- 把数据放入dict的方法，除了初始化时指定外，还可以通过key放入：

  ```python
  >>> d['Adam'] = 67
  >>> d['Adam']
  67
  ```

- 由于一个key只能对应一个value，所以，多次对一个key放入value，后面的值会把前面的值冲掉：

- 如果key不存在，dict就会报错：

  - 要避免key不存在的错误，有两种办法，一是通过`in`判断key是否存在：
  - 二是通过dict提供的`get()`方法，如果key不存在，可以返回`None`，或者自己指定的value：

  ```python
  >>> d.get('Thomas')
  >>> d.get('Thomas', -1)
  -1
  ```

  - 注意：返回`None`的时候Python的交互环境不显示结果。

- 要删除一个key，用`pop(key)`方法，对应的value也会从dict中删除：

- list 和 dict 比较

  - 和list比较，dict有以下几个特点：
    1. 查找和插入的速度极快，不会随着key的增加而变慢；
    2. 需要占用大量的内存，内存浪费多。
  - 而list相反：
    1. 查找和插入的时间随着元素的增加而增加；
    2. 占用空间小，浪费内存很少。

- 所以，dict是用空间来换取时间的一种方法。

- dict的key必须是**不可变对象**，在Python中，字符串、整数等都是不可变的，因此，可以作为key。而list是可变的，就不能作为key。

#### set

- set和dict类似，也是一组key的集合，但不存储value。由于key不能重复，所以，在set中，没有重复的key。

  ```python
  >>> s = set([1, 2, 3])
  >>> s
  {1, 2, 3}
  ```

- 重复元素在set中自动被过滤：

- 通过`add(key)`方法可以添加元素到set中，可以重复添加，但不会有效果：

- 通过`remove(key)`方法可以删除元素：

- set可以看成数学意义上的无序和无重复元素的集合，因此，两个set可以做数学意义上的交集、并集等操作：

  ```python
  >>> s1 = set([1, 2, 3])
  >>> s2 = set([2, 3, 4])
  >>> s1 & s2
  {2, 3}
  >>> s1 | s2
  {1, 2, 3, 4
  ```



#### 不可变对象

- 对于可变对象，比如list，对list进行操作，list内部的内容是会变化的

- 对于不可变对象，比如str，对str进行操作

  ```python
  >>> a = 'abc'
  >>> a.replace('a', 'A')
  'Abc'
  >>> a
  'abc'
  ```

- 变量和对象

  ```python
  >>> a = 'abc'
  >>> b = a.replace('a', 'A')
  >>> b
  'Abc'
  >>> a
  'abc'
  ```

- 对于不变对象来说，调用对象自身的任意方法，也不会改变该对象自身的内容。相反，这些方法会创建新的对象并返回，这样，就保证了不可变对象本身永远是不可变的。



## 函数

**函数是最基本的一种代码抽象的方式。**



### 调用函数



- 查看函数帮助：通过`help(abs)`

- 函数名其实就是指向一个函数对象的引用，完全可以把函数名赋给一个变量，相当于给这个函数起了一个“别名”

- ```python
  >>> a = abs # 变量a指向abs函数
  >>> a(-1) # 所以也可以通过a调用abs函数
  1
  ```



### 定义函数

- 在Python中，定义一个函数要使用`def`语句，依次写出函数名、括号、括号中的参数和冒号`:`，然后，在缩进块中编写函数体，函数的返回值用`return`语句返回。

- 如果你已经把`my_abs()`的函数定义保存为`abstest.py`文件了，那么，可以在该文件的当前目录下启动Python解释器，用`from abstest import my_abs`来导入`my_abs()`函数，注意`abstest`是文件名（不含`.py`扩展名）：

- 如果想定义一个什么事也不做的空函数，可以用`pass`语句：

  - `pass`可以用来作为占位符，比如现在还没想好怎么写函数的代码，就可以先放一个`pass`，让代码能运行起来。

- 参数类型检查

  - 数据类型检查可以用内置函数`isinstance()`实现：

  - ```python
    def my_abs(x):
        if not isinstance(x, (int, float)):
            raise TypeError('bad operand type')
        if x >= 0:
            return x
        else:
            return -x
    ```

- 返回多个值
  - python 函数支持返回多个值
  - 实际上返回的是 tuple



### 参数

#### 默认参数

- 必选参数在前，默认参数在后	

- ```python
  def add_end(L=[]):
      L.append('END')
      return L
  ```

- Python函数在定义的时候，默认参数`L`的值就被计算出来了，即`[]`，因为默认参数`L`也是一个变量，它指向对象`[]`，每次调用该函数，如果改变了`L`的内容，则下次调用时，默认参数的内容就变了，不再是函数定义时的`[]`了。

  - 要修改上面的例子，我们可以用`None`这个不变对象来实现：

#### 可变参数

- 由于参数个数不确定，我们首先想到可以把a，b，c……作为一个list或tuple传进来

- 定义可变参数和定义一个list或tuple参数相比，仅仅在参数前面加了一个`*`号。在函数内部，参数`numbers`接收到的是一个tuple，

  - ```python
    def calc(*numbers):
        sum = 0
        for n in numbers:
            sum = sum + n * n
        return sum
    ```

- 如果已经有一个list或者tuple，要调用一个可变参数

#### 关键字参数

- 可变参数允许你传入0个或任意个参数，这些可变参数在函数调用时自动组装为一个tuple。而关键字参数允许你传入0个或任意个含参数名的参数，这些关键字参数在函数内部自动组装为一个dict
- 关键字参数有什么用？它可以扩展函数的功能。比如，在`person`函数里，我们保证能接收到`name`和`age`这两个参数，但是，如果调用者愿意提供更多的参数，我们也能收到。
- 和可变参数类似，也可以先组装出一个dict，然后，把该dict转换为关键字参数传进去

#### 命名关键字参数

- 如果要限制关键字参数的名字，就可以用命名关键字参数，例如，只接收`city`和`job`作为关键字参数。这种方式定义的函数如下：

  ```python
  def person(name, age, *, city, job):
      print(name, age, city, job)
  ```

- 和关键字参数`**kw`不同，命名关键字参数需要一个特殊分隔符`*`，`*`后面的参数被视为命名关键字参数。

- 如果函数定义中已经有了一个可变参数，后面跟着的命名关键字参数就不再需要一个特殊分隔符`*`了：

  ```python
  def person(name, age, *args, city, job):
      print(name, age, args, city, job)
  ```

- 命名关键字参数必须传入参数名，这和位置参数不同。如果没有传入参数名，调用将报错
- 命名关键字参数可以有缺省值
- 在Python中定义函数，可以用必选参数、默认参数、可变参数、关键字参数和命名关键字参数，这5种参数都可以组合使用。但是请注意，参数定义的顺序必须是：必选参数、默认参数、可变参数、命名关键字参数和关键字参数。



### 递归

- 使用递归函数需要注意防止栈溢出。

- 解决递归调用栈溢出的方法是通过**尾递归**优化

  - 尾递归是指，在函数返回的时候，调用自身本身，并且，return语句不能包含表达式。

  - ```python
    def fact(n):
        return fact_iter(n, 1)
    
    def fact_iter(num, product):
        if num == 1:
            return product
        return fact_iter(num - 1, num * product)
    ```

- 遗憾的是，大多数编程语言没有针对尾递归做优化，Python解释器也没有做优化



## 高级特性

### 切片

- 取一个 list 的部分元素
  - `L[0:3]`表示，从索引`0`开始取，直到索引`3`为止，但不包括索引`3`。即索引`0`，`1`，`2`，正好是3个元素。
  - 如果第一个索引是`0`，还可以省略：
  - 倒数切片：
    - 倒数第一个元素的索引是`-1`。
    - `L[-2:-1]`只取倒数第二个元素
  - 前10个数，每两个取一个，`L[:10:2]`
  - 所有数，每5个取一个：` L[::5]`
  - 复制一个list：`L[:]`
- 字符串也可以用切片操作



### 迭代



- 在Python中，迭代是通过`for ... in`来完成的

- Python的`for`循环抽象程度要高于C的`for`循环，因为Python的`for`循环不仅可以用在list或tuple上，还可以作用在其他可迭代对象上。

- 默认情况下，dict迭代的是key。如果要迭代value，可以用`for value in d.values()`，如果要同时迭代key和value，可以用`for k, v in d.items()`。

- 由于字符串也是可迭代对象，因此，也可以作用于`for`循环

- 如何判断一个对象是可迭代对象呢？方法是通过collections模块的Iterable类型判断：

  ```python
  >>> from collections import Iterable
  >>> isinstance('abc', Iterable) # str是否可迭代
  True
  >>> isinstance([1,2,3], Iterable) # list是否可迭代
  True
  >>> isinstance(123, Iterable) # 整数是否可迭代
  False
  ```

- 如果要对list实现类似Java那样的下标循环怎么办？Python内置的`enumerate`函数可以把一个list变成索引-元素对，这样就可以在`for`循环中同时迭代索引和元素本身

  ```python
  >>> for i, value in enumerate(['A', 'B', 'C']):
  ...     print(i, value)
  ```



### 列表生成式

- 示例：

  ```python
  >>> [x * x for x in range(1, 11)]
  [1, 4, 9, 16, 25, 36, 49, 64, 81, 100]
  ```

- for循环后面还可以加上if判断

- 还可以使用两层循环，可以生成全排列：

  - 循环顺序，在前的是外层循环，在后的是内层循环

- `for`循环其实可以同时使用两个甚至多个变量，比如`dict`的`items()`可以同时迭代key和value：

- 把一个list中所有的字符串变成小写

  ```python
  >>> L = ['Hello', 'World', 'IBM', 'Apple']
  >>> [s.lower() for s in L]
  ['hello', 'world', 'ibm', 'apple']
  ```

### 生成器

- 节省内存空间的列表
  - 一边循环一边计算

#### list 生成 generator 

- 把列表生成式的`[]`改成`()`，就创建了一个generator

- generator保存的是算法，每次调用`next(g)`，就计算出`g`的下一个元素的值，直到计算到最后一个元素，没有更多的元素时，抛出`StopIteration`的错误。

- generator 的迭代

- ```python
  >>> for n in g:
  ...     print(n)
  ```

#### 函数生成 generator

- fibonacci 数列

```python
def fib(max):
    n, a, b = 0, 0, 1
    while n < max:
        print(b)
        a, b = b, a + b
        n = n + 1
    return 'done'
```

- *注意*，赋值语句：

  ```python
  a, b = b, a + b
  ```

  相当于：

  ```python
  t = (b, a + b) # t是一个tuple
  a = t[0]
  b = t[1]
  ```

- 函数 generator

```python
def fib(max):
    n, a, b = 0, 0, 1
    while n < max:
        yield b
        a, b = b, a + b
        n = n + 1
    return 'done'
```

- generator和函数的执行流程不一样
  - 函数是顺序执行，遇到`return`语句或者最后一行函数语句就返回。
  - 而变成generator的函数，在每次调用`next()`的时候执行，遇到`yield`语句返回，再次执行时从上次返回的`yield`语句处继续执行。

### 迭代器

- 可迭代对象
  - 可以直接作用于`for`循环的对象
  - 可以使用`isinstance()`判断一个对象是否是`Iterable`对象
- 迭代器
  - 可以被`next()`函数调用并不断返回下一个值的对象称为迭代器：`Iterator`。
  - 可以使用`isinstance()`判断一个对象是否是`Iterator`对象：
  - 把`list`、`dict`、`str`等`Iterable`变成`Iterator`可以使用`iter()`函数
- Python的`Iterator`对象表示的是一个数据流，Iterator对象可以被`next()`函数调用并不断返回下一个数据，直到没有数据时抛出`StopIteration`错误。可以把这个数据流看做是一个有序序列，但我们却不能提前知道序列的长度，只能不断通过`next()`函数实现按需计算下一个数据，所以`Iterator`的计算是惰性的，只有在需要返回下一个数据时它才会计算。

## 函数式编程



- 函数式编程——Functional Programming，虽然也可以归结到面向过程的程序设计，但其思想更接近数学计算
- 在计算机的层次上，CPU执行的是加减乘除的指令代码，以及各种条件判断和跳转指令，所以，汇编语言是最贴近计算机的语言。对应到编程语言，就是越低级的语言，越贴近计算机，抽象程度低，执行效率高，比如C语言；越高级的语言，越贴近计算，抽象程度高，执行效率低，比如Lisp语言。
- 函数式编程就是一种抽象程度很高的编程范式，纯粹的函数式编程语言编写的函数没有变量，因此，任意一个函数，只要输入是确定的，输出就是确定的，这种纯函数我们称之为没有副作用。而允许使用变量的程序设计语言，由于函数内部的变量状态不确定，同样的输入，可能得到不同的输出，因此，这种函数是有副作用的。
- 函数式编程的一个特点就是，允许把函数本身作为参数传入另一个函数，还允许返回一个函数！
- Python对函数式编程提供部分支持。由于Python允许使用变量，因此，Python不是纯函数式编程语言。



### 高阶函数

- 变量可以指向函数`f = abs`
  - 直接调用`abs()`函数和调用变量`f()`完全相同。
- 函数名也是变量`abs = 10` 把`abs`指向`10`后，就无法通过`abs()`调用该函数
  - 恢复：重启交互环境或`del abs`
- 注：由于`abs`函数实际上是定义在`import builtins`模块中的，所以要让修改`abs`变量的指向在其它模块也生效，要用`import builtins; builtins.abs = 10`。



#### 函数作为参数

- 一个函数就可以接收另一个函数作为参数，这种函数就称之为高阶函数。

  ```python
  def add(x, y, f):
      return f(x) + f(y)
  ```



### map/reduce

#### map

- `map()`函数接收两个参数，一个是函数，一个是`Iterable`，`map`将传入的函数依次作用到序列的每个元素，并把结果作为新的`Iterator`返回。

- ```python
  >>> def f(x):
  ...     return x * x
  ...
  >>> r = map(f, [1, 2, 3, 4, 5, 6, 7, 8, 9])
  >>> list(r)
  [1, 4, 9, 16, 25, 36, 49, 64, 81]
  ```

- `map()`传入的第一个参数是`f`，即函数对象本身。由于结果`r`是一个`Iterator`，`Iterator`是惰性序列，因此通过`list()`函数让它把整个序列都计算出来并返回一个list。

#### reduce

- `reduce`把一个函数作用在一个序列`[x1, x2, x3, ...]`上，这个函数必须接收两个参数，`reduce`把结果继续和序列的下一个元素做累积计算，其效果就是：`reduce(f, [x1, x2, x3, x4]) = f(f(f(x1, x2), x3), x4)`

- ```python
  from functools import reduce
  
  DIGITS = {'0': 0, '1': 1, '2': 2, '3': 3, '4': 4, '5': 5, '6': 6, '7': 7, '8': 8, '9': 9}
  
  def str2int(s):
      def fn(x, y):
          return x * 10 + y
      def char2num(s):
          return DIGITS[s]
      return reduce(fn, map(char2num, s))
  ```



### filter



- Python内建的`filter()`函数用于过滤序列。

- 和`map()`类似，`filter()`也接收一个函数和一个序列。和`map()`不同的是，`filter()`把传入的函数依次作用于每个元素，然后根据返回值是`True`还是`False`决定保留还是丢弃该元素。
- 注意到`filter()`函数返回的是一个`Iterator`，也就是一个惰性序列，所以要强迫`filter()`完成计算结果，需要用`list()`函数获得所有结果并返回list。



#### 用 filter 求素数



先构造一个从`3`开始的奇数序列：

```python
def _odd_iter():
    n = 1
    while True:
        n = n + 2
        yield n
```

注意这是一个生成器，并且是一个无限序列。

然后定义一个筛选函数：

```python
def _not_divisible(n):
    return lambda x: x % n > 0
```

最后，定义一个生成器，不断返回下一个素数：

```python
def primes():
    yield 2
    it = _odd_iter() # 初始序列
    while True:
        n = next(it) # 返回序列的第一个数
        yield n
        it = filter(_not_divisible(n), it) # 构造新序列
```

这个生成器先返回第一个素数`2`，然后，利用`filter()`不断产生筛选后的新的序列。

由于`primes()`也是一个无限序列，所以调用时需要设置一个退出循环的条件：

```python
# 打印1000以内的素数:
for n in primes():
    if n < 1000:
        print(n)
    else:
        break
```

注意到`Iterator`是惰性计算的序列，所以我们可以用Python表示“全体自然数”，“全体素数”这样的序列，而代码非常简洁。

### sorted

- `sorted()`函数也是一个高阶函数，它还可以接收一个`key`函数来实现自定义的排序
- 默认情况下，对字符串排序，是按照ASCII的大小比较的，由于`'Z' < 'a'`，结果，大写字母`Z`会排在小写字母`a`的前面。
- 现在，我们提出排序应该忽略大小写，按照字母序排序。要实现这个算法，不必对现有代码大加改动，只要我们能用一个key函数把字符串映射为忽略大小写排序即可。忽略大小写来比较两个字符串，实际上就是先把字符串都变成大写（或者都变成小写），再比较。



### 返回函数

#### 函数作为返回值

```python
def lazy_sum(*args):
    def sum():
        ax = 0
        for n in args:
            ax = ax + n
        return ax
    return sum
```

- 当我们调用`lazy_sum()`时，返回的并不是求和结果，而是求和函数：
- 调用函数`f`时，才真正计算求和的结果：

在函数`lazy_sum`中又定义了函数`sum`，并且，内部函数`sum`可以引用外部函数`lazy_sum`的参数和局部变量，当`lazy_sum`返回函数`sum`时，相关参数和变量都保存在返回的函数中，这种程序结构称为“闭包（Closure）”.

#### 闭包

- ```python
  def count():
      fs = []
      for i in range(1, 4):
          def f():
               return i*i
          fs.append(f)
      return fs
  
  f1, f2, f3 = count()
  ```



-  返回闭包时牢记一点：返回函数不要引用任何循环变量，或者后续会发生变化的变量。

- 如果一定要引用循环变量怎么办？方法是再创建一个函数，用该函数的参数绑定循环变量当前的值，无论该循环变量后续如何更改，已绑定到函数参数的值不变：

- ```python
  def count():
      def f(j):
          def g():
              return j*j
          return g
      fs = []
      for i in range(1, 4):
          fs.append(f(i)) # f(i)立刻被执行，因此i的当前值被传入f()
      return fs
  ```



### lambda 表达式 

- 匿名函数`lambda x: x * x`实际上就是：

```python
def f(x):
    return x * x
```

- 匿名函数有个限制，就是只能有一个表达式，不用写`return`，返回值就是该表达式的结果。

- 用匿名函数有个好处，因为函数没有名字，不必担心函数名冲突。此外，匿名函数也是一个函数对象，也可以把匿名函数赋值给一个变量，再利用变量来调用该函数：

  ```python
  >>> f = lambda x: x * x
  >>> f
  <function <lambda> at 0x101c6ef28>
  >>> f(5)
  25
  ```

  同样，也可以把匿名函数作为返回值返回，比如：

  ```python
  def build(x, y):
      return lambda: x * x + y * y
  ```

### 

### 装饰器

- 由于函数也是一个对象，而且函数对象可以被赋值给变量，所以，通过变量也能调用该函数。

- 函数对象有一个`__name__`属性，可以拿到函数的名字：

- 现在，假设我们要增强`now()`函数的功能，比如，在函数调用前后自动打印日志，但又不希望修改`now()`函数的定义，这种在代码运行期间动态增加功能的方式，称之为“装饰器”（Decorator）。

- ```python
  def log(func):
      def wrapper(*args, **kw):
          print('call %s():' % func.__name__)
          return func(*args, **kw)
      return wrapper
  ```

- 借助Python的@语法，把decorator置于函数的定义处：

  ```python
  @log
  def now():
      print('2018-11-29')
  ```

- 把`@log`放到`now()`函数的定义处，相当于执行了语句：

  ```python
  now = log(now)
  ```



  由于`log()`是一个decorator，返回一个函数，所以，原来的`now()`函数仍然存在，只是现在同名的`now`变量指向了新的函数，于是调用`now()`将执行新函数，即在`log()`函数中返回的`wrapper()`函数。

  `wrapper()`函数的参数定义是`(*args, **kw)`，因此，`wrapper()`函数可以接受任意参数的调用。在`wrapper()`函数内，首先打印日志，再紧接着调用原始函数。

  如果decorator本身需要传入参数，那就需要编写一个返回decorator的高阶函数，写出来会更复杂。比如，要自定义log的文本：

  ```python
  def log(text):
      def decorator(func):
          def wrapper(*args, **kw):
              print('%s %s():' % (text, func.__name__))
              return func(*args, **kw)
          return wrapper
      return decorator
  ```

  这个3层嵌套的decorator用法如下：

  ```python
  @log('execute')
  def now():
      print('2015-3-25')
  ```

  执行结果如下：

  ```python
  >>> now()
  execute now():
  2015-3-25
  ```

  和两层嵌套的decorator相比，3层嵌套的效果是这样的：

  ```python
  >>> now = log('execute')(now)
  ```

  我们来剖析上面的语句，首先执行`log('execute')`，返回的是`decorator`函数，再调用返回的函数，参数是`now`函数，返回值最终是`wrapper`函数。

  以上两种decorator的定义都没有问题，但还差最后一步。因为我们讲了函数也是对象，它有`__name__`等属性，但你去看经过decorator装饰之后的函数，它们的`__name__`已经从原来的`'now'`变成了`'wrapper'`：

  ```python
  >>> now.__name__
  'wrapper'
  ```

  因为返回的那个`wrapper()`函数名字就是`'wrapper'`，所以，需要把原始函数的`__name__`等属性复制到`wrapper()`函数中，否则，有些依赖函数签名的代码执行就会出错。

  不需要编写`wrapper.__name__ = func.__name__`这样的代码，Python内置的`functools.wraps`就是干这个事的，所以，一个完整的decorator的写法如下：

  ```python
  import functools
  
  def log(func):
      @functools.wraps(func)
      def wrapper(*args, **kw):
          print('call %s():' % func.__name__)
          return func(*args, **kw)
      return wrapper
  ```

  或者针对带参数的decorator：

  ```python
  import functools
  
  def log(text):
      def decorator(func):
          @functools.wraps(func)
          def wrapper(*args, **kw):
              print('%s %s():' % (text, func.__name__))
              return func(*args, **kw)
          return wrapper
      return decorator
  ```



### 偏函数

- Python的`functools`模块提供了很多有用的功能，其中一个就是偏函数（Partial function）。要注意，这里的偏函数和数学意义上的偏函数不一样。

- `functools.partial`就是帮助我们创建一个偏函数的，不需要我们自己定义`int2()`，可以直接使用下面的代码创建一个新的函数`int2`：

  ```python
  >>> import functools
  >>> int2 = functools.partial(int, base=2)
  >>> int2('1000000')
  64
  >>> int2('1010101')
  85
  ```

- 新的`int2`函数，仅仅是把`base`参数重新设定默认值为`2`，但也可以在函数调用时传入其他值：

  ```python
  >>> int2('1000000', base=10)
  1000000
  ```



## 模块

- 为了编写可维护的代码，我们把很多函数分组，分别放到不同的文件里，这样，每个文件包含的代码就相对较少，很多编程语言都采用这种组织代码的方式。在Python中，一个.py文件就称之为一个模块（Module）。

- 使用模块有什么好处？

  最大的好处是大大提高了代码的可维护性。其次，编写代码不必从零开始。当一个模块编写完毕，就可以被其他地方引用。我们在编写程序的时候，也经常引用其他模块，包括Python内置的模块和来自第三方的模块。

- 使用模块还可以避免函数名和变量名冲突。相同名字的函数和变量完全可以分别存在不同的模块中，因此，我们自己在编写模块时，不必考虑名字会与其他模块冲突。

- 为了避免模块名冲突，Python又引入了按目录来组织模块的方法，称为包（Package）。

- 每一个包目录下面都会有一个`__init__.py`的文件，这个文件是必须存在的，否则，Python就把这个目录当成普通目录，而不是一个包。`__init__.py`可以是空文件，也可以有Python代码，因为`__init__.py`本身就是一个模块，而它的模块名就是`mycompany`。

### 使用模块



我们以内建的`sys`模块为例，编写一个`hello`的模块：

```python
#!/usr/bin/env python3
# -*- coding: utf-8 -*-

' a test module '

__author__ = 'Michael Liao'

import sys

def test():
    args = sys.argv
    if len(args)==1:
        print('Hello, world!')
    elif len(args)==2:
        print('Hello, %s!' % args[1])
    else:
        print('Too many arguments!')

if __name__=='__main__':
    test()
```

第1行和第2行是标准注释，第1行注释可以让这个`hello.py`文件直接在Unix/Linux/Mac上运行，第2行注释表示.py文件本身使用标准UTF-8编码；

第4行是一个字符串，表示模块的文档注释，任何模块代码的第一个字符串都被视为模块的文档注释；

第6行使用`__author__`变量把作者写进去，这样当你公开源代码后别人就可以瞻仰你的大名；

以上就是Python模块的标准文件模板



#### 作用域

在一个模块中，我们可能会定义很多函数和变量，但有的函数和变量我们希望给别人使用，有的函数和变量我们希望仅仅在模块内部使用。在Python中，是通过`_`前缀来实现的。

正常的函数和变量名是公开的（public），可以被直接引用，比如：`abc`，`x123`，`PI`等；

类似`__xxx__`这样的变量是特殊变量，可以被直接引用，但是有特殊用途，比如上面的`__author__`，`__name__`就是特殊变量，`hello`模块定义的文档注释也可以用特殊变量`__doc__`访问，我们自己的变量一般不要用这种变量名；

类似`_xxx`和`__xxx`这样的函数或变量就是非公开的（private），不应该被直接引用，比如`_abc`，`__abc`等；



### 安装第三方模块



- 注意：Mac或Linux上有可能并存Python 3.x和Python 2.x，因此对应的pip命令是`pip3`。
- Anaconda
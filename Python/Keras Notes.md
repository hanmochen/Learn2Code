# Keras Notes

[TOC]

## 模型构建步骤

1. 数据预处理，分出训练集、验证集、测试集

   - 训练集：模型训练
   - 验证集：模型参数调整
   - 测试集：模型效果测试

2. 构建神经网络

3. 设置优化器，损失函数

   - 优化器：sgd(stochastic gradient descent), RMSprop、Adam等

   - 损失函数：衡量标签与实际输出之间的差距

     - Categorical_crossentropy: 衡量多类分类问题误差的

       损失函数，常与softmax激活函数配合使用；

   - Epochs：循环代数，一般指的是要将全部训练样本训练

     梯度下降算法的次数；

   - 调整优化器参数

     - Lr(Learning rate): 梯度下降的学习速率
     - Decay: 每次更新后学习率的衰减值
     - Momentum: 动量法
     - Nesterov： 梯度优化方法
     - early_stop与best_model
     - Batch size

4. 模型评价



## 示例

```python
from kaggle_data import load_data, preprocess_data, preprocess_labels
import numpy as np
import matplotlib.pyplot as plt
import tensorflow as tf

# Data Preprocessing;

X_data, labels = load_data('data.csv', train=True)
X_data, scaler = preprocess_data(X_data)
Y_data, encoder = preprocess_labels(labels)

# 可以看到，数据集拥有九个类别，数据特征的维数是93维
nb_classes = Y_data.shape[1]
print(nb_classes, 'classes')

dims = X_data.shape[1]
print(dims, 'features')

# 分割训练集，验证集，测试集
from sklearn.model_selection import train_test_split
X_train, X_test, Y_train, Y_test = train_test_split(X_data, Y_data, test_size=0.2, random_state=42)
X_train, X_val, Y_train, Y_val = train_test_split(X_train, Y_train, test_size=0.15, random_state=42)

# keras version：实现两层神经网络 PS:显示有一点问题
from keras.models import Sequential
from keras.layers import Dense, Activation

dims = X_train.shape[1]
print(dims, 'dims')
print("Building model...")

nb_classes = Y_train.shape[1]
print(nb_classes, 'classes')

model = Sequential()
model.add(Dense(nb_classes, input_shape=(dims,), activation='sigmoid'))
model.add(Activation('softmax'))

model.compile(optimizer='sgd', loss='categorical_crossentropy')
model.fit(X_train, Y_train,epochs = 3)

# model analysis  不包含隐层的神经网络，输入为93维，输出为9维(9个类别)，共有93 * 9 + 9 = 846个参数

model.summary()

# calculate accuracy
y_pre = np.argmax(model.predict(X_test),1)
y_test = np.argmax(Y_test,1)
acc = sum(y_pre == y_test)/len(y_pre)
print('test accuarcy: ' + str(acc))

# addjust model optimizer parameter 接下来，调整优化器参数
from keras import optimizers
sgd = optimizers.SGD(lr=0.5, decay=1e-6, momentum=0.9, nesterov=True) 
# default: lr = 0.01, decay=0.0, momentum=0.0, nesterov=False
model.compile(optimizer= sgd, loss='categorical_crossentropy')
model.fit(X_train, Y_train,nb_epoch = 3)

from keras.callbacks import EarlyStopping, ModelCheckpoint

# 加入early_stop与best_model选项，early_stop指在验证集正确率没有上升的时候，提前停止训练；best_model选项可以记录下训练过程
# 中在验证集表现最好的模型
fBestModel = 'best_model.h5' 
early_stop = EarlyStopping(monitor='val_loss', patience=2, verbose=1) 
best_model = ModelCheckpoint(fBestModel, verbose=0, save_best_only=True)

sgd = optimizers.SGD(lr=0.5, decay=1e-6, momentum=0.9, nesterov=True) 
model.compile(optimizer= sgd, loss='categorical_crossentropy')
model.fit(X_train, Y_train, validation_data = (X_val, Y_val), epochs=10, 
          batch_size=128, callbacks=[best_model, early_stop]) 

# 构建单隐层神经网络
model = Sequential()
model.add(Dense(100, input_shape=(dims,)))
model.add(Dense(nb_classes))
model.add(Activation('softmax'))
model.compile(optimizer='sgd', loss='categorical_crossentropy')
model.summary()

sgd = optimizers.SGD(lr=0.5, decay=1e-6, momentum=0.9, nesterov=True) 
model.compile(optimizer= sgd, loss='categorical_crossentropy')
model.fit(X_train, Y_train, validation_data = (X_val, Y_val), epochs=10, 
          batch_size=128, verbose=True)

# calculate accuracy
y_pre = np.argmax(model.predict(X_test),1)
y_test = np.argmax(Y_test,1)
acc = sum(y_pre == y_test)/len(y_pre)
print('test accuarcy: ' + str(acc))
```



## Keras 入门

`Sequential` 顺序模型

```python
from keras.models import Sequential

model = Sequential()
```

可以简单地使用 `.add()` 来堆叠模型：

```python
from keras.layers import Dense

model.add(Dense(units=64, activation='relu', input_dim=100))
model.add(Dense(units=10, activation='softmax'))
```

在完成了模型的构建后, 可以使用 `.compile()` 来配置学习过程：

```python
model.compile(loss='categorical_crossentropy',
              optimizer='sgd',
              metrics=['accuracy'])
```

如果需要，你还可以进一步地配置你的优化器。Keras 的核心原则是使事情变得相当简单，同时又允许用户在需要的时候能够进行完全的控制（终极的控制是源代码的易扩展性）。

```python
model.compile(loss=keras.losses.categorical_crossentropy,
              optimizer=keras.optimizers.SGD(lr=0.01, momentum=0.9, nesterov=True))
```

现在，你可以批量地在训练数据上进行迭代了：

```python
# x_train 和 y_train 是 Numpy 数组 -- 就像在 Scikit-Learn API 中一样。
model.fit(x_train, y_train, epochs=5, batch_size=32)
```

或者，你可以手动地将批次的数据提供给模型：

```python
model.train_on_batch(x_batch, y_batch)
```

只需一行代码就能评估模型性能：

```python
loss_and_metrics = model.evaluate(x_test, y_test, batch_size=128)
```

或者对新的数据生成预测：

```python
classes = model.predict(x_test, batch_size=128)
```



### Keras Sequential 顺序模型

顺序模型是多个网络层的线性堆叠。

你可以通过将网络层实例的列表传递给 `Sequential` 的构造器，来创建一个 `Sequential` 模型：

```python
from keras.models import Sequential
from keras.layers import Dense, Activation

model = Sequential([
    Dense(32, input_shape=(784,)),
    Activation('relu'),
    Dense(10),
    Activation('softmax'),
])
```

也可以简单地使用 `.add()` 方法将各层添加到模型中：

```python
model = Sequential()
model.add(Dense(32, input_dim=784))
model.add(Activation('relu'))
```

------



## 指定输入数据的尺寸

模型需要知道它所期望的输入的尺寸。出于这个原因，顺序模型中的第一层（且只有第一层，因为下面的层可以自动地推断尺寸）需要接收关于其输入尺寸的信息。有几种方法来做到这一点：

- 传递一个 `input_shape` 参数给第一层。它是一个表示尺寸的元组 (一个整数或 `None` 的元组，其中 `None` 表示可能为任何正整数)。在 `input_shape` 中不包含数据的 batch 大小。
- 某些 2D 层，例如 `Dense`，支持通过参数 `input_dim` 指定输入尺寸，某些 3D 时序层支持 `input_dim` 和 `input_length` 参数。
- 如果你需要为你的输入指定一个固定的 batch 大小（这对 stateful RNNs 很有用），你可以传递一个 `batch_size` 参数给一个层。如果你同时将 `batch_size=32` 和 `input_shape=(6, 8)`传递给一个层，那么每一批输入的尺寸就为 `(32，6，8)`。

因此，下面的代码片段是等价的：

```python
model = Sequential()
model.add(Dense(32, input_shape=(784,)))

model = Sequential()
model.add(Dense(32, input_dim=784))
```



## 模型编译

在训练模型之前，您需要配置学习过程，这是通过 `compile` 方法完成的。它接收三个参数：

- 优化器 optimizer。它可以是现有优化器的字符串标识符，如 `rmsprop` 或 `adagrad`，也可以是 Optimizer 类的实例。详见：[optimizers](https://keras.io/optimizers)。
- 损失函数 loss，模型试图最小化的目标函数。它可以是现有损失函数的字符串标识符，如 `categorical_crossentropy` 或 `mse`，也可以是一个目标函数。详见：[losses](https://keras.io/losses)。
- 评估标准 metrics。对于任何分类问题，你都希望将其设置为 `metrics = ['accuracy']`。评估标准可以是现有的标准的字符串标识符，也可以是自定义的评估标准函数。

```python
# 多分类问题
model.compile(optimizer='rmsprop',
              loss='categorical_crossentropy',
              metrics=['accuracy'])

# 二分类问题
model.compile(optimizer='rmsprop',
              loss='binary_crossentropy',
              metrics=['accuracy'])

# 均方误差回归问题
model.compile(optimizer='rmsprop',
              loss='mse')

# 自定义评估标准函数
import keras.backend as K

def mean_pred(y_true, y_pred):
    return K.mean(y_pred)

model.compile(optimizer='rmsprop',
              loss='binary_crossentropy',
              metrics=['accuracy', mean_pred])
```



## 模型训练

Keras 模型在输入数据和标签的 Numpy 矩阵上进行训练。为了训练一个模型，你通常会使用 `fit` 函数。[文档详见此处](https://keras.io/models/sequential)。

```python
# 对于具有 2 个类的单输入模型（二进制分类）：

model = Sequential()
model.add(Dense(32, activation='relu', input_dim=100))
model.add(Dense(1, activation='sigmoid'))
model.compile(optimizer='rmsprop',
              loss='binary_crossentropy',
              metrics=['accuracy'])

# 生成虚拟数据
import numpy as np
data = np.random.random((1000, 100))
labels = np.random.randint(2, size=(1000, 1))

# 训练模型，以 32 个样本为一个 batch 进行迭代
model.fit(data, labels, epochs=10, batch_size=32)
# 对于具有 10 个类的单输入模型（多分类分类）：

model = Sequential()
model.add(Dense(32, activation='relu', input_dim=100))
model.add(Dense(10, activation='softmax'))
model.compile(optimizer='rmsprop',
              loss='categorical_crossentropy',
              metrics=['accuracy'])

# 生成虚拟数据
import numpy as np
data = np.random.random((1000, 100))
labels = np.random.randint(10, size=(1000, 1))

# 将标签转换为分类的 one-hot 编码
one_hot_labels = keras.utils.to_categorical(labels, num_classes=10)

# 训练模型，以 32 个样本为一个 batch 进行迭代
model.fit(data, one_hot_labels, epochs=10, batch_size=32)
```
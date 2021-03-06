
# Calabash
Calabash game using swift language

注意： 需要把工程文件夹 Calabash_ 改成 Calabash 再运行

![Image text](https://github.com/meibanfa/Calabash/blob/master/image/img_0926.png)
## 一、	游戏运行逻辑
葫芦娃通过控制杆来操控，可方便地在地图上移动，但是不能移出地图。
![Image text](https://github.com/meibanfa/Calabash/blob/master/image/IMG_0927.PNG)
点击技能按钮，葫芦娃便使用技能，发射水弹攻击敌人。
![Image text](https://github.com/meibanfa/Calabash/blob/master/image/IMG_0928.PNG)
小怪每隔0.2s 在右边随机生成，并且可以捕获葫芦娃的位置，并朝着葫芦娃的位置移动。敌人的管理我们使用了双向链表，一次技能只能消灭一个敌人，双向链表的数据结构可以比较方便地把这个敌人从战场上移走。
敌人受到攻击后，从地图上消失。
葫芦娃当前的血量会在操作杆旁边显示，当前分数会在左上角显示。

点击右上角，可以使当前的画面暂停，并可以选择resume回到游戏或者restart重新开始游戏。
![Image text](https://github.com/meibanfa/Calabash/blob/master/image/IMG_0933.PNG)
但是当葫芦娃死亡时，只会显示restart按钮，重新开始游戏。
![Image text](https://github.com/meibanfa/Calabash/blob/master/image/IMG_0934.PNG)

## 二、 类的管理
![Image text](https://github.com/meibanfa/Calabash/blob/master/image/relation.png)
GameViewcontroller作为视图管理器，其中包含GameScene对象，GameScene对象是本游戏显示最重要的一个类，其中聚集了葫芦娃，小怪，控制杆，技能按钮等各个模型。
其中，位于GameScene中的sceneDidLoad函数会调用各个对象的构造函数，做一些基本的加载与初始化工作。
各个对象通过constants函数取到他们对应的图像，并加载到游戏场景中。

## 三、 使用到的技术

### 3.1 碰撞检测
使用SKPhysicsContact碰撞检测，目前有两种碰撞类型，葫芦娃与敌人，敌人与子弹的碰撞把碰撞的结果使用CollisionType枚举类型返回，并在GameScene中的didBegin函数中处理。

### 3.2 控制杆 & 按钮
Joystick继承了SKNode，通过对用户触摸的捕获，来更新葫芦娃的位置。
Fire button通过对用户点击的捕获，在用户松手时发送一个子弹。

### 3.3 人物管理
#### 葫芦娃
葫芦娃的移动通过控制杆来处理，每按动发射按钮，葫芦娃使用水弹攻击右边的敌人。
#### 小怪
小怪随机从地图的右边生成，其每次捕获到葫芦的位置，便朝着葫芦娃的位置移动。
其中，人物都是使用moveTo函数移动的。
小怪使用双向链表的数据结构维护，每次更新小怪的移动轨迹时，正向遍历链表，顺序更新小怪的移动。小怪被子弹击中时，则在链表中删除小怪。
#### 特效
使用xcode中的粒子效果，生成人物死亡时的特效。

## 四、 参考
实现粒子效果：https://www.jianshu.com/p/7c5cd03b050c 

Joystick的设计: https://github.com/Derrick56007/Swift-SpriteKit-Joystick

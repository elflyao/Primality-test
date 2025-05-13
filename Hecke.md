Hecke 是 Julia 下的计算代数数论包， 
# 一、创建与赋值
## 1、预定义整环和有理数域
```Julia
  x = ZZ(2)
  y = QQ(1//3)
```
## 2、Z 上的剩余环
```Julia
  p = 5
  Rp = ResidueField(ZZ, p)
  x = Rp(12) # x = 2
  y = Rp(13) # y = 3
  z = x * y  #z = 1
```
## 3、二次域
```Julia
  d = -3
  F, t = quadratic_field(d) # t是单位元, d 是无平方因子数
  x = F([1, 2])
  y = F([2, 1])
```
  $x = 1 + 2\sqrt{3}$
  $y = 2 + \sqrt{3}$
## 4、分圆域
```Julia
  F, t = cyclotomic_field(7)
  x = F([1, 2, 3, 4, 5, 6]) 
  y = F([6, 5, 4, 3, 2, 1])
```
  $x = 1 + 2\zeta_7 + 3\zeta_7^2 + 4\zeta_7^3 + 5\zeta_7^4 +   6\zeta_7^5$
  $y = 6 + 5\zeta_7 + 4\zeta_7^2 + 3\zeta_7^3 + 2\zeta_7^4 + \zeta_7^5$
  这种赋值方式，要保证[]中的元素数量和域的次数一致，二次域是 2 个，n 次分圆域是 φ(n) 个。
## 5、一般代数数域
```Julia
  Qx, x = QQ["x"] #有理数域上的通用多项式环
  #定义于 x^4+x^3+2x+1 上的代数数域，多项式要不可约，a 是单位元
  N, a = NumberField(x^4+x^3+2x+1, "a") 
  n1 = N([1, 2, 3, 4])
```  
  $n_1 = 1 + 2a + 3a^2 + 4a^3$

  如果要定义代数整数环，多项式首项系数要是 1，其他项系数是整数。
## 6、多项式
```Julia
  Zx, x = ZZ["x"] #定义整系数多项式
  a = x^127 + 1
  b = x^7 + 1
  c = mod(a, b)
  p = 5
  Rp = residue_field(ZZ, p) #定义模p环上多项式
  Rx, x = Rp["x"]
  a = x^127 + 1
  b = x^7 + 1
  c = mod(a, b)
```  
## 7、两个特殊值
```Julia
  c1 = one(F) # F 下的 1
  c1 = one(x) # F 下的元素 x 对应的 1
  c0 = zero(F) # F 下的 0
  c0 = zero(x) # F 下的元素 x 对应的 0
```  
## 8、次数，范数
```Julia
  d = degree(F) #域 F 的次数 
  d = degree(x) # x 的次数
  n = norm(x) # x 的范数
```
## 8、获得变量的类型
```Julia
  F, t = quadratic_field(-3)
  x = F([1, 2])
  parent(x)
  parent(x)([1,1])
```
# 二、加减乘乘方按照通常运算进行
```Julia
  z = x + y
  z = x - y
  z = x * y
  z = x^3
```
  需要注意的是，两个操作数要在相同的域中
# 三、模运算
```Julia
  z = mod(x + y, 5)
  z = mod(x * y, 5)
```
下面实现的是 x^p % n 模幂运算
```Julia
function fpowermod(x, p , n)
    @assert p >= 0
    p == 0 && return one(x)
    b = x
    t = ZZ(prevpow(BigInt(2), BigInt(p)))
    r = one(x)
    while true
        if p >= t
            r = mod(r * b, n)
            p -= t
        end
        t >>= 1
        t <= 0 && break
        r = mod(r * r ,n)
    end
    return r
end
```
下面是二次域整数的共轭数模 n
```Julia
function qfconjmod(x, n)
    re = coeff(x, 0)
    ir = mod(ZZ(-coeff(x, 1)), n)
    return parent(x)([re, ir])
end
```

# 四、各项系数
```Julia
   x = F([1, 2])
   coefficients(x) #返回各项系数
   coeff(x, 0) #结果是 1
   coeff(x, 1) #结果是 2
   coeff(x, 2) #因为只有2项，大于等于 2 结果是 0
```



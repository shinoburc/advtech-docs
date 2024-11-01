# JavaScript/TypeScript におけるポリモフィズム(多態性)

## JavaScript

JavaScript におけるポリモフィズムは、同じ名前の関数やメソッドが、異なるオブジェクトで異なる動作をすることを指します。具体的には、同じ関数名を持つ複数のオブジェクトがある場合に、それぞれのオブジェクトで異なる動作をすることができます。
ポリモフィズムを実現するために、JavaScriptはオブジェクト指向プログラミング（OOP）の機能を利用します。具体的には、クラスとインスタンス、継承、メソッドのオーバーライドなどが使われます。
たとえば、以下のような例を考えてみましょう。

```js
class Animal {
  makeSound() {
    console.log('The animal makes a sound');
  }
}

class Dog extends Animal {
  makeSound() {
    console.log('The dog barks');
  }
}

class Cat extends Animal {
  makeSound() {
    console.log('The cat meows');
  }
}

let animal = new Animal();
let dog = new Dog();
let cat = new Cat();

animal.makeSound(); // 'The animal makes a sound'
dog.makeSound();    // 'The dog barks'
cat.makeSound();    // 'The cat meows'
```

この例では、Animal クラスが定義され、Dog クラスと Cat クラスが Animal クラスを継承しています。そして、それぞれのクラスで makeSound() メソッドを定義しています。
animal オブジェクトは Animal クラスのインスタンスであり、makeSound() メソッドを呼び出すと 'The animal makes a sound' という文字列が表示されます。dog オブジェクトは Dog クラスのインスタンスであり、makeSound() メソッドを呼び出すと 'The dog barks' という文字列が表示されます。同様に、cat オブジェクトは Cat クラスのインスタンスであり、makeSound() メソッドを呼び出すと 'The cat meows' という文字列が表示されます。
このように、同じ makeSound() メソッドを持つ異なるオブジェクトがあり、それぞれが異なる動作をすることでポリモフィズムが実現されています。

## TypeScript

TypeScriptはオブジェクト指向プログラミングにおいてポリモフィズムをサポートしています。ポリモフィズムは、同じインターフェースを持つ異なる型のオブジェクトが異なる方法で振る舞うことができる能力を指します。
具体的には、 TypeScript ではインターフェースを定義して、そのインターフェースを実装する複数のクラスを定義することができます。この場合、それぞれのクラスは同じインターフェースを実装しているため、それぞれのクラスのインスタンスは同じメソッドやプロパティを持っています。しかし、各クラスはそのメソッドやプロパティを異なる方法で実装しているため、同じメソッドやプロパティでも、それぞれのクラスのインスタンスが異なる振る舞いをすることができます。
例えば、以下のようなインターフェースとクラスがあるとします。

```ts
interface Animal {
  name: string;
  speak(): void;
}

class Dog implements Animal {
  name: string;

  constructor(name: string) {
    this.name = name;
  }

  speak(): void {
    console.log(`${this.name} says woof!`);
  }
}

class Cat implements Animal {
  name: string;

  constructor(name: string) {
    this.name = name;
  }

  speak(): void {
    console.log(`${this.name} says meow!`);
  }
}
```

上記の例では、Animal インターフェースを実装する Dog クラスと Cat クラスを定義しています。それぞれのクラスは name プロパティと speak() メソッドを持っており、speak() メソッドはそれぞれの動物の鳴き声を出力するように実装されています。
この場合、Dog クラスのインスタンスと Cat クラスのインスタンスはどちらも Animal 型の変数に代入することができます。そして、speak() メソッドを呼び出すと、それぞれの動物の鳴き声が出力されます。このように、異なる型のオブジェクトが同じインターフェースを実装することによって、ポリモフィズムを実現することができます。

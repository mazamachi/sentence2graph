# sentence2graph
文章の流れを可視化します

# Usage
MeCab, CaboCha, Graphvizをインストールしておいてください。
```
$ bundle install
$ ruby generate_graph.rb hogehoge.txt (name) (-n)
``` 
とすると、hogehoge.dot及びhogehoge.png(nameにfugaを指定した場合はfuga.dot, fuga.png)が生成されます。

詳細はブログで。

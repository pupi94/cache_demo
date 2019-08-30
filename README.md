![](https://l.ruby-china.com/photo/2019/dfa43de9-83cb-460f-8629-33a738c1ef14.png!large)

#### 清理缓存时的性能问题
在第一版的代码中，数据有改变时我是用 `Rails.cache.delete_matched("products/*")` 来清理相关的缓存的

```ruby
 def delete_matched(matcher, options = nil)
    instrument :delete_matched, matcher do
      unless String === matcher
        raise ArgumentError, "Only Redis glob strings are supported: #{matcher.inspect}"
      end
      redis.with do |c|
        pattern = namespace_key(matcher, options)
        cursor = "0"
        # Fetch keys in batches using SCAN to avoid blocking the Redis server.
        begin
          # SCAN_BATCH_SIZE 默认值为 1000
          cursor, keys = c.scan(cursor, match: pattern, count: SCAN_BATCH_SIZE)
          c.del(*keys) unless keys.empty?
        end until cursor == "0"
      end
    end
  end
```
通过查看 RedisCacheStore 中 delete_matched 方法的代码可以知道它会不断迭代并匹配相关的key，直到遍历完整个数据库。
当数据量比较大时，会执行相当长的时间，导致api超时。比如有5万个数据，这里就会执行50次 `scan` 。

因此这里进行了如下优化，写入 cache 的同时将 cache key 存储到 redis set，清理 cache 时将 redis set 中的 cache key 取出来然后删除对应 key 的缓存
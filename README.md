# docker-rocksdb-ruby
Playing around with [Facebook's rocksdb](https://github.com/facebook/rocksdb) via [rocksdb-ruby](https://github.com/isamu/rocksdb-ruby).

```
$ mkdir rocksdb-ruby && cd rocksdb-ruby && curl https://raw.githubusercontent.com/phillbaker/docker-rocksdb-ruby/master/Dockerfile > Dockerfile
$ docker build -t rocksdb-ruby .
$ docker run -t -i rocksdb-ruby bash
root@rocksdb-ruby# LD_LIBRARY_PATH="/tmp/rocksdb:$LD_LIBRARY_PATH" irb
(irb)> require 'rocksdb' #=> true
(irb)> rocksdb = RocksDB::DB.new "/tmp/db.rocks" #=> #<RocksDB::DB:0x000000028558e8>
(irb)> rocksdb.put("key", rand().to_s) #=> true
(irb)> rocksdb.get("key") #=> "0.22830520523610154"
```

## Notes

Note that `rocksdb` _only_ deals with byte strings, so [drivers inherit the same limitation](http://pyrocksdb.readthedocs.org/en/latest/tutorial/index.html#about-bytes-and-unicode). So all keys and values should be stored as strings and can be coerced into types or objects can be marshalled from strings. So for example, a safe way to marshal and store data:

```
data = ::Base64.encode64(Marshal.dump(object))
rocksdb.put("key", data)
```

and unmarshaling the object:

```
data = rocksdb.get("key")
retrieved_object = Marshal.load(::Base64.decode64(data))
```

For higher performance and living on the bleeding edge, the Base64 encoding could probably be dropped since Rocksdb should handle binary strings without issues.

# fs_fifo ReadMe

## Fixed Size FIFO, LIFO, Array lib.

fs_fifo.rb defines FSFIFO, which is the fixed size FIFO (Queue).

This extends the built-in Array so you can easily understand it.

(fs_fifo.rb also defines FSArray and FSLIFO. FSArray is the most general class)

## Useage

You can create a FIFO whose size is 4 by:

```
>>fsf = FSFIFO.new( size: 4 )
=> []
>> fsf.size
=> 0
>> fsf.fifosize
=> 4
```

Here, FSFIFO#size means the number of elements and FSFIFO#fifosize means the size of FIFO.

And you can push objects like this:

```
>> fsf.push( 1 )
=> [1]

>> fsf.push( 2 )
=> [1, 2]

>> fsf.push( 3 )
=> [1, 2, 3]

>> fsf.push( 4 )
=> [1, 2, 3, 4]

>> fsf.push( 5 )
=> [2, 3, 4, 5]
```

You can also shift and resize.

```
>> fsf
=> [2, 3, 4, 5]
>> fsf.shift
=> 2
>> fsf
=> [3, 4, 5]
>> fsf.resize( 2 )
=> [3]
>> fsf
=> [4, 5]
>> fsf.push( 6 )
=> [5, 6]
```


## License

MIT License.


# End

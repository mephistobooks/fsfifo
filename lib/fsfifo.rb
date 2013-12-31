#
# filename: fs_fifo.rb
#
#


#
# Fixed Size FIFO, LIFO, and Array.
#
#
class FSArray < Array

  FSARRAY_SIZE_DEFAULT = 1

  # Fixed-size Array.
  # ==== Args
  # _size :: size of FSArray.
  # size: :: same above.
  # of_enable: :: Overflow proc enable: true (enable)/false (disable)
  # of_proc: :: Overflow proc itself.
  # uf_enable: :: Underflow proc enable: true (enable)/false (disable)
  # uf_proc: :: Underflow proc itself.
  # wm_size: Water mark ( <= fsarray size )
  # wm_proc: Water mark proc.
  # ==== Usage
  # * FSArray#new( n )
  # * FSArray#new( size: n, of_enable: true, of_proc: Proc.new{...} )
  # * FSArray.new[ -1 ] :: newly pushed data.
  # * FSArray.new[ 0 ] :: first-out data.
  # ==== Return
  # Object of FSArray.
  def initialize( _size = FSARRAY_SIZE_DEFAULT,
                  size: FSARRAY_SIZE_DEFAULT,
                  of_enable: false, of_proc: Proc.new{ raise "Overflow!" },
                  uf_enable: false, uf_proc: Proc.new{ raise "Underflow!" },
                  push_enable: false, push_proc: Proc.new{},
                  wm_size: 1,
                  wm_enable: false, wm_proc: Proc.new{ raise "Reached WM!" }
                )

    raise "Watermark #{wm_size} is out of range[0,#{size}]" if
      wm_size < 0 or wm_size > size

    size = _size if _size != FSARRAY_SIZE_DEFAULT
    @opt = {
      :size    => size,
      :of_enable => of_enable,
      :of_proc => of_proc,
      :uf_enable => uf_enable,
      :uf_proc => uf_proc,
      :push_enable => push_enable, #TODO.
      :push_proc => push_proc,
      :wm_size => wm_size,
      :wm_enable => wm_enable,
      :wm_proc => wm_proc,
    }

    @shifted = nil  #TODO.

    #
    super( )

  end

  #
  # Over/Underflow callback methods getter/setter, etc.
  #
  ["o", "u"].each{|which|
    eval("def #{which}f_proc; @opt[:#{which}f_proc]; end")
    eval("def #{which}f_proc=(newp); @opt[:#{which}f_proc] = newp; end")
    eval("def #{which}f_enable?; @opt[:#{which}f_enable]; end")
    eval("def #{which}f_enable; @opt[:#{which}f_enable]  = true; end")
    eval("def #{which}f_disable; @opt[:#{which}f_enable] = false; end")
  }

  #
  # FIFO and data size-related methods.
  #
  def fifosize; @opt[:size]; end
  # Array#size indicates the number of elements in fifo.
  def resize( n )
    ret = []
    @opt[:wm_size] = n if @opt[:size] == @opt[:wm_size]
    @opt[:size] = n
    ret << self.shift_org while self.size > n

    return ret
  end
 
  #
  alias :shift_org :shift
  alias :push_org :push

  #
  # shift and push - main methods of FSFIFO.
  #
  def shift

    # callback method when under flow is enabled.
    @opt[:uf_proc].call if self.size == 0 and @opt[:uf_enable]

    ret = shift_org

    return ret
  end

  def push( obj )

    #
    push_org( obj )

    #
    of_called = false
    wm_called = false
    while self.size > @opt[:size]
      #
      shift_org

      # overflow callback.
      if @opt[:of_enable] and not(of_called)
        @opt[:of_proc].call
        of_called = true
      end

      # TODO.watermark callback.
      if @opt[:wm_enable] and not(wm_called)
        @opt[:wm_proc].call
        wm_called = true
      else
        #raise ""
      end
    end

    return self
  end

end


class FSFIFO < FSArray
  undef pop
end

class FSLIFO < FSArray
  undef shift
end


#### endof filename: fixed_array.rb

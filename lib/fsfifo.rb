#
# filename: fs_fifo.rb
#
#


#
# Fixed Size FIFO, LIFO, and Array.
#
#
class FSArray < Array

  #
  # FSArray#new( n )
  # FSArray#new( size: n, of_enbl: true, of_proc: Proc.new{...} )
  #
  def initialize( args = {} )

    if args.class == Fixnum
      args = { size: args, wm_size: args }
    end

    @opt = {
      :size => 1,
      :of_enbl => false,
      :of_proc => Proc.new{},
      :uf_enbl => false,
      :uf_proc => Proc.new{},
      :wm_size => 1,
      :wm_enbl => false,
      :wm_proc => Proc.new{},
    }.merge( args )

    #
    super( )

  end

  #
  # Over/underflow callback methods getter/setter, etc.
  #
  def of_proc; @opt[:of_proc]; end
  def of_proc=( newp ); @opt[:of_proc] = newp; end
  def of_enable; @opt[:of_enbl] = true; end
  def of_disable; @opt[:of_enbl] = false; end
  def of_enable?; @opt[:of_enbl] ; end

  def uf_proc; @opt[:uf_proc]; end
  def uf_proc=( newp ); @opt[:uf_proc] = newp; end
  def uf_enable; @opt[:uf_enbl] = true; end
  def uf_disable; @opt[:uf_enbl] = false; end
  def uf_enable?; @opt[:uf_enbl] ; end

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
    ret = shift_org

    # callback method when under flow is enabled.
    if self.size == 0
      if @opt[:uf_enbl]
        @opt[:uf_proc].call
      end
    end

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
      if @opt[:of_enbl] and not(of_called)
        @opt[:of_proc].call
        of_called = true
      end

      # TODO.watermark callback.
      if @opt[:wm_enbl] and not(wm_called)
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

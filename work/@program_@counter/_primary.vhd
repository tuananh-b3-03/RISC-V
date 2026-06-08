library verilog;
use verilog.vl_types.all;
entity Program_Counter is
    port(
        clk             : in     vl_logic;
        reset           : in     vl_logic;
        StallF          : in     vl_logic;
        PC_in           : in     vl_logic_vector(31 downto 0);
        PC_out          : out    vl_logic_vector(31 downto 0)
    );
end Program_Counter;

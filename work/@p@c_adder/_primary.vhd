library verilog;
use verilog.vl_types.all;
entity PC_adder is
    port(
        PC_now          : in     vl_logic_vector(31 downto 0);
        PC_next         : out    vl_logic_vector(31 downto 0)
    );
end PC_adder;

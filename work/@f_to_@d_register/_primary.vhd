library verilog;
use verilog.vl_types.all;
entity F_to_D_register is
    port(
        clk             : in     vl_logic;
        reset           : in     vl_logic;
        FlushD          : in     vl_logic;
        StallD          : in     vl_logic;
        InstrF          : in     vl_logic_vector(31 downto 0);
        PC_nowF         : in     vl_logic_vector(31 downto 0);
        PC_plus4F       : in     vl_logic_vector(31 downto 0);
        InstrD          : out    vl_logic_vector(31 downto 0);
        PC_nowD         : out    vl_logic_vector(31 downto 0);
        PC_plus4D       : out    vl_logic_vector(31 downto 0)
    );
end F_to_D_register;

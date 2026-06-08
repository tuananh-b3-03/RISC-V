library verilog;
use verilog.vl_types.all;
entity Data_Memory is
    port(
        clk             : in     vl_logic;
        addr            : in     vl_logic_vector(31 downto 0);
        write_data      : in     vl_logic_vector(31 downto 0);
        read_data       : out    vl_logic_vector(31 downto 0);
        MemWrite        : in     vl_logic
    );
end Data_Memory;

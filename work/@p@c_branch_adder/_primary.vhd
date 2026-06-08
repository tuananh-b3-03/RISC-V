library verilog;
use verilog.vl_types.all;
entity PC_branch_adder is
    port(
        PC_now          : in     vl_logic_vector(31 downto 0);
        ImmExt          : in     vl_logic_vector(31 downto 0);
        PCTarget        : out    vl_logic_vector(31 downto 0)
    );
end PC_branch_adder;

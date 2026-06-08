library verilog;
use verilog.vl_types.all;
entity Hazard_unit is
    port(
        Rs1E            : in     vl_logic_vector(4 downto 0);
        Rs2E            : in     vl_logic_vector(4 downto 0);
        RdM             : in     vl_logic_vector(4 downto 0);
        RdW             : in     vl_logic_vector(4 downto 0);
        RegWriteM       : in     vl_logic;
        RegWriteW       : in     vl_logic;
        Rs1D            : in     vl_logic_vector(4 downto 0);
        Rs2D            : in     vl_logic_vector(4 downto 0);
        RdE             : in     vl_logic_vector(4 downto 0);
        ResultSrcE0     : in     vl_logic;
        PCSrcE          : in     vl_logic;
        ForwardAE       : out    vl_logic_vector(1 downto 0);
        ForwardBE       : out    vl_logic_vector(1 downto 0);
        StallF          : out    vl_logic;
        StallD          : out    vl_logic;
        FlushE          : out    vl_logic;
        FlushD          : out    vl_logic;
        lwStall         : out    vl_logic
    );
end Hazard_unit;

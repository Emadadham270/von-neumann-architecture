library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_textio.all;
use std.textio.all;

entity tb_registers is
end tb_registers;

architecture test of tb_registers is

    -- Component declaration for the Unit Under Test (UUT)
    component register_file is
        port (
            clk      : in std_logic;
            reset    : in std_logic;
            rf_wr_en : in std_logic;
            rf_wr_addr : in std_logic_vector(2 downto 0);
            rf_wr_data : in std_logic_vector(31 downto 0);
            rf_rd_addr1 : in std_logic_vector(2 downto 0);
            rf_rd_data1 : out std_logic_vector(31 downto 0);
            rf_rd_addr2 : in std_logic_vector(2 downto 0);
            rf_rd_data2 : out std_logic_vector(31 downto 0)
        );
    end component;

    -- Signals
    signal clk         : std_logic := '0';
    signal reset       : std_logic := '0';
    signal rf_wr_en    : std_logic := '0';
    signal rf_wr_addr  : std_logic_vector(2 downto 0) := (others => '0');
    signal rf_wr_data  : std_logic_vector(31 downto 0) := (others => '0');
    signal rf_rd_addr1 : std_logic_vector(2 downto 0) := (others => '0');
    signal rf_rd_data1 : std_logic_vector(31 downto 0);
    signal rf_rd_addr2 : std_logic_vector(2 downto 0) := (others => '0');
    signal rf_rd_data2 : std_logic_vector(31 downto 0);

    -- Clock period
    constant clk_period : time := 10 ns;

begin

    -- Instantiate the Unit Under Test (UUT)
    uut: register_file
        port map (
            clk         => clk,
            reset       => reset,
            rf_wr_en    => rf_wr_en,
            rf_wr_addr  => rf_wr_addr,
            rf_wr_data  => rf_wr_data,
            rf_rd_addr1 => rf_rd_addr1,
            rf_rd_data1 => rf_rd_data1,
            rf_rd_addr2 => rf_rd_addr2,
            rf_rd_data2 => rf_rd_data2
        );

    -- Clock process definition
    clk_process: process
    begin
        clk <= '0';
        wait for clk_period/2;
        clk <= '1';
        wait for clk_period/2;
    end process;

    -- Stimulus process
    stim_proc: process
        variable L: line;
    begin
        -- Apply reset
        write(L, string'("Applying reset...")); writeline(output, L);
        reset <= '1';
        wait for clk_period;
        reset <= '0';
        wait for clk_period;
        write(L, string'("Reset done.")); writeline(output, L);

        -- Test 1: Write to R3 and read from both ports
        write(L, string'("Test 1: Write to R3, read from both ports.")); writeline(output, L);
        rf_wr_en <= '1';
        rf_wr_addr <= "011"; -- R3
        rf_wr_data <= x"AAAAAAAA";
        wait for clk_period;
        rf_wr_en <= '0';
        
        -- Set up read addresses
        rf_rd_addr1 <= "011";
        rf_rd_addr2 <= "011";
        wait for clk_period/4; -- Wait for async read to propagate

        assert rf_rd_data1 = x"AAAAAAAA" report "Test 1a FAILED: R3 read was " & to_hstring(rf_rd_data1) severity error;
        assert rf_rd_data2 = x"AAAAAAAA" report "Test 1b FAILED: R3 read was " & to_hstring(rf_rd_data2) severity error;
        write(L, string'("Test 1 PASSED.")); writeline(output, L);
        wait for clk_period;

        -- Test 2: Write to R1 and R5, then read them back
        write(L, string'("Test 2: Write R1 and R5, then read.")); writeline(output, L);
        rf_wr_en <= '1';
        rf_wr_addr <= "001"; -- R1
        rf_wr_data <= x"11111111";
        wait for clk_period;

        rf_wr_addr <= "101"; -- R5
        rf_wr_data <= x"55555555";
        wait for clk_period;
        rf_wr_en <= '0';

        rf_rd_addr1 <= "001"; -- Read R1
        rf_rd_addr2 <= "101"; -- Read R5
        wait for clk_period/4;

        assert rf_rd_data1 = x"11111111" report "Test 2a FAILED: R1 read was " & to_hstring(rf_rd_data1) severity error;
        assert rf_rd_data2 = x"55555555" report "Test 2b FAILED: R5 read was " & to_hstring(rf_rd_data2) severity error;
        write(L, string'("Test 2 PASSED.")); writeline(output, L);
        wait for clk_period;

        -- Test 3: Overwriting a register
        write(L, string'("Test 3: Overwrite R1.")); writeline(output, L);
        rf_wr_en <= '1';
        rf_wr_addr <= "001"; -- R1
        rf_wr_data <= x"FFFFFFFF";
        wait for clk_period;
        rf_wr_en <= '0';

        rf_rd_addr1 <= "001";
        rf_rd_addr2 <= "001";
        wait for clk_period/4;
        
        assert rf_rd_data1 = x"FFFFFFFF" report "Test 3 FAILED: R1 overwrite was not successful." severity error;
        write(L, string'("Test 3 PASSED.")); writeline(output, L);
        wait for clk_period;

        write(L, string'("All tests passed!")); writeline(output, L);
        wait; -- end simulation
    end process;

end architecture;

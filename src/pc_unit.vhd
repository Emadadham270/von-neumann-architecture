library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pc_unit is
    port (
        clk         : in  std_logic;
        reset       : in  std_logic;
        pc_load_en  : in  std_logic; -- Enable loading a new address (for branches/jumps)
        pc_inc_en   : in  std_logic; -- Enable incrementing the PC (for sequential execution)
        pc_in       : in  std_logic_vector(31 downto 0); -- Address to load
        pc_out      : out std_logic_vector(31 downto 0)  -- Current PC address
    );
end entity;

architecture behavioral of pc_unit is
    signal pc_reg : unsigned(31 downto 0);
begin
    process(clk, reset)
    begin
        if reset = '1' then
            pc_reg <= (others => '0');
        elsif rising_edge(clk) then
            if pc_load_en = '1' then
                pc_reg <= unsigned(pc_in);
            elsif pc_inc_en = '1' then
                pc_reg <= pc_reg + 1;
            end if;
        end if;
    end process;

    pc_out <= std_logic_vector(pc_reg);
end architecture;

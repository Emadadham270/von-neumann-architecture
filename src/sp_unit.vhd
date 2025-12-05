library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity sp_unit is
    port (
        clk         : in  std_logic;
        reset       : in  std_logic;
        sp_load_en  : in  std_logic; -- Enable loading a new value
        sp_inc_en   : in  std_logic; -- Enable incrementing (e.g., for pop)
        sp_dec_en   : in  std_logic; -- Enable decrementing (e.g., for push)
        sp_in       : in  std_logic_vector(31 downto 0);  -- Value to load
        sp_out      : out std_logic_vector(31 downto 0)   -- Current SP value
    );
end entity;

architecture behavioral of sp_unit is
    signal sp_reg : unsigned(31 downto 0);
begin
    process(clk, reset)
    begin
        if reset = '1' then
            sp_reg <= (others => '0');
        elsif rising_edge(clk) then
            if sp_load_en = '1' then
                sp_reg <= unsigned(sp_in);
            elsif sp_inc_en = '1' then
                sp_reg <= sp_reg + 1;
            elsif sp_dec_en = '1' then
                sp_reg <= sp_reg - 1;
            end if;
        end if;
    end process;

    sp_out <= std_logic_vector(sp_reg);
end architecture;
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity register_file is
    port (
        clk      : in std_logic;
        reset  : in std_logic;

        -- Write Port
        rf_wr_en : in std_logic;
        rf_wr_addr : in std_logic_vector(2 downto 0);
        rf_wr_data : in std_logic_vector(31 downto 0);

        -- Read Port 1
        rf_rd_addr1 : in std_logic_vector(2 downto 0);
        rf_rd_data1 : out std_logic_vector(31 downto 0);

        -- Read Port 2
        rf_rd_addr2 : in std_logic_vector(2 downto 0);
        rf_rd_data2 : out std_logic_vector(31 downto 0)
    );
end register_file;

architecture behavioral of register_file is
    -- Signal for the register file, 8 registers of 32 bits each.
    type reg_file_type is array (0 to 7) of std_logic_vector(31 downto 0);
    signal reg_file : reg_file_type := (others => (others => '0'));

begin

    -- Write Port
    -- Writes data to the specified register on the rising edge of the clock.
    process (clk, reset)
    begin
        if reset = '1' then
            reg_file <= (others => (others => '0'));
        elsif rising_edge(clk) then
            if rf_wr_en = '1' then
                reg_file(to_integer(unsigned(rf_wr_addr))) <= rf_wr_data;
            end if;
        end if;
    end process;

    -- Read Port 1
    -- Asynchronously reads data from the specified register.
    rf_rd_data1 <= reg_file(to_integer(unsigned(rf_rd_addr1)));

    -- Read Port 2
    -- Asynchronously reads data from the specified register.
    rf_rd_data2 <= reg_file(to_integer(unsigned(rf_rd_addr2)));

end behavioral;

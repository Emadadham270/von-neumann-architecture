library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity alu is
    port (
    clk   : in std_logic;
    reset : in std_logic;

    -- control signals
    control_signal : in std_logic_vector(31 downto 0);

    -- inputs
    operand1 : in std_logic_vector(31 downto 0);
    operand2 : in std_logic_vector(31 downto 0);

    result : out std_logic_vector(31 downto 0);
    flags : out std_logic_vector(2 downto 0) -- zero = flags[0], carry = flags[1], negative = flags[2]
    );
end entity alu;

architecture rtl of alu is

  -- Signals
  signal zeroFlag : integer := 0;
  signal carryFlag : integer := 1;
  signal negativeFlag : integer := 2;
  

begin

    process (clk) is
    variable temp : std_logic_vector(32 downto 0); --33bits

    begin
        if (reset = '1') then
            result <= (others => '0');

        elsif rising_edge(clk) then
            case control_signal is
                when "001" => -- add
                    result <= operand1 + operand2;
                    temp := operand1 + operand2;
                    if (temp(32) = '1') then
                        flags(zeroFlag) <= 1;
                    end if;


                when "010" => -- sub
                    result <= operand1 - operand2;

                when "654" => -- and
                    result <= operand1 and operand2;

                when "abc" => -- not
                    result <= not operand1;

                when "efg" => -- increment
                    result <= operand1 + 1;
                end case;
        end if;
    end process;

end architecture rtl;

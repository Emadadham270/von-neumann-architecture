library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity alu is
    port (
    clk   : in std_logic;
    reset : in std_logic;

    -- control signals
    control_signal : in std_logic_vector(2 downto 0);

    -- inputs (assume signed inputs)
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
        variable result_ext : signed(32 downto 0);
        variable result_temp : signed(31 downto 0);

    begin
        if (reset = '1') then
            result <= (others => '0');
            flags <= (others => '0');

        elsif rising_edge(clk) then
            case control_signal is
                -- ADD
                when "001" =>                     
                    result_ext := resize(signed(operand1), 33) + resize(signed(operand2), 33);
                    result_temp := result_ext(31 downto 0);

                    result <= std_logic_vector(result_temp);

                    flags <= (others => '0');

                    if (result_temp = 0) then
                        flags(zeroFlag) <= '1';
                    end if;

                    flags(negativeFlag) <= result_temp(31);

                    flags(carryFlag) <= result_ext(32);

                -- SUB
                when "010" => 
                    result_ext := resize(signed(operand1), 33) - resize(signed(operand2), 33);
                    result_temp := result_ext(31 downto 0);

                    result <= std_logic_vector(result_temp);

                    flags <= (others => '0');

                    if (result_temp = 0) then
                        flags(zeroFlag) <= '1';
                    end if;

                    flags(negativeFlag) <= result_temp(31);

                    flags(carryFlag) <= result_ext(32);

                -- AND
                when "011" =>
                    result_temp := signed(operand1) and signed(operand2);
                    result <= std_logic_vector(result_temp);

                    flags <= (others => '0');

                    if (result_temp = 0) then
                        flags(zeroFlag) <= '1';
                    end if;

                    flags(negativeFlag) <= result_temp(31);

                -- NOT
                when "100" => 
                    result_temp := not signed(operand1);
                    result <= std_logic_vector(result_temp);

                    flags <= (others => '0');

                    if (result_temp = 0) then
                        flags(zeroFlag) <= '1';
                    end if;

                    flags(negativeFlag) <= result_temp(31);

                -- Increment
                when "101" => 
                    result_ext := resize(signed(operand1), 33) + 1;
                    result_temp := result_ext(31 downto 0);

                    result <= std_logic_vector(result_temp);

                    flags <= (others => '0');

                    if (result_temp = 0) then
                        flags(zeroFlag) <= '1';
                    end if;

                    flags(negativeFlag) <= result_temp(31);

                    flags(carryFlag) <= result_ext(32);
                when others =>
                    result <= (others => '0');
                    flags  <= (others => '0');
                end case;
        end if;
    end process;

end architecture rtl;

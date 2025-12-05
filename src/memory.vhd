-- src/memory.vhd  (CRASH-PROOF LOADER)
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity memory is
  port (
    clk        : in  std_logic;
    rst_n      : in  std_logic;
    addr       : in  std_logic_vector(11 downto 0);
    we         : in  std_logic;
    write_data : in  std_logic_vector(31 downto 0);
    read_data  : out std_logic_vector(31 downto 0)
  );
end entity memory;

architecture rtl of memory is

  type mem_t is array (0 to 4095) of std_logic_vector(31 downto 0);

  function hex8_to_slv(s : string) return std_logic_vector is
    variable r : std_logic_vector(31 downto 0);
    variable v : unsigned(31 downto 0) := (others => '0');
  begin
    v := to_unsigned(0, 32);
    for i in 1 to 8 loop
      v := shift_left(v, 4);
      if s(i) >= '0' and s(i) <= '9' then
        v := v + to_unsigned(character'pos(s(i)) - character'pos('0'), 32);
      elsif s(i) >= 'A' and s(i) <= 'F' then
        v := v + to_unsigned(10 + character'pos(s(i)) - character'pos('A'), 32);
      elsif s(i) >= 'a' and s(i) <= 'f' then
        v := v + to_unsigned(10 + character'pos(s(i)) - character'pos('a'), 32);
      end if;
    end loop;
    r := std_logic_vector(v);
    return r;
  end function;

  impure function load_mem return mem_t is
    file f         : text open read_mode is "mem/program.mem";
    variable l     : line;
    variable hexstr: string(1 to 8);
    variable tmp   : mem_t := (others => (others => '0'));
    variable idx   : integer := 0;
  begin
    while not endfile(f) loop
      readline(f, l);
      if l.all'length < 8 then
        next;
      end if;
      read(l, hexstr);
      tmp(idx) := hex8_to_slv(hexstr);
      idx := idx + 1;
      if idx > tmp'high then
        report "program.mem truncated to 4096 words" severity warning;
        exit;
      end if;
    end loop;
    return tmp;
  end function;

  signal mem : mem_t := load_mem;

begin

  write_proc : process(clk)
  begin
    if rising_edge(clk) then
      if we = '1' then
        mem(to_integer(unsigned(addr))) <= write_data;
      end if;
    end if;
  end process;

  read_proc : process(addr, mem)
  begin
    read_data <= mem(to_integer(unsigned(addr)));
  end process;

end architecture rtl;

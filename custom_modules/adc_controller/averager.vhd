-- averager.vhd

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity averager is
	port (
		clk		: in	std_logic := '0';
		a     	: in	unsigned(15 downto 0);
        a_ready : in    std_logic := '0';
        b     	: in	unsigned(15 downto 0);
        b_ready : in    std_logic := '0';
        o       : out   unsigned(15 downto 0);
		o_ready : out	std_logic
	);
end entity averager;

architecture rtl of averager is
	signal i       : unsigned(15 downto 0) := x"0000";
    signal t       : unsigned(15 downto 0) := x"0000";
    signal i_ready : std_logic := '0';
begin
	main_proc : process (clk)
	begin
		if(rising_edge(clk)) then
            if(a_ready = '1' and b_ready = '1') then
                i_ready <= '1';
            else
                i_ready <= '0';
            end if;

            o_ready <= i_ready;
            o <= i;
		end if;

	end process main_proc;

    t <= a + b;
    i <= '0' & t(15 downto 1);

end architecture rtl; -- of averager

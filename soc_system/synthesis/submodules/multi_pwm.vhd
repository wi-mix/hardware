library altera;
use altera.altera_europa_support_lib.all;
-- Created by Darius Grigaitis 2009 www.grigaitis.eu
-- Repurposed for use by Group 5, uAlberta ECE 2016
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity multi_pwm is
	generic(W:integer :=32);
	port (       
		-- Avalon MM-----------
		clk : in std_logic;
		reset_n : in std_logic;
		writas : in std_logic;
		address : in std_logic_vector(5 downto 0);
		writedata : in std_logic_vector(31 downto 0);
		PWM1, PWM2, PWM3, PWM4: out std_logic
	); 
end multi_pwm;

architecture PWM of multi_pwm is   
	signal  pwm_counter, pwm_value1, 
		pwm_value2, pwm_value3, pwm_value4: std_logic_vector(W downto 0);
	signal control_reg:  std_logic_vector(7 downto 0);
begin
	process (clk, reset_n)
	begin
		if reset_n='0' then
			pwm_counter<=(others=>'0'); 
			pwm_value1<=(others=>'0'); 
			pwm_value2<=(others=>'0');
			pwm_value3<=(others=>'0');
			pwm_value4<=(others=>'0');
		elsif clk'event and clk='1' then
			----------------------------------- PWM set -------------------------
			if address = "000000" and writas = '0' then -- PWM UPDATE COUNTER 
				pwm_value1<=writedata(W downto 0);
			end if;

			if  address = "000001" and writas = '0' then -- PWM UPDATE COUNTER 
				pwm_value2<=writedata(W downto 0);
			end if;

			if address = "000010" and writas = '0' then -- PWM UPDATE COUNTER 
				pwm_value3<=writedata(W downto 0);
			end if;

			if address = "000011" and writas = '0' then -- PWM UPDATE COUNTER 
				pwm_value4<=writedata(W downto 0);
			end if;

			----------------- PWM signal formation ------------

			pwm_counter<=pwm_counter+1;

			if (pwm_counter = x"00098968") then
				pwm_counter <= x"00000000";
			end if;

			if ((pwm_counter<pwm_value1)and (pwm_value1>0)) then
				PWM1<='1';
			else PWM1<='0'; end if; 

			if ((pwm_counter<pwm_value2)and (pwm_value2>0)) then
				PWM2<='1';
			else PWM2<='0'; end if; 

			if ((pwm_counter<pwm_value3)and (pwm_value3>0)) then
				PWM3<='1';
			else PWM3<='0'; end if; 

			if ((pwm_counter<pwm_value4)and (pwm_value4>0)) then
				PWM4<='1';
			else PWM4<='0'; end if; 
		end if;
	end process;
end PWM;

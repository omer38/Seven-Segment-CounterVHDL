library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;


entity hexadecimal_counter is
 Port ( basysClk : in STD_LOGIC;
 reset : in STD_LOGIC;
 anode_activate : out STD_LOGIC_VECTOR (3 downto 0);
 segment_led : out STD_LOGIC_VECTOR (6 downto 0));
end hexadecimal_counter;


architecture Behavioral of hexadecimal_counter is
signal enable: std_logic;
signal count_second: STD_LOGIC_VECTOR (27 downto 0);
signal figure_displayed: STD_LOGIC_VECTOR (15 downto 0);
signal set_LED: std_logic_vector(1 downto 0);
signal bcd_LED: STD_LOGIC_VECTOR (3 downto 0);
signal restart: STD_LOGIC_VECTOR (19 downto 0);

begin

process(bcd_LED)

begin
 case bcd_LED is
 when "0000" => segment_led <= "0000001"; -- "0" 
 when "0001" => segment_led <= "1001111"; -- "1" 
 when "0010" => segment_led <= "0010010"; -- "2" 
 when "0011" => segment_led <= "0000110"; -- "3" 
 when "0100" => segment_led <= "1001100"; -- "4" 
 when "0101" => segment_led <= "0100100"; -- "5" 
 when "0110" => segment_led <= "0100000"; -- "6" 
 when "0111" => segment_led <= "0001111"; -- "7" 
 when "1000" => segment_led <= "0000000"; -- "8" 
 when "1001" => segment_led <= "0000100"; -- "9" 
 when "1010" => segment_led <= "0000010"; -- a
 when "1011" => segment_led <= "1100000"; -- b
 when "1100" => segment_led <= "0110001"; -- C
 when "1101" => segment_led <= "1000010"; -- d
 when "1110" => segment_led <= "0110000"; -- E
 when "1111" => segment_led <= "0111000"; -- F
 end case;
 
end process;

process(basysClk,reset)
begin 
 if(reset='1') then
 restart <= (others => '0');
 elsif(rising_edge(basysClk)) then
 restart <= restart + 1;
 end if;
end process;

set_LED <= restart(19 downto 18);

process(set_LED)
begin
 case set_LED is
 when "00" =>
 anode_activate <= "0111"; 
 bcd_LED <= figure_displayed(15 downto 12);
 when "01" =>
 anode_activate <= "1011";
 bcd_LED <= figure_displayed(11 downto 8);
 when "10" =>
 anode_activate <= "1101";
 bcd_LED <= figure_displayed(7 downto 4);
 when "11" =>
 anode_activate <= "1110"; 
 bcd_LED <= figure_displayed(3 downto 0); 
 end case;
end process;

process(basysClk, reset)
begin
 if(reset='1') then
 count_second <= (others => '0');
 elsif(rising_edge(basysClk)) then
 if(count_second>=x"5F5E0FF") then
 count_second <= (others => '0');
 else
 count_second <= count_second + "0000001";
 end if;
 end if;

end process;

enable <= '1' when count_second=x"5F5E0FF" else '0';
process(basysClk, reset)
begin
 if(reset='1') then
 figure_displayed <= (others => '0');
 elsif(rising_edge(basysClk)) then
 if(enable='1') then
 figure_displayed <= figure_displayed + x"0001";
 end if;
 end if;
 
end process;
end Behavioral;

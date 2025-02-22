---------------------------------------------------------------------------------------------
--
--	Université de Sherbrooke 
--  Département de génie électrique et génie informatique
--
--	S4i - APP3 
--	
--
--	Auteur: 		Vincent Simard-Schmidt
--					Maxime Aubin
-- 
---------------------------------------------------------------------------------------------


library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.all;
use work.MIPS32_package.all;

entity BancRegistresVectoriels is
    Port ( clk       : in  std_logic;
           reset     : in  std_logic;
           i_RS1     : in  std_logic_vector (4 downto 0);
           i_RS2     : in  std_logic_vector (4 downto 0);
           i_Wr_DAT  : in  std_logic_vector (127 downto 0);
           i_WDest   : in  std_logic_vector (4 downto 0);
           i_WE 	 : in  std_logic;
           o_RS1_DAT : out std_logic_vector (127 downto 0);
           o_RS2_DAT : out std_logic_vector (127 downto 0));
end BancRegistresVectoriels;

architecture Behavioral of BancRegistresVectoriels is
    signal regs: RAM_SIMD(0 to 31) := (others => (others => '0'));
begin
    process( clk )
    begin
        if clk='1' and clk'event then
            if i_WE = '1' and reset = '0' then
                regs( to_integer( unsigned(i_WDest))) <= i_Wr_DAT;
            end if;
        end if;
    end process;
    
    o_RS1_DAT <= regs( to_integer(unsigned(i_RS1)));
    o_RS2_DAT <= regs( to_integer(unsigned(i_RS2)));
end Behavioral;

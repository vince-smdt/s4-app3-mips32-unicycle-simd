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

entity BancRegistresVectoriels is --Nouvelle entree 3-0
    Port ( clk       : in  std_logic;
           reset     : in  std_logic;
           i_RS1     : in  std_logic_vector (4 downto 0);
           i_RS2     : in  std_logic_vector (4 downto 0);
           i_Wr_DAT  : in  std_logic_vector (127 downto 0);
           i_WDest   : in  std_logic_vector (4 downto 0);
           i_WE 	 : in  std_logic;
           i_Wr_Perm : in std_logic_vector  (3 downto 0);
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
                if i_Wr_Perm(3) = '1' then --Index 3
                    regs( to_integer( unsigned(i_WDest)))(127 downto 96) <= i_Wr_DAT(127 downto 96);
                end if;
                if i_Wr_Perm(2) = '1' then -- index 2
                    regs( to_integer( unsigned(i_WDest)))(95 downto 64) <= i_Wr_DAT(95 downto 64);
                end if;
                if i_Wr_Perm(1) = '1' then -- index 1
                    regs( to_integer( unsigned(i_WDest)))(63 downto 32) <= i_Wr_DAT(63 downto 32);
                end if;
                if i_Wr_Perm(0) = '1' then --index 0
                    regs( to_integer( unsigned(i_WDest)))(31 downto 0) <= i_Wr_DAT(31 downto 0);
                end if;

                --regs( to_integer( unsigned(i_WDest))) <= i_Wr_DAT;
            end if;
        end if;
    end process;
    
    o_RS1_DAT <= regs( to_integer(unsigned(i_RS1)));
    o_RS2_DAT <= regs( to_integer(unsigned(i_RS2)));
end Behavioral;

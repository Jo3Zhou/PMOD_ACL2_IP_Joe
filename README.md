# PMOD_ACL2_IP_Joe
PMOD_ACL2_IP_Joe
A PMOD ACL2 ip without FIFO/brust read
Simple write & read

Port: 
input:  spi_clk, miso

output: cs, sck, mosi

Specification:

spi clk need to be less than 8Mhz

Registers offset shows below:

reg0[0]	load;

reg1[7:0]	instruction;

reg2[7:0]	regsiter address;

reg3[7:0]	data write;

reg4[7:0]	data read;


Write process in ILA shows below
![image](https://user-images.githubusercontent.com/102744628/179319117-75381ef5-71a9-4c3b-afc9-8df2b577546d.png)

Read process in ILA shows below:
(Read register 0x00, reset(default) value shows below in ADXL362)
![image](https://user-images.githubusercontent.com/102744628/179319374-a3c6399f-d139-4607-9090-14f406103fc0.png)

![image](https://user-images.githubusercontent.com/102744628/179319226-86b44868-caba-4cc0-8c25-fce86ce21fb9.png)


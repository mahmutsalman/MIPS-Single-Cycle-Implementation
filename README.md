# MIPS-Single-Cycle-Implementation
MIPS single-cycle implementation by implementing additional instructions. ModelSim simulator is used.

In this project there are 6 instructions simulated that are consisted of BMN,BRZ,JMADD,BALN,SRLV,JAL consecutively.

The instruction memory is created using IM.dat file coded in hexadecimal.

<img width="464" alt="bmn_description" src="https://user-images.githubusercontent.com/74365527/181911932-8237e448-298e-46c5-8347-b51f39b5c954.png">

<img width="561" alt="image" src="https://user-images.githubusercontent.com/74365527/181912261-b788d3db-e181-41c2-99f3-fc639d532cf0.png">

<img width="281" alt="bmn" src="https://user-images.githubusercontent.com/74365527/181909785-38a27777-8a46-447c-a1d6-a00b21cc5c37.png">

Result is examined using PC value.

BRZ instruction

<img width="570" alt="image" src="https://user-images.githubusercontent.com/74365527/181913414-18961a30-f1f8-4228-a72c-0aa97fcbacf4.png">
<img width="566" alt="image" src="https://user-images.githubusercontent.com/74365527/181913548-6f7e231d-8d83-4168-9640-c243199c4997.png">
<img width="272" alt="image" src="https://user-images.githubusercontent.com/74365527/181913602-3d5c067f-eeab-4409-8ad1-6ce6c3a961b6.png">
<img width="321" alt="image" src="https://user-images.githubusercontent.com/74365527/181913610-4e9735a9-0059-450b-9ba9-68bacd547525.png">
here sub instruction is fetched. Since $rs -$rt =0 [Z] will be ‘1’ after this instruction.
<img width="323" alt="image" src="https://user-images.githubusercontent.com/74365527/181913622-c8e0e0c3-4354-4da9-8e60-74ef1d434a72.png">
Here brz instruction is fetched. Since [Z] flag is 1 program will branch to address found in $rs which is hold in ‘dataa’(24). 

![image](https://user-images.githubusercontent.com/74365527/181913636-ac52675d-a49b-484c-bde6-c63180848970.png)

Here as shown in wave pc value is set to 11000(24)


JMADD instruction

<img width="363" alt="image" src="https://user-images.githubusercontent.com/74365527/181913642-a35f4802-566f-4984-baac-daf0ba10f67c.png">

<img width="433" alt="image" src="https://user-images.githubusercontent.com/74365527/181913663-8417f8e2-8799-4acb-81b6-f7f492e221f3.png">
<img width="348" alt="image" src="https://user-images.githubusercontent.com/74365527/181913671-94fee02d-4cef-4408-9073-2cfb5941f25a.png">
<img width="357" alt="image" src="https://user-images.githubusercontent.com/74365527/181913677-c3dbbf44-b05c-42ec-9362-e61de1a70b5a.png">


BALN instruction

<img width="483" alt="image" src="https://user-images.githubusercontent.com/74365527/181913723-340c2363-299c-464a-9648-60bb78012036.png">
<img width="513" alt="image" src="https://user-images.githubusercontent.com/74365527/181913735-a3a652a1-7022-4321-a0fc-4be1f5aa8b8c.png">

![image](https://user-images.githubusercontent.com/74365527/181913738-225ba489-f33b-42b7-ba4f-0ad1da0a0e6f.png)

![image](https://user-images.githubusercontent.com/74365527/181913743-c75da398-4831-4cf3-af11-6fca1889a1cf.png)

[N] flag =1 and balnSignal =1. So PC+4 will be target address which is 0x10

![image](https://user-images.githubusercontent.com/74365527/181913763-d447d02d-16f4-4f32-a1d0-3ad39ac36070.png)

Here as shown in the waves pc value is 0x10.

<img width="447" alt="image" src="https://user-images.githubusercontent.com/74365527/181913771-67be86af-47d2-47c0-a556-06a506f12fdd.png">

![image](https://user-images.githubusercontent.com/74365527/181913778-172cedcb-638b-4580-9299-6dbcf929cb23.png)

![image](https://user-images.githubusercontent.com/74365527/181913784-e7c0162b-3aa1-40f5-9cd5-92c4609badb6.png)

![image](https://user-images.githubusercontent.com/74365527/181913788-0f05deba-59b2-4fd7-bf3d-c882fccf455d.png)


JAL instruction

<img width="516" alt="image" src="https://user-images.githubusercontent.com/74365527/181913809-7cd5faa5-2229-477e-8bb2-8c9c1415ae0d.png">
![image](https://user-images.githubusercontent.com/74365527/181914073-14631005-5182-4a96-a7d0-5c01e20c5014.png)


![image](https://user-images.githubusercontent.com/74365527/181913816-8896ad3d-7148-4916-a812-e0526c15cf89.png)
![image](https://user-images.githubusercontent.com/74365527/181913819-9cb15df2-5772-4a5f-bda9-e943a92c8e49.png)
![image](https://user-images.githubusercontent.com/74365527/181914079-3e29d023-7424-4b37-9a4a-ce48264bcc4e.png)

As shown here jal instruction is fetched. PC=4. Target address is 0x10. So next instruction’s PC value will be 0x10.

![image](https://user-images.githubusercontent.com/74365527/181914082-9f2cec0d-60f6-4d29-bc14-5605e47c3ad1.png)

As shown in this figure PC value is 10000.




















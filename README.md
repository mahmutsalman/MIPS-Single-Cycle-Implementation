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
<img width="363" alt="image" src="https://user-images.githubusercontent.com/74365527/181913657-7c903a1d-701f-4bf3-95c6-e39fbaf05d2e.png">

<img width="433" alt="image" src="https://user-images.githubusercontent.com/74365527/181913663-8417f8e2-8799-4acb-81b6-f7f492e221f3.png">
<img width="348" alt="image" src="https://user-images.githubusercontent.com/74365527/181913671-94fee02d-4cef-4408-9073-2cfb5941f25a.png">
<img width="357" alt="image" src="https://user-images.githubusercontent.com/74365527/181913677-c3dbbf44-b05c-42ec-9362-e61de1a70b5a.png">












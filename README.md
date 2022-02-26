# Azure SDWAN Workshop

## Workshop main objectives
* Deploy through Terraform the SDWAN architecture
* Configure Azure components such as Azure Load Balancer, Azure VNET peering, Azure Route Server and Azure vWAN
* Understand the diffrent architecture options available

***
***
## Chapter1 - Setting up the environment (40min)
_[Deployment exercise - estimated duration 40min]_

<details>

### Task 1 - Setup your AzureCloud Shell 
* Login to Azure Cloud Portal https://portal.azure.com/ with the login/password that has been provided to you

    ![cloudshell1](images/cloudshell-01.jpg)
    ![cloudshell2](images/cloudshell-02.jpg)

* Click on Cloud Shell icon on the Top Right side of the portal
* Select Bash

    ![cloudshell4](images/cloudshell-04.jpg)
    ![cloudshell5](images/cloudshell-05.jpg)

* Click on **show advanced settings**

    ![cloudshell6](images/cloudshell-06.jpg)

* Select **your own resource group** , use the the storage account available in that Resource Group, use the existing File Share **cloudshell**  (type cloudshell)

    ![cloudshell7](images/cloudshell-07.jpg)
                  
* You should now have access to Azure Cloud Shell console

    ![cloudshell8](images/cloudshell-08.jpg)   
### Task 2 - Run the Terraform Code
* Clone the Github repo `git clone https://github.com/FortinetSecDevOps/se-conf-sdwan-workshop.git`

    ![gitclone](images/git-clone.jpg)

* Move to the azure folder `cd ./se-conf-sdwan-workshop/azure/`
* Customize your project name and the User name, based on the user id that was assigned to you
  
  `vi terraform.tfvars`

    ![vi](images/vi.jpg)
    ![rgcustom](images/rg-customname.jpg)

* Run `Terraform init`
* Run `Terraform plan`
* Run `Terraform apply` and then answer `yes`

* At the end of this step you should have the following architecture
    ![global-step1](images/SDWAN_Workshop_global1.jpg)

### Task 3 - Verifications
* Using the Terraform output verify that you have Web and SSH access to the FortiGates
    ![output](images/output.jpg)

* Connect to the Branch sites FortiGates and check the VPN status. If they are down try to bring them UP


### Task 4 - QUIZ
* FortiGates in the Hub do not have public IP attached to them, how are we able to access the Web UI then?
* Why the VPN are still down ?

</details>

***
***
## Chapter2 - Hub and Branch VPN Connectivity (20min)
_[Configuration exercise - estimated duration 20min]_

<details>

### Task 1 - Add the FortiGates to the Hub Load Balancer Backend Pool
* Go to the Hub External Load Balancer **sdwan-student01-workshop-hub1-elb1**
* Click on Backend pools
* Add FortiGate1 and FortiGate2 port1 interfaces

    ![hub-lb-backend](images/externallbbackend.jpg)

### Task 2 - Create load balancing rules for IPSEC VPN Traffic
* Click on the Hub external Load balance and go to Load balancing rules
* Create Load balacing rules for UDP 500 and UDP 4500

    ![hub-lb-rule1](images/externallbrule1.jpg)
    ![hub-lb-rule2](images/externallbrule2.jpg)

        
### Task 3 - Verifications
* Verify that the FortiGate are responding to Azure Load Balancer Health Checks: click on the Hub external Load balance and then go to Insights

    ![hub-lb-insights](images/externallbinsights.jpg)

* Verify that the VPN to the Hub are UP  (please reboot the Branch FortiGate once if the VPN does not come up)

    ![vpn](images/vpnup.jpg)

* Verify that the BGP peering with the hub is UP and that the Branch FortiGate learn the Hub and other Branches CIDRs

* At the end of this step you should have the following architecture
    ![global-step2](images/SDWAN_Workshop_global2.jpg)

### Task 4 - Traffic generation

### Task 4 - QUIZ
* Why one FortiGate is depicted as unhealthy by Azure LB ?
* Why to access the FortiGates we used NAT rules, and for IPSEC VPN traffic we used Load balancing rules?
* Do FortiGates in the Branches learn Spoke11 and Spoke12 CIDRs?


</details>

## Chapter3 - Azure Route Server Presentation (30min)
_[Presentation about Azure Route Server- estimated duration 30min]_

<details>

</details>

***
***
## Chapter4 - Hub VNET and Spoke VNET Connectivity (40min)
_[Configuration and troubleshooting exercise - estimated duration 40min]_

<details>

### Task 1 - Create the VNET peering
* Create a VNET peering between the Spoke11 VNET and the Hub VNET. Go to the Spoke VNET, studentxx-workshop-sdwan-spoke11 and then click on Peerings.
* Repeat the above between Spoke12 VNET and the Hub VNET

    ![vnetpeering1](images/spoke11-to-Hub-peering.jpg)

* Check now that the Branch FortiGate learn the Spoke11 VNET and Spoke12 VNET CIDRs

### Task 2 - Check Azure route server configuration and learned routes
* Go to Azure Route Server. Click on your Azure Route Server studentxx-workshop-sdwan-RouteServer.
* Click on Peers on the left side of the menu
* List the routes leanred by Azure Route Server. Run the command below from your Azure Cloud Shell

```
student='student01'

az network routeserver peering list-learned-routes -g $student-workshop-sdwan --routeserver $student-workshop-sdwan-RouteServer --name sdwan-fgt1

az network routeserver peering list-learned-routes -g $student-workshop-sdwan --routeserver $student-workshop-sdwan-RouteServer --name sdwan-fgt2

```


### Task 3 - Create a Dynamic SDN object [troubleshooting required]
* Is your Hub FortiGate able to see the Dynamic filters ?
    * **Trouleshoot and Make the required changes to allow the FortiGate to retrieve the SDN filters.**
    * Hints:
        =
        * FGT Branch3 is able to retrieve the filters, why that is not the case for the FortiGates Behind Load Balancers.
        * FGT Branch3 is standalone, all other FortiGates are in A-P HA, how does that affect traffic to retrieve SDN filters?

* On the Hub FortiGate, create a dynamic object that resolves to the Spoke VNETs VMs
* On the Hub FortiGate, use the object created above on policy3 to restrict traffic coming from the Branches

    ![policy3](images/policy3.jpg)

### Task 4 - Traffic generation
* Generate Traffic from Branch1 Primary FortiGate:  
    1. Connect to the Branch1 Primary FortiGate
    2. Configure ping-options to initiate traffic from FortiGate's private nic. 
    3. Initiate a ping to Spoke11 and Spoke12 Linux VM (10.11.1.4 and 10.12.1.4)

    ![traffic2](images/traffic2.jpg)

    ![traffic1](images/traffic1.jpg)

* Generate Traffic from Branch1 Linux VM:  
    1. Enable serial console access on Branch1 Linux VM
        * Click on the VM studentXX-sdwan-workshop-br1lnx1
        * Go to Boot diagnostics -> Settings ->  Select **Enable with custom storage account**
        * From the dropdown list, select the storage account that is assigned to you

            ![console1](images/ssh-br-lnx-console1.jpg)
            ![console2](images/ssh-br-lnx-console2.jpg)
    
    2. Go to the VM Serial Console
        ![console3](images/ssh-br-lnx-console3.jpg)

    3. Initiate a ping to Spoke11 and Spoke12 Linux VMs 
    ```
     ping 10.11.1.4
     ping 10.12.1.4 
     
    ```
    ![traffic3](images/traffic3.jpg)

    4. Does it work ?

* At the end of this step  you should have the following architecture

    ![global-step3](images/SDWAN_Workshop_global3.jpg)

### Task 5 - QUIZ
* What was missing to allow the FortiGates to retreive SDN connector filters
* Why the FortiGate is able to retrieve the SDN connector filters of its own resource group Only?
* Why the Branch FortiGate itself able to reach the remote spoke VNET VM (10.11.1.4 and 10.12.1.4) but the Linux VM behind the Branch FortiGate is not ?
* FortiGate at the Branch1 and Branch2 are both behind Azure Load Balancer (behind NAT). Branch1 to Branch2 traffic will succesfully establish an ADVPN shortcut?

</details>

***
***
## Chapter5 - Branch to Cloud and Branch to Branch connectivity (20min)
_[Configuration exercise - estimated duration 20min]_

<details>

### Branch to Cloud

#### Task 1 - Create a route in the UDR
* Click on the Branch1 private route table (studentxx-sdwan-workshop-branch1_rt)
* Add a default route that points to the Internal Load balancer listener 
* **Repeat the previous step to Branch2 and Branch3 Route Tables (please use the correct ip as the next hop)**

    ![udr](images/defaultroutebranch1.jpg)

#### Task 2 - Generate traffic to the Hub
* Connect to the Branch1 Linux Host via the serial console
* Generate traffic to Hub
    ```
     ping 10.11.1.4
     ping 10.12.1.4 
     
    ```
* Does it work now ?

#### Task 3 - Check effective routes
* Go to your resource group and click on Spoke11 Linux VM
* Click on Networking in the Navigation Menu
    ![effectiveroutes1](images/effectiveroutes-lnx-1.jpg)

* Click on the VM nic
    ![effectiveroutes2](images/effectiveroutes-lnx-2.jpg)

* Click on **Effective routes**
    ![effectiveroutes3](images/effectiveroutes-lnx-3.jpg)

* Check that Azure Route Server has injected the Branch sites CIDRs learnt from the FGT

* Go to your resource group and click on the Hub FGT VM
* Click on Networking in the Navigation Menu
    ![effectiveroutes4](images/effectiveroutes-lnx-4.jpg)

* Click on the VM port2 nic
    ![effectiveroutes5](images/effectiveroutes-lnx-5.jpg)

* Click on **Effective routes**
    ![effectiveroutes6](images/effectiveroutes-lnx-6.jpg)

* Has Azure Route Server injected the Branch sites CIDRs learnt from the FGT?  Why ?




### Branch to Branch
#### Task 4 - Generate traffic between Branches
* Connect to the Branch1 Linux Host via the serial console
* Generate traffic to Branch2 Linux Host
   ```
     ping 172.17.5.4
     
    ```
* Check if an ADVPN shortcut has been created

### Task 5 - QUIZ
* Why Azure Route Server (ARS) has injected the Branch sites CIDRs to the Spoke VNET protected subnet but not the FortiGate private subnet?

* The Branch external Load balancer has two front end public ip. How do we ensure that traffic egressing Branch1 on port1 (isp1)  has always the same public ip applied? Same for traffic egressing Branch1 on port3 (isp2)


</details>

***
***
## Chapter6 - Redundancy (20min)
_[failover exercise - estimated duration 20min]_

<details>

### Task 1 - Generate ICMP traffic
* Access the serial console by clicking on the VM studentXX-sdwan-workshop-br1lnx1 and then Serial Console
* Ping a resource in the Hub as well as in a remote branch site `ping 10.11.1.4`
### Task 2 - Initiate a failover
* Connect to the Branch1 Primary FortiGate . Initiate a failover by rebooting the primary FortiGate
* Monitor the number of **lost Pings** and the **failover time**
* How long did it take ?
* Have the VPNs to the Hub been renegotiated upon failover or maintained ?

    ![failover](images/defaultroutebranch1.jpg)

### Task 3 - Generate TCP traffic
* Ensure that both units of Branch1 FGT in the cluster is up and running
* Access the serial console of Branch1 Linux VM by clicking on the VM studentXX-sdwan-workshop-br1lnx1 and then click on Serial Console
* Generate an SSH session to the Hub Linux VM 

   ```
   ssh studentxx@10.11.1.4
   
   ```
* From Hub Linux VM SSH session generate a continous stream of connections to track the failover event 
   
   ```
   while true; date; do curl -I -sw '%{http_code}'  https://www.lemonde.fr/ ; echo -e "\n================="; sleep 1 ; done

   ```   
* Connect to the Branch1 Primary FortiGate . Initiate a failover by rebooting the primary FortiGate
* Monitor the SSH connexion
* Did you lose the TCP connexion ?
### Task 6 - QUIZ
* How long was your failover time ? 

* Why did we lose the SSH (TCP) session with a "short" failover time ? 

</details>

***
***
## Chapter7 - Scaling (20min)
_[Presentation about FGT A/A and SDWAN usecase- estimated duration 20min]_

<details>

</details>

***
***

## Chapter8 - Azure virtualWAN [estimated duration 60min]
_[Configuration exercise - estimated duration 20min]_

<details>

### Task 1 - Deployment

* Create your vWAN and the vWAN Hub using the CLI command below

* Please replace the student variable with your own Student ID
 

   ``` 
    student='student05'

    az network vwan create --name sdwan-$student-workshop-vwan --resource-group  $student-workshop-sdwan --location eastus --type Standard

    az network vhub create --address-prefix 10.14.0.0/16 --name $student-eastushub --resource-group $student-workshop-sdwan --vwan sdwan-$student-workshop-vwan --location eastus --sku Standard

   ``` 

    ![vwan1](images/vwan1.jpg)


* Navigate to your Resource Group and verify that you see your vWAN
    ![vwan2](images/vwan2.jpg)

* Click on your vWAN and verify that you see the virtual Hub you just deployed

    ![vwan3](images/vwan3.jpg)

* Click on the vWAN Hub and verify that the deployment and routing status complete

    ![vwan4](images/vwan4.jpg)


### Task 2 - Routing and VNET connection Configuration

* Go to your resource Group and then click on the Hub VNET
* Delete the Hub to Spoke VNET peerings

    ![vwan-rtb1](images/vwan-rtb1.jpg)

* Click on your virtual Hub and then click on Routing
    ![vwan-rtb1](images/vwan-rtb1.jpg)

* Create a Route Table Called Spoke-VNETS. Keep all other settings unchanged

    ![vwan-rtb2](images/vwan-rtb2.jpg)

* Repeat the same for FGT vWAN Route Table: FGT-VNET

    ![vwan-rtb3](images/vwan-rtb3.jpg)

* Go to the vWAN, Click on Virtual Network Connection

    ![vwanconnection1](images/vwanconnection1.jpg)

* Create a VNET connection for Spoke11, attach it to the Spoke-VNETS Route Table and propagate it to FGT-VNET Route Table[**Please choose your own Resource Group and your own VNET** ]

    ![vwanconnection2](images/vwanconnection2.jpg)

* Repeat the same for Spoke12

* Repeat the same for FGT VNET connection, attach it to the FGT-VNET Route Table. 
    * Does it work ?
    * why ?

* Locate your own Azure Route Server and delete it

    ![findars](images/findars.jpg)
    ![deleteaes](images/deleteaes.jpg)

* Try now to connect the FGT VNET to the vWAN Hub, attach it to the FGT-VNET Route Table. 
    * Does it work now ?
    * why ?

    ![vwanconnection3](images/vwanconnection3.jpg)
    ![vwanconnection4](images/vwanconnection4.jpg)    


* Go your vWAN Hub, click on Routing and then click on Spoke-VNETS Route Table

    ![vwanhubrouting1](images/vwanhubrouting1.jpg)
    ![vwanhubrouting2](images/vwanhubrouting2.jpg) 

* Add a default route that points to the FortiGate VNET connection. The next hop ip is the Primary FGT port2 ip
    ![vwanhubrouting3](images/vwanhubrouting3.jpg) 

* Verify that this default route has been propagated to the Spokes VNETs
    * Go to the Spoke11 Linux VM -> Networking -> Click on nic and then click on **Effective Routes**

    ![vwanhubrouting4](images/vwanhubrouting4.jpg)
    ![vwanhubrouting5](images/vwanhubrouting5.jpg)    


* At the end of this step you should have the following architecture 

    ![vwanhubrouting4](images/vwanhubrouting4.jpg)  

### Task 3 - Traffic generation [troubleshooting required]

</details>
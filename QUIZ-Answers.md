# Azure SDWAN Workshop Quiz Answers / Explanations

## Chapter 1

<details>

* FortiGates in the Hub do not have public IPs, how are they accessible via the Web UI?
  * The Public IPs on the external load balancers for the Hub, Branch1 and Branch2 FortiGates have inbound NAT rules setup.

* Why the VPN connections are still down?
  * The external load balancer for the Hub FortiGates needs load balancing rules for UDP 500 and UDP 4500.

[Quiz Answers](/QUIZ-Answers.md#chapter-1)
</details>

## Chapter 2

<details>

* Why is one FortiGate depicted as unhealthy by the Azure Hub External Load Balancer?
  * The passive FortiGate does not respond to the load balancer health probes. Only after a failover event will the newly active FortiGate start responding to health probes.

* Why is NAT used to access the FortiGates, but for IPSEC VPN traffic Load balancing rules are used?
  * NAT allows each individual FortiGate to be accessed via the Public IP of the load balancer. A load balancer rule would only allow access to the Active FortiGate.

* Do FortiGates in the Branches learn Spoke11 and Spoke12 CIDRs?
  * Spoke11 and Spoke12 CIDRs are not yet know to the FortiGate so the Branches will not learn them yet.

</details>

## Chapter 4

<details>

* What was missing to allow the FortiGates to retrieve SDN connector filters?
  * The FortiGate's management interfaces need access to the Azure APIs via a public IP address. This required adding a backend pool for the FortiGate management interfaces and a TCP load balancing rule to let the API response to an internal request back through the external load balancer.

* Why is the FortiGate only able to retrieve the SDN connector filters in its own Resource Group?
  * The FortiGate VM Azure Identity was given the "Reader" role with the scope of the Resource Group.

* Why is the Branch FortiGate able to reach the remote Spoke VNETs VMs (10.11.1.4 and 10.12.1.4) but the Linux VM behind the Branch1 FortiGate cannot?
  * The Linux VM does not know how to get to the FortiGate because no default route was defined for the route table which controls the subnet the Linux VM is in.

* FortiGates at Branch1 and Branch2 site are both behind Azure Load Balancers (behind NAT). Will Branch1 to Branch2 traffic successfully establish an ADVPN shortcut?
  * Yes

</details>

## Chapter 5

<details>

* Why has the Azure Route Server (ARS) injected Branch site CIDRs to the Spoke VNET protected subnet but not the FortiGate private subnet?
  * Route propagation into the FortiGate private subnet is set to no.

* The Branch external load balancer has two front end public IP. How do we ensure that traffic egressing Branch1 on port1 (isp1) always has the same public IP applied? Same for traffic egressing Branch1 on port3 (isp2)?
  * By using outbound rules associated to backend pools connected to those ports on each FortiGate.

</details>

## Chapter 6

<details>

* How long was your failover time?
  * It should have been between 15 - 25 seconds.

* Why did we lose the SSH (TCP) session with a "short" failover time?
  * TCP sessions are not maintained by the Azure load balancer.

</details>

## Chapter 8

<details>

* Why were we not able to attach the Hub FortiGate VNET to vWAN until we deleted Azure Route Server?
  * An Azure VNET cannot receive routes from more than the vWAN and the RouteServer at teh same time.

* Why was the vWAN not able to inject Spoke11 and Spoke12 VNETs CIDRs to FortiGate Private UDR?
  * Route propagation for the FortiGate route table sdwan-studentXX-workshop-hub1_fgt-priv_rt was set to no.

* The above setting is normally set to "yes", why did we set it to "no"?
  * Azure RouteServer provided the routes

* In the Spoke-VNETS vWAN Route Table, the next-hop is the Primary FortiGate IP. What should we add/do to handle failover?
  * An internal load balancer could be added and use that IP as the next hop or an automation stich could be run at failover to update the Spoke-VNETS vWAN Route Table to point to the newly active FortiGate private interface.

</details>
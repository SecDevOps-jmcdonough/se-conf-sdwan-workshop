Content-Type: multipart/mixed; boundary="===============0086047718136476635=="
MIME-Version: 1.0

--===============0086047718136476635==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="config"

config system sdn-connector
edit AzureSDN
set type azure
end
end

config system global
set admin-https-ssl-versions tlsv1-2 tlsv1-3
set admin-sport 34443
set admin-ssh-port 3422
set hostname ${fgt_id}
set admintimeout 120
set timezone 26
set gui-theme neutrino
end

config system settings
    set gui-allow-unnamed-policy enable
    set gui-multiple-interface-policy enable
end

config system interface
edit port1
set alias ${Port1Alias}
set mode static
set ip ${Port1IP}/${port1subnetmask}
set allowaccess ping https ssh fgfm probe-response
next
edit port2
set alias ${Port2Alias}
set mode static
set ip ${Port2IP}/${port2subnetmask}
set allowaccess ping https ssh fgfm probe-response
next
%{ if Port3IP != "" }
edit port3
set alias ${Port3Alias}
set mode static
set ip ${Port3IP}/${port3subnetmask}
set allowaccess ping https ssh fgfm probe-response
next
%{ endif }
%{ if Port4IP != "" }
edit port4
set alias ${Port4Alias}
set mode static
set ip ${Port4IP}/${port4subnetmask}
set allowaccess ping https ssh fgfm probe-response
next
%{ endif }
%{ if Port5Alias != "" }
edit port5
set alias ${Port5Alias}
set mode dhcp
set allowaccess ping https ssh fgfm probe-response
next
%{ endif }
end

config system vdom-exception
edit 0
set object system.interface
next
edit 0
set object firewall.ippool
next
end

config router static
    edit 0
        set gateway ${fgt_external_gw}
        set device port1
    next
    edit 0
        set dst ${vnet_network}
        set gateway ${fgt_internal_gw}
        set device port2
    next
    edit 0
    set dst 168.63.129.16 255.255.255.255
    set gateway ${fgt_external_gw}
    set device port1
    next

    edit 0
    set dst 168.63.129.16 255.255.255.255
    set gateway ${fgt_internal_gw}
    set device port2
    next  
end

%{ if fgt_ssh_public_key != "" }
config system admin
    edit "${fgt_username}"
        set ssh-public-key1 "${trimspace(file(fgt_ssh_public_key))}"
    next
end
%{ endif }
%{ if fgt_config_ha }
config system ha
    set group-name AzureHA
    set mode a-p
    set hbdev ${port_ha} 100
    set session-pickup enable
    set session-pickup-connectionless enable
    set ha-mgmt-status enable
    config ha-mgmt-interfaces
        edit 1
            set interface ${port_mgmt}
            set gateway ${fgt_mgmt_gw}
        next
    end
    set override disable
    set priority ${fgt_ha_priority}
    set unicast-hb enable
    set unicast-hb-peerip ${fgt_ha_peerip}
end
%{ endif }

%{ if fgt_config_autoscale }
config system auto-scale
set status enable
set role ${role}
set sync-interface ${sync-port}
set psksecret ${psk}

%{ if role == "secondary" }
set master-ip ${masterip}
%{ endif }

end
%{ endif }

%{ if fgt_config_probe }
config system probe-response
    set http-probe-value OK
    set mode http-probe
end
%{ endif }

%{ if fgt_config_sdwan }
config router static
    edit 0
        set gateway ${fgt_external_gw2}
        set device ${isp2}
    next
end    
config vpn ipsec phase1-interface
    edit "HUB-VPN1"
        set interface "port1"
        set ike-version 2
        set peertype any
        set net-device enable
        set mode-cfg enable
        set proposal aes256-sha256
        set add-route disable
        set localid "isp1"
        set auto-discovery-receiver enable
        set network-overlay enable
        set network-id 1
        set remote-gw ${remotegw1}
        set psksecret Fortinet20217!
    next
    edit "HUB-VPN2"
        set interface "port3"
        set ike-version 2
        set peertype any
        set net-device enable
        set mode-cfg enable
        set proposal aes256-sha256
        set add-route disable
        set localid "isp2"
        set auto-discovery-receiver enable
        set network-overlay enable
        set network-id 2
        set remote-gw ${remotegw2}
        set psksecret Fortinet20217!
    next
end
config vpn ipsec phase2-interface
    edit "HUB-VPN1"
        set phase1name "HUB-VPN1"
        set proposal aes256-sha256
        set auto-negotiate enable
    next
    edit "HUB-VPN2"
        set phase1name "HUB-VPN2"
        set proposal aes256-sha256
        set auto-negotiate enable
    next
end
config router bgp
    set as 64622
    set ibgp-multipath enable
    set additional-path enable
    set graceful-restart enable
    set additional-path-select 4
    config neighbor
        edit "192.168.10.253"
            set advertisement-interval 1
            set capability-graceful-restart enable
            set link-down-failover enable
            set remote-as 64622
            set connect-timer 10
            set additional-path receive
        next
        edit "192.168.11.253"
            set advertisement-interval 1
            set capability-graceful-restart enable
            set link-down-failover enable
            set remote-as 64622
            set connect-timer 10
            set additional-path receive
        next
    end
end
config router bgp
    config network
        edit 1
            set prefix ${vnet_network}
        next
    end
end
config firewall address
    edit "Cloud-NET-1"
        set subnet 10.10.0.0 255.255.0.0
    next
    edit "Cloud-NET-2"
        set subnet 10.11.0.0 255.255.0.0
    next
    edit "Cloud-NET-3"
        set subnet 10.12.0.0 255.255.0.0
    next
    edit "Branch1"
        set subnet 172.16.0.0 255.255.0.0
    next
    edit "Branch2"
        set subnet 172.17.0.0 255.255.0.0
    next
    edit "Branch3"
        set subnet 172.18.0.0 255.255.0.0
    next              
    edit "rfc-1918-10"
        set subnet 10.0.0.0 255.0.0.0
    next
    edit "rfc-1918-172"
        set subnet 172.16.0.0 255.255.240.0
    next
    edit "rfc-1918-192"
        set subnet 192.168.0.0 255.255.0.0
    next
end
config firewall addrgrp
    edit "rfc-1918"
        set member "rfc-1918-10" "rfc-1918-172" "rfc-1918-192"
    next
    edit "Cloud"
        set member "Cloud-NET-1" "Cloud-NET-2" "Cloud-NET-3"
    next
    edit "Branches"
        set member "Branch1" "Branch2" "Branch3"
    next        
end
config application group
    edit "BusinessCriticalApps"
        set application 16354 16920 43541
    next
end
config system sdwan
    set status enable
    config zone
        edit "virtual-wan-link"
        next
        edit "Cloud"
        next
        edit "WAN1"
        next
        edit "WAN2"
        next
    end
    config members
        edit 1
            set interface "HUB-VPN1"
            set zone "Cloud"
        next
        edit 2
            set interface "HUB-VPN2"
            set zone "Cloud"
        next
        edit 3
            set interface "port1"
            set zone "WAN1"
        next
        edit 4
            set interface "port3"
            set zone "WAN2"
        next
    end
    config health-check
        edit "HUB1_HC"
            set server "10.10.255.1"
            set failtime 3
            set recoverytime 3
            set update-static-route disable
            set sla-fail-log-period 10
            set sla-pass-log-period 10
            set members 1 2
            config sla
                edit 1
                    set latency-threshold 100
                    set jitter-threshold 25
                    set packetloss-threshold 1
                next
            end
        next
        edit "Internet"
            set server "1.1.1.1" "8.8.8.8"
            set protocol dns
            set failtime 3
            set recoverytime 3
            set update-static-route disable
            set members 3 4
            config sla
                edit 1
                    set latency-threshold 250
                    set jitter-threshold 55
                    set packetloss-threshold 1
                next
            end
        next
    end
    config service
        edit 1
            set name "Branch-to-Cloud"
            set mode sla
            set dst "Cloud" "Branches"
            set src "Branches"
            config sla
                edit "HUB1_HC"
                    set id 1
                next
            end
            set priority-members 1 2
        next
        edit 2
            set name "BusinessCritical"
            set mode priority
            set src "Branches"
            set internet-service enable
            set internet-service-app-ctrl-group "BusinessCriticalApps"
            set health-check "Internet"
            set priority-members 3 4
        next
        edit 3
            set name "All"
            set mode priority
            set dst "rfc-1918"
            set dst-negate enable
            set src "Branches"
            set health-check "Internet"
            set link-cost-factor packet-loss
            set priority-members 3 4
        next
    end        
end
config firewall policy
    edit 1
        set name "Branch to Cloud"
        set srcintf "port2"
        set dstintf "Cloud"
        set srcaddr "all"
        set dstaddr "all"
        set action accept
        set schedule "always"
        set service "ALL"
        set logtraffic all
    next
    edit 2
        set name "Cloud to Branch"
        set srcintf "Cloud"
        set dstintf "port2"
        set srcaddr "all"
        set dstaddr "all"
        set action accept
        set schedule "always"
        set service "ALL"
        set logtraffic all
    next
    edit 3
        set name "Internet-Breakout"
        set srcintf "port2"
        set dstintf "WAN1" "WAN2"
        set srcaddr "all"
        set dstaddr "all"
        set action accept
        set schedule "always"
        set service "ALL"
        set logtraffic all
        set nat enable
    next    
end
%{ endif }


%{ if fgt_license_file != "" }
--===============0086047718136476635==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="${fgt_license_file}"

${file(fgt_license_file)}

%{ endif }
--===============0086047718136476635==--

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
config system global
    set admin-https-ssl-versions tlsv1-2 tlsv1-3
    set admin-sport 34443
    set admin-ssh-port 3422
    set hostname ${fgt_id}
    set admin-telnet disable
    set admintimeout 120
    set allow-traffic-redirect disable
    set timezone 26
end

config system settings
    set gui-allow-unnamed-policy enable
    set gui-multiple-interface-policy enable
end

config system interface
    edit "port1"
        set vdom "root"
        set mode dhcp
        set allowaccess ping https ssh fgfm probe-response
        set alias ${Port1Alias}
    next
    edit "port2"
        set vdom "root"
        set mode dhcp
        set allowaccess ping https ssh fgfm probe-response
        set alias ${Port2Alias}
        set defaultgw disable
        set mtu-override enable
        set mtu 9001
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
    edit 1
        set dst 168.63.129.16 255.255.255.255
        set gateway ${fgt_external_gw}
        set device port1
    next
    edit 2
        set dst 168.63.129.16 255.255.255.255
        set gateway ${fgt_internal_gw}
        set device port2
        set priority 10
    next         
    edit 3
        set dst ${vnet_network}
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
%{ if fgt_config_bgp }
config router bgp
    set as ${fgt_as}
    set ebgp-multipath enable
    config neighbor
        edit ${peer1}
            set ebgp-enforce-multihop enable
            set soft-reconfiguration enable
            set description "Azure Route Server"
            set remote-as ${peer_as}
            set connect-timer 3
        next
        edit ${peer2}
            set ebgp-enforce-multihop enable
            set soft-reconfiguration enable
            set description "Azure Route Server"
            set remote-as ${peer_as}
            set connect-timer 3
        next
    end
end        
%{ endif }

%{ if fgt_config_sdwan }
config vpn ipsec phase1-interface
    edit "VPN1"
        set type dynamic
        set interface "port1"
        set ike-version 2
        set peertype one
        set net-device disable
        set mode-cfg enable
        set proposal aes256-sha256
        set add-route disable
        set dpd on-idle
        set auto-discovery-sender enable
        set network-overlay enable
        set network-id 1
        set peerid "isp1"
        set ipv4-start-ip 192.168.10.1
        set ipv4-end-ip 192.168.10.252
        set ipv4-netmask 255.255.255.0
        set psksecret ENC 4aWuadn6SPqm9Lxox5UpVtOWIImG+iAjD5izjnHM3KIvtBB6+AN22ZG/LjyhUDeiqy8BpTSwDCfHkrh11ZECv1+OGIv7/4vQkMexIbAwjTmbfmBX4YCYhPrq3fs/20MAh4c+WNV3pwvgrFAoDy8RFwNIh8+xZZdARZe6Uk6Jjf2hgWe222q7NdcCruSWoF6pcpCc1Q==
        set dpd-retryinterval 60
    next
    edit "VPN2"
        set type dynamic
        set interface "port1"
        set ike-version 2
        set peertype one
        set net-device disable
        set mode-cfg enable
        set proposal aes256-sha256
        set add-route disable
        set dpd on-idle
        set auto-discovery-sender enable
        set network-overlay enable
        set network-id 2
        set peerid "isp2"
        set ipv4-start-ip 192.168.11.1
        set ipv4-end-ip 192.168.11.252
        set ipv4-netmask 255.255.255.0
        set psksecret ENC ojuAxl1XX/zf3zdWIJcHRw/MqwEKnBZoI5DbUj7tPHIOtkRaXAJDWuKL2MbtX/k9vEL4w2yezKEzE3m6EBkWXjZ8VCvRDhIAhpuQIHNy5xqROvQQ63u1935wJnpB0EPrKvFvIgjHEiWIMnvNokd+a9KoBuutJhd/Drm14ZSQaTj/IBma6lfAxTVNhFaepzmDyEL0Eg==
        set dpd-retryinterval 60
    next
end
config vpn ipsec phase2-interface
    edit "VPN1"
        set phase1name "VPN1"
        set proposal aes256-sha256
    next
    edit "VPN2"
        set phase1name "VPN2"
        set proposal aes256-sha256
    next   
end
config system interface
    edit "VPN1"
        set vdom "root"
        set ip 192.168.10.253 255.255.255.255
        set allowaccess ping
        set type tunnel
        set remote-ip 192.168.10.254 255.255.255.0
        set snmp-index 13
        set interface "port1"
    next
    edit "VPN2"
        set vdom "root"
        set ip 192.168.11.253 255.255.255.255
        set allowaccess ping
        set type tunnel
        set remote-ip 192.168.11.254 255.255.255.0
        set snmp-index 14
        set interface "port1"
    next
    edit "loopback_0"
        set vdom "root"
        set ip 10.10.255.1 255.255.255.255
        set allowaccess ping
        set type loopback
    next    
end
config router bgp
    set ibgp-multipath enable
    set additional-path enable
    set graceful-restart enable
    set additional-path-select 2
    config neighbor-group
        edit "VPN1"
            set capability-graceful-restart enable
            set link-down-failover enable
            set next-hop-self enable
            set remote-as 64622
            set additional-path send
            set route-reflector-client enable
        next
        edit "VPN2"
            set capability-graceful-restart enable
            set link-down-failover enable
            set next-hop-self enable
            set remote-as 64622
            set additional-path send
            set route-reflector-client enable
        next
    end
    config neighbor-range
        edit 1
            set prefix 192.168.10.0 255.255.255.0
            set neighbor-group "VPN1"
        next
        edit 2
            set prefix 192.168.11.0 255.255.255.0
            set neighbor-group "VPN2"
        next
    end
    config network
    edit 1
        set prefix 10.10.255.1 255.255.255.255
    next
end
end
config system sdwan
    set status enable
    config zone
        edit "virtual-wan-link"
        next
    end
    config members
        edit 1
            set interface "VPN1"
        next
        edit 2
            set interface "VPN2"
        next
    end
end 
config firewall policy
    edit 1
        set name "Branch to Cloud"
        set srcintf "virtual-wan-link"
        set dstintf "port2"
        set srcaddr "all"
        set dstaddr "all"
        set action accept
        set schedule "always"
        set service "ALL"
        set logtraffic all
    next
    edit 2
        set name "Cloud to Branch"
        set srcintf "port2"
        set dstintf "virtual-wan-link"
        set srcaddr "all"
        set dstaddr "all"
        set action accept
        set schedule "always"
        set service "ALL"
        set logtraffic all
    next
    edit 3
        set name "Branch to Branch"
        set srcintf "virtual-wan-link"
        set dstintf "virtual-wan-link"
        set srcaddr "all"
        set dstaddr "all"
        set action accept
        set schedule "always"
        set service "ALL"
        set logtraffic all
    next
    edit 4
        set name "SDWAN-HC"
        set srcintf "virtual-wan-link"
        set dstintf "loopback_0"
        set action accept
        set srcaddr "all"
        set dstaddr "all"
        set schedule "always"
        set service "PING"
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

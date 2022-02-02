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
config system interface
    edit "port1"
        set vdom "root"
        set mode dhcp
        set allowaccess ping https ssh fgfm probe-response
        set type physical
        set alias "External"
        set lldp-reception enable
        set monitor-bandwidth enable
        set role wan
        set snmp-index 1
    next
    edit "port2"
        set vdom "root"
        set mode dhcp
        set allowaccess ping https ssh fgfm probe-response
        set type physical
        set alias "Internal"
        set device-identification enable
        set lldp-transmission enable
        set monitor-bandwidth enable
        set role lan
        set snmp-index 2
        set defaultgw disable
        set mtu-override enable
        set mtu 9001
    next        
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
        set gateway ${fgt_port1_gw}
        set device port1
    next
    edit 2
        set dst 168.63.129.16 255.255.255.255
        set gateway ${fgt_port2_gw}
        set device port2
    next         
    edit 3
        set dst 10.0.0.0 255.0.0.0
        set gateway ${fgt_port2_gw}
        set device "port2"
    next
    edit 4
        set dst 172.16.0.0 255.240.0.0
        set gateway ${fgt_port2_gw}
        set device "port2"
    next
    edit 5
        set dst 192.168.0.0 255.255.0.0
        set gateway ${fgt_port2_gw}
        set device "port2"
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
    set hbdev port3 100
    set session-pickup enable
    set session-pickup-connectionless enable
    set ha-mgmt-status enable
    config ha-mgmt-interfaces
        edit 1
            set interface port4
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

%{ if fgt_license_file != "" }
--===============0086047718136476635==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="${fgt_license_file}"

${file(fgt_license_file)}

%{ endif }
--===============0086047718136476635==--

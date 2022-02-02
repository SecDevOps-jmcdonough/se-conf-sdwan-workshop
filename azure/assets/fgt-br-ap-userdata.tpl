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
set admin-sport 34443
set admin-ssh-port 3422
set hostname ${fgt_id}
set admintimeout 120
set timezone 57
set gui-theme mariner
end

config system interface
edit port1
set alias ${Port1Alias}
set mode static
set ip ${Port1IP}/${port1subnetmask}
set allowaccess ping https ssh fgfm
next
edit port2
set alias ${Port2Alias}
set mode static
set ip ${Port2IP}/${port2subnetmask}
set allowaccess ping https ssh fgfm
next
%{ if Port3IP != "" }
edit port3
set alias ${Port3Alias}
set mode static
set ip ${Port3IP}/${port3subnetmask}
set allowaccess ping https ssh fgfm
next
%{ endif }
%{ if Port4IP != "" }
edit port4
set alias ${Port4Alias}
set mode static
set ip ${Port4IP}/${port4subnetmask}
set allowaccess ping https ssh fgfm
next
%{ endif }
%{ if Port5Alias != "" }
edit port5
set alias ${Port5Alias}
set mode dhcp
set allowaccess ping https ssh fgfm
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

%{ if fgt_license_file != "" }
--===============0086047718136476635==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="${fgt_license_file}"

${file(fgt_license_file)}

%{ endif }
--===============0086047718136476635==--

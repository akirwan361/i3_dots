#!/usr/bin/env sh

## @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
## vpn_module: vpn scripts for a polybar, setup stock for Mullvad VPN
## 	by Shervin S. (shervin@tuta.io)
##      https://github.com/shervinsahba/polybar-vpn-controller
## adapted for use with Private Internet Access VPN 

## 	vpn_module reports your VPN's status as [<ip_address> | connecting... | No VPN ].
##  With optional dependencies, <ip_address> will be replaced with <city> <country>.
##  You can also connect and disconnect via left-clicks, or with rofi, right-click to
##  access a menu and select between your favorite locations, set in VPN_LOCATIONS,
##  as well as 35 countries covered by Mullvad VPN.

##	dependencies:
## 		piactl (command-line interface to the PIA Client)

##	optional dependencies: 
##		rofi 		      - allows menu-based control of mullvad
##		geoip, geoip-database - provide country info instead of public address
## 		geoip-database-extra  - also provides city info


## For use with polybar, use a module script in user_modules.ini like so:
##
## [module/vpn]
## type = custom/script
## exec = $HOME/.config/polybar/scripts/vpn_module.sh
## click-left = $HOME/.config/polybar/scripts/vpn_module.sh --toggle-connection &
## click-right = $HOME/.config/polybar/scripts/vpn_module.sh --location-menu &
## interval = 5
## format =  <label>
## format-background = ${color.mb}


## @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
## User Settings

# Set commands for PIA VPN.
VPNCOMMAND_CONNECT="piactl connect"
# echo $VPNCOMMAND_CONNECT
VPNCOMMAND_DISCONNECT="piactl disconnect"
VPNCOMMAND_STATUS="piactl get connectionstate"
VPNCOMMAND_GET_REGION="piactl get region"
VPNCOMMAND_RELAY_SET_LOCATION="piactl set region"

VPN_STATUS="$($VPNCOMMAND_STATUS | cut -d' ' -f3)"	# Connected/Connecting/... 
CONNECTED=Connected   
CONNECTING=Connecting 
# echo VPN_STATUS
# Set your 8 favorite vpn locations here. These will
# be passed to your VPN as `$VPNCOMMAND_RELAY_SET_LOCATION <input>`.
VPN_LOCATIONS=("uk-manchester" "de-frankfurt" "de-berlin" "ireland" "us-chicago" "us-east" "us-houston" "us-texas")

# Set style settings for optional rofi menu. `man rofi` for help.
icon_connect=
icon_fav=
icon_country=
rofi_font="Monospace 12"
rofi_theme="network.rasi"
#"colors.rasi"
#"$HOME/.config/rofi/colors-rofi-dark.rasi"
# rofi_location="-location 5 -xoffset -100 -yoffset -50"
rofi_menu_name="PIA VPN"

# These are country codes taken from `piactl get regions`. 
# They ought to connect to PIA's choice of VPN in the region.
COUNTRIES=("Albania (AL)" "Argentina (AR)" "Melbourne (AU)" "Perth (AU)" "Sydeny (AU)" "Austria (AT)" "Belgium (BE)" "Bosnia & Herzegovina (BH)" "Bulgaria (BG)" "Montreal (CA)" "Ontario (CA)" "Toronto (CA)" "Vancouver (CA)" "Czech Republic (CZ)" "Frankfurt (DE)" "Berlin (DE)" "Denmark (DK)" "Estonia (EE)" "Finland (FI)" "France (FR)" "Greece (GR)" "Hong Kong (HK)" "Hungary (HU)" "Iceland (IS)" "India (IN)" "Ireland (IE)" "Israel (IL)" "Italy (IT)" "Japan (JP)" "Latvia (LV)" "Lithuania (LT)" "Luxembourg (LU)" "Moldova (MD)" "Netherlands (NL)" "New Zealand (NZ)" "North Macedonia (MK)" "Norway (NO)" "Poland (PL)" "Portugal (PT)" "Romania (RO)" "Serbia (RS)" "Singapore (SG)" "Slovakia (SK)" "South Africa (ZA)" "Spain (ES)" "Sweden (SE)" "Switzerland (CH)" "Turkey (TR)" "United Arab Emirates (AE)" "London (UK)" "Manchester (UK)" "Southampton (UK)" "Ukraine (UA)" "Atlanta (US)" "California (US)" "Chicago (US)" "Denver (US)" "East Coast (US)" "Florida (US)" "Houston (US)" "Las Vegas (US)" "New York City (US)" "Seattle (US)" "Silicon Valley (US)" "Texas (US)" "Washington DC (US)" "West Coast (US)")
COUNTRY_CODES=("albania" "argentina" "au-melbourne" "au-perth" "au-sydney" "austria" "belgium" "bosnia-and-herzegovina" "bulgaria" "ca-montreal" "ca-ontario" "ca-toronto" "ca-vancouver" "czech-republic" "de-berlin" "de-frankfurt" "denmark" "estonia" "finland" "france" "greece" "hong-kong" "hungary" "iceland" "india" "ireland" "israel" "italy" "japan" "latvia" "lithuania" "luxembourg" "moldova" "netherlands" "new-zealand" "north-macedonia" "norway" "poland" "portugal" "romania" "serbia" "singapore" "slovakia" "south-africa" "spain" "sweden" "switzerland" "turkey" "uae" "uk-london" "uk-manchester" "uk-southampton" "ukraine" "us-atlanta" "us-california" "us-chicago" "us-denver" "us-east" "us-florida" "us-houston" "us-las-vegas" "us-new-york-city" "us-seattle" "us-silicon-valley" "us-texas" "us-washington-dc" "us-west")

## @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
## Main Script

# Concatenate arrays
VPN_CODES=("${VPN_LOCATIONS[@]}")
VPN_CODES+=("${COUNTRY_CODES[@]}")
VPN_LOCATIONS+=("${COUNTRIES[@]}")
# echo $VPN_CODES

vpn_report() {
# continually reports connection status

	connected_region=$($VPNCOMMAND_GET_REGION)

	if [ "$VPN_STATUS" = "$CONNECTED"  ]; then  
		echo "$connected_region"
	elif [ "$VPN_STATUS" = "$CONNECTING" ]; then  
		echo "connecting..."
	else
		echo "No VPN"
	fi
}


vpn_toggle_connection() {
# connects or disconnects vpn
    if [ "$VPN_STATUS" = "$CONNECTED" ]; then
        $VPNCOMMAND_DISCONNECT
    else
        $VPNCOMMAND_CONNECT
    fi
}


vpn_location_menu() {
# Allows control of VPN via rofi menu. Selects from VPN_LOCATIONS.

	if hash rofi 2>/dev/null; then

		MENU="$(rofi \
			-font "$rofi_font" -theme $rofi_theme \ # $rofi_location \
			-columns 1 -width 10 -hide-scrollbar \
			-line-padding 4 -padding 20 -lines 9 \
			-sep "|" -dmenu -i -p "$rofi_menu_name" <<< \
			" $icon_connect (dis)connect| $icon_fav ${VPN_LOCATIONS[0]}| $icon_fav ${VPN_LOCATIONS[1]}| $icon_fav ${VPN_LOCATIONS[2]}| $icon_fav ${VPN_LOCATIONS[3]}| $icon_fav ${VPN_LOCATIONS[4]}| $icon_fav ${VPN_LOCATIONS[5]}| $icon_fav ${VPN_LOCATIONS[6]}| $icon_fav ${VPN_LOCATIONS[7]}| $icon_country ${VPN_LOCATIONS[8]}| $icon_country ${VPN_LOCATIONS[9]}| $icon_country ${VPN_LOCATIONS[10]}| $icon_country ${VPN_LOCATIONS[11]}| $icon_country ${VPN_LOCATIONS[12]}| $icon_country ${VPN_LOCATIONS[13]}| $icon_country ${VPN_LOCATIONS[14]}| $icon_country ${VPN_LOCATIONS[15]}| $icon_country ${VPN_LOCATIONS[16]}| $icon_country ${VPN_LOCATIONS[17]}| $icon_country ${VPN_LOCATIONS[18]}| $icon_country ${VPN_LOCATIONS[19]}| $icon_country ${VPN_LOCATIONS[20]}| $icon_country ${VPN_LOCATIONS[21]}| $icon_country ${VPN_LOCATIONS[22]}| $icon_country ${VPN_LOCATIONS[23]}| $icon_country ${VPN_LOCATIONS[24]}| $icon_country ${VPN_LOCATIONS[25]}| $icon_country ${VPN_LOCATIONS[26]}| $icon_country ${VPN_LOCATIONS[27]}| $icon_country ${VPN_LOCATIONS[28]}| $icon_country ${VPN_LOCATIONS[29]}| $icon_country ${VPN_LOCATIONS[30]}| $icon_country ${VPN_LOCATIONS[31]}| $icon_country ${VPN_LOCATIONS[32]}| $icon_country ${VPN_LOCATIONS[33]}| $icon_country ${VPN_LOCATIONS[34]}| $icon_country ${VPN_LOCATIONS[35]}| $icon_country ${VPN_LOCATIONS[36]}| $icon_country ${VPN_LOCATIONS[37]}| $icon_country ${VPN_LOCATIONS[38]}| $icon_country ${VPN_LOCATIONS[39]}| $icon_country ${VPN_LOCATIONS[40]}| $icon_country ${VPN_LOCATIONS[41]}| $icon_country ${VPN_LOCATIONS[42]}| $icon_country ${VPN_LOCATIONS[43]}")| $icon_country ${VPN_LOCATIONS[44]}"| $icon_country ${VPN_LOCATIONS[45]}"| $icon_country ${VPN_LOCATIONS[46]}"| $icon_country ${VPN_LOCATIONS[47]}"| $icon_country ${VPN_LOCATIONS[48]}"| $icon_country ${VPN_LOCATIONS[49]}"| $icon_country ${VPN_LOCATIONS[50]}"| $icon_country ${VPN_LOCATIONS[51]}"| $icon_country ${VPN_LOCATIONS[52]}"| $icon_country ${VPN_LOCATIONS[53]}"| $icon_country ${VPN_LOCATIONS[54]}"| $icon_country ${VPN_LOCATIONS[55]}"| $icon_country ${VPN_LOCATIONS[56]}"| $icon_country ${VPN_LOCATIONS[57]}"| $icon_country ${VPN_LOCATIONS[58]}"| $icon_country ${VPN_LOCATIONS[59]}"| $icon_country ${VPN_LOCATIONS[60]}"| $icon_country ${VPN_LOCATIONS[61]}"| $icon_country ${VPN_LOCATIONS[62]}"| $icon_country ${VPN_LOCATIONS[63]}"| $icon_country ${VPN_LOCATIONS[64]}"| $icon_country ${VPN_LOCATIONS[65]}"| $icon_country ${VPN_LOCATIONS[66]}"| $icon_country ${VPN_LOCATIONS[67]}""

	    case "$MENU" in
	    	*connect) vpn_toggle_connection; break;;
			*"${VPN_LOCATIONS[0]}") $VPNCOMMAND_RELAY_SET_LOCATION ${VPN_CODES[0]};;
			*"${VPN_LOCATIONS[1]}") $VPNCOMMAND_RELAY_SET_LOCATION ${VPN_CODES[1]};;
			*"${VPN_LOCATIONS[2]}") $VPNCOMMAND_RELAY_SET_LOCATION ${VPN_CODES[2]};;
			*"${VPN_LOCATIONS[3]}") $VPNCOMMAND_RELAY_SET_LOCATION ${VPN_CODES[3]};;
			*"${VPN_LOCATIONS[4]}") $VPNCOMMAND_RELAY_SET_LOCATION ${VPN_CODES[4]};;
			*"${VPN_LOCATIONS[5]}") $VPNCOMMAND_RELAY_SET_LOCATION ${VPN_CODES[5]};;
			*"${VPN_LOCATIONS[6]}") $VPNCOMMAND_RELAY_SET_LOCATION ${VPN_CODES[6]};;
			*"${VPN_LOCATIONS[7]}") $VPNCOMMAND_RELAY_SET_LOCATION ${VPN_CODES[7]};;
			*"${VPN_LOCATIONS[8]}") $VPNCOMMAND_RELAY_SET_LOCATION ${VPN_CODES[8]};;
			*"${VPN_LOCATIONS[9]}") $VPNCOMMAND_RELAY_SET_LOCATION ${VPN_CODES[9]};;
			*"${VPN_LOCATIONS[10]}") $VPNCOMMAND_RELAY_SET_LOCATION ${VPN_CODES[10]};;
			*"${VPN_LOCATIONS[11]}") $VPNCOMMAND_RELAY_SET_LOCATION ${VPN_CODES[11]};;
			*"${VPN_LOCATIONS[12]}") $VPNCOMMAND_RELAY_SET_LOCATION ${VPN_CODES[12]};;
			*"${VPN_LOCATIONS[13]}") $VPNCOMMAND_RELAY_SET_LOCATION ${VPN_CODES[13]};;
			*"${VPN_LOCATIONS[14]}") $VPNCOMMAND_RELAY_SET_LOCATION ${VPN_CODES[14]};;
			*"${VPN_LOCATIONS[15]}") $VPNCOMMAND_RELAY_SET_LOCATION ${VPN_CODES[15]};;
			*"${VPN_LOCATIONS[16]}") $VPNCOMMAND_RELAY_SET_LOCATION ${VPN_CODES[16]};;
			*"${VPN_LOCATIONS[17]}") $VPNCOMMAND_RELAY_SET_LOCATION ${VPN_CODES[17]};;
			*"${VPN_LOCATIONS[18]}") $VPNCOMMAND_RELAY_SET_LOCATION ${VPN_CODES[18]};;
			*"${VPN_LOCATIONS[19]}") $VPNCOMMAND_RELAY_SET_LOCATION ${VPN_CODES[19]};;
			*"${VPN_LOCATIONS[20]}") $VPNCOMMAND_RELAY_SET_LOCATION ${VPN_CODES[20]};;
			*"${VPN_LOCATIONS[21]}") $VPNCOMMAND_RELAY_SET_LOCATION ${VPN_CODES[21]};;
			*"${VPN_LOCATIONS[22]}") $VPNCOMMAND_RELAY_SET_LOCATION ${VPN_CODES[22]};;
			*"${VPN_LOCATIONS[23]}") $VPNCOMMAND_RELAY_SET_LOCATION ${VPN_CODES[23]};;
			*"${VPN_LOCATIONS[24]}") $VPNCOMMAND_RELAY_SET_LOCATION ${VPN_CODES[24]};;
			*"${VPN_LOCATIONS[25]}") $VPNCOMMAND_RELAY_SET_LOCATION ${VPN_CODES[25]};;
			*"${VPN_LOCATIONS[26]}") $VPNCOMMAND_RELAY_SET_LOCATION ${VPN_CODES[26]};;
			*"${VPN_LOCATIONS[27]}") $VPNCOMMAND_RELAY_SET_LOCATION ${VPN_CODES[27]};;
			*"${VPN_LOCATIONS[28]}") $VPNCOMMAND_RELAY_SET_LOCATION ${VPN_CODES[28]};;
			*"${VPN_LOCATIONS[29]}") $VPNCOMMAND_RELAY_SET_LOCATION ${VPN_CODES[29]};;
			*"${VPN_LOCATIONS[30]}") $VPNCOMMAND_RELAY_SET_LOCATION ${VPN_CODES[30]};;
			*"${VPN_LOCATIONS[31]}") $VPNCOMMAND_RELAY_SET_LOCATION ${VPN_CODES[31]};;
			*"${VPN_LOCATIONS[32]}") $VPNCOMMAND_RELAY_SET_LOCATION ${VPN_CODES[32]};;
			*"${VPN_LOCATIONS[33]}") $VPNCOMMAND_RELAY_SET_LOCATION ${VPN_CODES[33]};;
			*"${VPN_LOCATIONS[34]}") $VPNCOMMAND_RELAY_SET_LOCATION ${VPN_CODES[34]};;
			*"${VPN_LOCATIONS[35]}") $VPNCOMMAND_RELAY_SET_LOCATION ${VPN_CODES[35]};;
			*"${VPN_LOCATIONS[36]}") $VPNCOMMAND_RELAY_SET_LOCATION ${VPN_CODES[36]};;
			*"${VPN_LOCATIONS[37]}") $VPNCOMMAND_RELAY_SET_LOCATION ${VPN_CODES[37]};;
			*"${VPN_LOCATIONS[38]}") $VPNCOMMAND_RELAY_SET_LOCATION ${VPN_CODES[38]};;
			*"${VPN_LOCATIONS[39]}") $VPNCOMMAND_RELAY_SET_LOCATION ${VPN_CODES[39]};;
			*"${VPN_LOCATIONS[40]}") $VPNCOMMAND_RELAY_SET_LOCATION ${VPN_CODES[40]};;
			*"${VPN_LOCATIONS[41]}") $VPNCOMMAND_RELAY_SET_LOCATION ${VPN_CODES[41]};;
			*"${VPN_LOCATIONS[42]}") $VPNCOMMAND_RELAY_SET_LOCATION ${VPN_CODES[42]};;
			*"${VPN_LOCATIONS[43]}") $VPNCOMMAND_RELAY_SET_LOCATION ${VPN_CODES[43]};;
			*"${VPN_LOCATIONS[44]}") $VPNCOMMAND_RELAY_SET_LOCATION ${VPN_CODES[44]};;
			*"${VPN_LOCATIONS[45]}") $VPNCOMMAND_RELAY_SET_LOCATION ${VPN_CODES[45]};;
			*"${VPN_LOCATIONS[46]}") $VPNCOMMAND_RELAY_SET_LOCATION ${VPN_CODES[46]};;
			*"${VPN_LOCATIONS[47]}") $VPNCOMMAND_RELAY_SET_LOCATION ${VPN_CODES[48]};;
			*"${VPN_LOCATIONS[49]}") $VPNCOMMAND_RELAY_SET_LOCATION ${VPN_CODES[49]};;
			*"${VPN_LOCATIONS[50]}") $VPNCOMMAND_RELAY_SET_LOCATION ${VPN_CODES[50]};;
			*"${VPN_LOCATIONS[51]}") $VPNCOMMAND_RELAY_SET_LOCATION ${VPN_CODES[51]};;
			*"${VPN_LOCATIONS[52]}") $VPNCOMMAND_RELAY_SET_LOCATION ${VPN_CODES[52]};;
			*"${VPN_LOCATIONS[53]}") $VPNCOMMAND_RELAY_SET_LOCATION ${VPN_CODES[53]};;
			*"${VPN_LOCATIONS[54]}") $VPNCOMMAND_RELAY_SET_LOCATION ${VPN_CODES[54]};;
			*"${VPN_LOCATIONS[55]}") $VPNCOMMAND_RELAY_SET_LOCATION ${VPN_CODES[55]};;
			*"${VPN_LOCATIONS[56]}") $VPNCOMMAND_RELAY_SET_LOCATION ${VPN_CODES[56]};;
			*"${VPN_LOCATIONS[57]}") $VPNCOMMAND_RELAY_SET_LOCATION ${VPN_CODES[57]};;
			*"${VPN_LOCATIONS[58]}") $VPNCOMMAND_RELAY_SET_LOCATION ${VPN_CODES[58]};;
			*"${VPN_LOCATIONS[59]}") $VPNCOMMAND_RELAY_SET_LOCATION ${VPN_CODES[59]};;
			*"${VPN_LOCATIONS[60]}") $VPNCOMMAND_RELAY_SET_LOCATION ${VPN_CODES[60]};;
			*"${VPN_LOCATIONS[61]}") $VPNCOMMAND_RELAY_SET_LOCATION ${VPN_CODES[61]};;
			*"${VPN_LOCATIONS[62]}") $VPNCOMMAND_RELAY_SET_LOCATION ${VPN_CODES[62]};;
			*"${VPN_LOCATIONS[63]}") $VPNCOMMAND_RELAY_SET_LOCATION ${VPN_CODES[63]};;
			*"${VPN_LOCATIONS[64]}") $VPNCOMMAND_RELAY_SET_LOCATION ${VPN_CODES[64]};;
			*"${VPN_LOCATIONS[65]}") $VPNCOMMAND_RELAY_SET_LOCATION ${VPN_CODES[65]};;
			*"${VPN_LOCATIONS[66]}") $VPNCOMMAND_RELAY_SET_LOCATION ${VPN_CODES[66]};;
			*"${VPN_LOCATIONS[67]}") $VPNCOMMAND_RELAY_SET_LOCATION ${VPN_CODES[67]};;
	    esac

	    if [ "$VPN_STATUS" = "$CONNECTED" ]; then   # TODO maybe change "Connected" for other VPNs
	        true
	    else
	        $VPNCOMMAND_CONNECT
	    fi
	fi
}


# cases for polybar user_module.ini
case "$1" in
    --toggle-connection) vpn_toggle_connection ;;
	--location-menu) vpn_location_menu ;;
	*) vpn_report ;;
esac


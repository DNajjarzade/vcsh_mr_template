#
# Changes and Additions:
#
    # Added a new status action to the function.
    # The status action prints out the current values of all proxy-related environment variables.
    # Used a case statement for better readability and easier expansion of actions.
    # The status function shows "Not set" for variables that are not defined.
#
# Usage:
#
    # Setting the proxy:
#
    # bash
    # toggle_http_proxy set http://proxy.example.com:8080 "localhost,127.0.0.1,.example.com"
#
# Unsetting the proxy:
#
# bash
# toggle_http_proxy unset
#
# Checking proxy status:
#
# bash
# toggle_http_proxy status
#
# Example Output for Status:
# When you run toggle_http_proxy status, you'll see output similar to this:
#
# Current Proxy Settings:
# http_proxy:  http://proxy.example.com:8080
# https_proxy: http://proxy.example.com:8080
# all_proxy:   http://proxy.example.com:8080
# no_proxy:    localhost,127.0.0.1,.example.com
# HTTP_PROXY:  http://proxy.example.com:8080
# HTTPS_PROXY: http://proxy.example.com:8080
# ALL_PROXY:   http://proxy.example.com:8080
# NO_PROXY:    localhost,127.0.0.1,.example.com
#
# If no proxy is set, it will show:
#
# Current Proxy Settings:
# http_proxy:  Not set
# https_proxy: Not set
# all_proxy:   Not set
# no_proxy:    Not set
# HTTP_PROXY:  Not set
# HTTPS_PROXY: Not set
# ALL_PROXY:   Not set
# NO_PROXY:    Not set
#
# This enhanced version of the function provides a comprehensive way to manage and view your proxy settings in the shell environment. Remember to add this function to your .bashrc or .bash_profile file and source it or restart your terminal for the changes to take effect.
# Related
# How can I create a status function to display current variables in bash
# What is the best way to format the output of a status function in bash
# Can I use the declare command to show current variables in bash
# How do I integrate a status function into an existing bash script
# Is it possible to update the status function dynamically in bash
#
function toggle_proxy() {
    local action=$1
    local proxy_url=http://192.168.1.12:8081
    local no_proxy_list=192.168.1.0/24,localhost,git.najjarza.de,*.najjarza.de
    # local proxy_url=$2
    # local no_proxy_list=$3

    case "$action" in
        set)
            if [[ -z "$proxy_url" ]]; then
                echo "Error: Proxy URL is required to set the proxy."
                return 1
            fi
            export http_proxy="$proxy_url"
            export https_proxy="$proxy_url"
            export all_proxy="$proxy_url"
            export HTTP_PROXY="$proxy_url"
            export HTTPS_PROXY="$proxy_url"
            export ALL_PROXY="$proxy_url"
            
            if [[ -n "$no_proxy_list" ]]; then
                export no_proxy="$no_proxy_list"
                export NO_PROXY="$no_proxy_list"
                echo "Proxy set to $proxy_url with no_proxy: $no_proxy_list"
            else
                echo "Proxy set to $proxy_url"
            fi
            ;;
        unset)
            unset http_proxy https_proxy all_proxy no_proxy
            unset HTTP_PROXY HTTPS_PROXY ALL_PROXY NO_PROXY
            echo "All proxy settings unset"
            ;;
        status)
            echo "Current Proxy Settings:"
            echo "http_proxy:  ${http_proxy:-Not set}"
            echo "https_proxy: ${https_proxy:-Not set}"
            echo "all_proxy:   ${all_proxy:-Not set}"
            echo "no_proxy:    ${no_proxy:-Not set}"
            echo "HTTP_PROXY:  ${HTTP_PROXY:-Not set}"
            echo "HTTPS_PROXY: ${HTTPS_PROXY:-Not set}"
            echo "ALL_PROXY:   ${ALL_PROXY:-Not set}"
            echo "NO_PROXY:    ${NO_PROXY:-Not set}"
            ;;
        *)
            echo "Usage: toggle_http_proxy {set|unset|status} [proxy_url] [no_proxy_list]"
            echo "Example: toggle_http_proxy set http://proxy.example.com:8080 'localhost,127.0.0.1'"
            return 1
            ;;
    esac
}

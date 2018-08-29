#!/bin/bash

# Install packages directly through dnf than Ansible since
# it seems to be faster and it can be run in parallel.

HOST=${1-"UNKNOWN"}

echo "Installing packages on host $HOST"

echo "Updating installed packages"
zypper --non-interactive update > /dev/null


# Install packages required for Ansible operation and other common packages
echo "Installing common packages"

#libselinux-python       \

zypper --non-interactive in \
    bash-completion         \
    dnsmasq                 \
    gdb                     \
    git                     \
    ldb-tools               \
    NetworkManager          \
    openldap2-client        \
    python                  \
    python-dnf              \
    python-ldap             \
    tig                     \
    vim                     \
    wget                    \
  > /dev/null

echo "Installing host specific packages"

if [ $HOST == "ipa" ]; then
    zypper --non-interactive in     \
        freeipa-server              \
        freeipa-server-dns          \
        freeipa-server-trust-ad     \
      > /dev/null
fi

if [ $HOST == "ldap" ]; then
    zypper --non-interactive in     \
        389-ds-base                 \
      > /dev/null
fi

if [ $HOST == "client" ]; then
    # adcli                       \
    # samba4-devel                \
    # freeipa-client              \
    # libnfsidmap-devel           \
    # oddjob                      \
    # oddjob-mkhomedir            \
    # selinux-policy-targeted     \
    zypper --non-interactive in     \
        augeas-devel                \
        autoconf                    \
        automake                    \
        bind-utils                  \
        c-ares-devel                \
        check                       \
        check-devel                 \
        cifs-utils-devel            \
        dbus-1-devel                \
        libdbus-1-3                 \
        diffstat                    \
        docbook-xsl-stylesheets     \
        doxygen                     \
        gettext                     \
        gettext-devel               \
        glib2-devel                 \
        http-parser-devel           \
        libjansson-devel            \
        libkeyutils1                \
        keyutils-devel              \
        krb5-devel                  \
        libcmocka0                  \
        libcmocka-devel             \
        libcollection-devel         \
        libcurl-devel               \
        libdhash-devel              \
        libini_config-devel         \
        libldb1                     \
        libldb-devel                \
        libnfsidmap-sss             \
        libnl3-devel                \
        libpath_utils-devel         \
        libref_array-devel          \
        libselinux-devel            \
        libsemanage-devel           \
        libsmbclient-devel          \
        libtalloc2                  \
        libtalloc-devel             \
        libtdb1                     \
        libtdb-devel                \
        libtevent0                  \
        libtevent-devel             \
        libtool                     \
        libuuid-devel               \
        libxml2                     \
        libxslt                     \
        m4                          \
        mozilla-nspr-devel          \
        mozilla-nss-devel           \
        mozilla-nss-tools           \
        nss_wrapper                 \
        openldap2-devel             \
        pam-devel                   \
        pam_wrapper                 \
        pcre-devel                  \
        pkgconfig                   \
        po4a                        \
        popt-devel                  \
        python-devel                \
        python3-devel               \
        realmd                      \
        resolv_wrapper              \
        samba-client                \
        samba-core-devel            \
        libsamba-credentials-devel  \
        libsamba-errors-devel       \
        libsamba-hostconfig-devel   \
        libsamba-passdb-devel       \
        libsamba-policy-devel       \
        libsamba-util-devel         \
        socket_wrapper              \
        sssd                        \
        sssd-*                      \
        systemd-devel               \
        systemtap-sdt-devel         \
        uid_wrapper                 \
        krb5-client                 \
      > /dev/null
        
    zypper --non-interactive in     \
        dbus-1-devel                \
        libcmocka0                  \
        libcollection-devel         \
        libdhash1                   \
        libini_config5              \
        libldb1                     \
        libtalloc2                  \
        libtevent0                  \
      > /dev/null
fi

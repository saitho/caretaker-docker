FROM martinhelmich/typo3-modified:8.7
LABEL maintainer="Mario Lubenka <mario.lubenka@googlemail.com>"

ARG CARETAKER_VERSION=1.0.3
ARG CARETAKER_INSTANCE_VERSION=2.1.2

# Install Caretaker Server
RUN cd /var/www/html && \
    wget https://github.com/TYPO3-Caretaker/caretaker/archive/$CARETAKER_VERSION.tar.gz -O caretaker.tar.gz && \
    tar -xzf caretaker.tar.gz && \
    mkdir -p typo3conf/ext && \
    mv caretaker-$CARETAKER_VERSION typo3conf/ext/caretaker && \
    rm caretaker.tar.gz && \

    # Install Caretaker Instance
    wget https://github.com/TYPO3-Caretaker/caretaker_instance/archive/$CARETAKER_INSTANCE_VERSION.tar.gz -O caretaker_instance.tar.gz && \
    tar -xzf caretaker_instance.tar.gz && \
    mv caretaker_instance-$CARETAKER_INSTANCE_VERSION/ typo3conf/ext/caretaker_instance && \
    rm caretaker_instance.tar.gz

# Enable only Caretaker in PackageStates
RUN echo $"<?php\n\
# PackageStates.php\n\

# This file is maintained by TYPO3's package management. Although you can edit it\n\
# manually, you should rather use the extension manager for maintaining packages.\n\
# This file will be regenerated automatically if it doesn't exist. Deleting this file\n\
# should, however, never become necessary if you use the package commands.\n\

return [\n\
    'packages' => [\n\
        'core' => [ 'packagePath' => 'typo3/sysext/core/' ],\n\
        'extbase' => [ 'packagePath' => 'typo3/sysext/extbase/' ],\n\
        'fluid' => [ 'packagePath' => 'typo3/sysext/fluid/' ],\n\
        'install' => [ 'packagePath' => 'typo3/sysext/install/' ],\n\
        'frontend' => [ 'packagePath' => 'typo3/sysext/frontend/' ],\n\
        'extensionmanager' => [ 'packagePath' => 'typo3/sysext/extensionmanager/' ],\n\
        'lang' => [ 'packagePath' => 'typo3/sysext/lang/' ],\n\
        'setup' => [ 'packagePath' => 'typo3/sysext/setup/' ],\n\
        'rsaauth' => [ 'packagePath' => 'typo3/sysext/rsaauth/' ],\n\
        'saltedpasswords' => [ 'packagePath' => 'typo3/sysext/saltedpasswords/' ],\n\
        'about' => [ 'packagePath' => 'typo3/sysext/about/' ],\n\
        'backend' => [ 'packagePath' => 'typo3/sysext/backend/' ],\n\
        'beuser' => [ 'packagePath' => 'typo3/sysext/beuser/' ],\n\
        'filelist' => [ 'packagePath' => 'typo3/sysext/filelist/' ],\n\
        'recordlist' => [ 'packagePath' => 'typo3/sysext/recordlist/' ],\n\
        'reports' => [ 'packagePath' => 'typo3/sysext/reports/' ],\n\
        'sv' => [ 'packagePath' => 'typo3/sysext/sv/' ],\n\
        'caretaker_instance' => [ 'packagePath' => 'typo3conf/ext/caretaker_instance/' ],\n\
        'caretaker' => [ 'packagePath' => 'typo3conf/ext/caretaker/' ],\n\
    ],\n\
    'version' => 5,\n\
];" > typo3conf/PackageStates.php

# Remove unused system extensions to reduce image size
RUN rm -rf typo3/sysext/tstemplate/ && \
    rm -rf typo3/sysext/viewpage/ && \
    rm -rf typo3/sysext/t3editor/ && \
    rm -rf typo3/sysext/sys_note/ && \
    rm -rf typo3/sysext/lowlevel/ && \
    rm -rf typo3/sysext/impexp/ && \
    rm -rf typo3/sysext/form/ && \
    rm -rf typo3/sysext/felogin/ && \
    rm -rf typo3/sysext/documentation/ && \
    rm -rf typo3/sysext/cshmanual/ && \
    rm -rf typo3/sysext/context_help/ && \
    rm -rf typo3/sysext/belog/ && \
    rm -rf typo3/sysext/wizard_sortpages/ && \
    rm -rf typo3/sysext/wizard_crpages/ && \
    rm -rf typo3/sysext/func/ && \
    rm -rf typo3/sysext/info_pagetsconfig/ && \
    rm -rf typo3/sysext/info/ && \
    rm -rf typo3/sysext/feedit/ && \
    rm -rf typo3/sysext/filemetadata/ && \
    rm -rf typo3/sysext/indexed_search/ && \
    rm -rf typo3/sysext/linkvalidator/ && \
    rm -rf typo3/sysext/opendocs/ && \
    rm -rf typo3/sysext/rte_ckeditor/ && \
    rm -rf typo3/sysext/sys_action/ && \
    rm -rf typo3/sysext/taskcenter/ && \
    rm -rf typo3/sysext/workspaces/ && \
    rm -rf typo3/sysext/version/ && \
    rm -rf typo3/sysext/css_styled_content/ && \
    rm -rf typo3/sysext/fluid_styled_content/

# Adjust permissions
RUN chown -R www-data typo3conf

VOLUME /var/www/html/typo3conf
VOLUME /var/www/html/typo3temp
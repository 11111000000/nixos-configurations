# Edit this configuration file which defines what would be installed on the
# system.  To Help while choosing option value, you can watch at the manual
# page of configuration.nix or at the last chapter of the manual available
# on the virtual console 8 (Alt+F8).

{config, pkgs, modulesPath, ...}:

{
  require = [
    # from hardware-configuration
    "${modulesPath}/profiles/base.nix"
    #XXX: should be turned into a networking enable option (see 3945.nix)?
    "${modulesPath}/hardware/network/intel-5000.nix"
#   "${modulesPath}/services/networking/wicd.nix"
  ];

  boot = {
    initrd = {
      kernelModules = [
        # root fs
        "ahci"
        "ext4"
        # proper console asap
        "fbcon"
        "i915"
	# needed here? came from nixos-option generated hardware-configurations
        #"ehci_hcd"
        #"uhci_hcd"
        #"usb_storage"
        "acpi-cpufreq"
        "cpufreq-ondemand"
      ];
    };
    kernelPackages = pkgs.linuxPackages_2_6_36;
    kernelModules = [
      "kvm-intel"
    ];
    loader.grub = {
      enable = true;
      version = 2;
      device = "/dev/sda";
    };
    postBootCommands = ''
      echo ondemand > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
      echo ondemand > /sys/devices/system/cpu/cpu1/cpufreq/scaling_governor
    '';
    resumeDevice = "254:0";
    vesa = false;
  };

  environment = {
    systemPackages = [
      pkgs.acpitool
      pkgs.cpufrequtils
      pkgs.gcc
      pkgs.git
      pkgs.gnumake
#      pkgs.gnupg_1_4_11
      pkgs.htop
      pkgs.keychain
      pkgs.links2
      pkgs.mutt
      pkgs.offlineimap
      pkgs.powertop
      pkgs.remind
      pkgs.vim_configurable
      pkgs.wget
      pkgs.yacc
      pkgs.zsh
    ];
    x11Packages = [
      pkgs.firefox36Wrapper
      pkgs.awesome
      pkgs.rxvt_unicode
      pkgs.vlc
      pkgs.xlibs.xinput
      pkgs.xlibs.xmessage
      pkgs.xlibs.xmodmap
    ];
  };

  # Add file system entries for each partition that you want to see mounted
  # at boot time.  You can add filesystems which are not mounted at boot by
  # adding the noauto option.
  fileSystems = [
    # Mount the root file system
    #
    { mountPoint = "/";
      label = "nixos";
    }

    # Copy & Paste & Uncomment & Modify to add any other file system.
    #
    # { mountPoint = "/data"; # where you want to mount the device
    #   device = "/dev/sdb"; # the device or the label of the device
    #   # label = "data";
    #   fsType = "ext3";      # the type of the partition.
    #   options = "data=journal";
    # }
    { mountPoint = "/home";
      label = "home";
    }
    { mountPoint = "/mnt/ubuntu";
      label = "ubuntu";
      options = "noauto";
    }
  ];

  networking = {
#    defaultMailServer = {
#      directDelivery = true;
#      domain = "chaoflow.net";
#      hostName = "tesla.chaoflow.net";
#      useSTARTTLS = true;
#    };
    enableWLAN = true;  # Enables Wireless.
    firewall = {
      enable = true;
    };
    hostName = "eve"; # Define your hostname.
    interfaceMonitor.enable = false; # Watch for plugged cable.
  };

  nix.maxJobs = 2;
  nixpkgs.config = {
    # for git svn
    subversion = { perlBindings = true; };
  };

  fonts = {
    enableFontDir = true;
    enableGhostscriptFonts = true;
    extraFonts = [
       pkgs.terminus_font
    ];
  };

  # Select internationalisation properties.
  i18n = {
    consoleFont = "lat9w-16";
    consoleKeyMap = "us";
    defaultLocale = "en_US.UTF-8";
  };

  installer = {
    repos = {
      # this needs gitsvn support, currently only in my branch:
      # https://github.com/chaoflow/nixos/tree/cfl
      nixos = [ { type = "gitsvn"; } ];
      nixpkgs = [ { type = "gitsvn"; } ];
    };
  };

  powerManagement.enable = true;

#  security.sudo.configFile = ''
## Don't edit this file. Set nixos option security.sudo.configFile instead
#
#Defaults env_reset
#Defaults env_keep=LOCALE_ARCHIVE
#
## "root" is allowed to do anything.
#root ALL=(ALL) SETENV: ALL
#
## Users in the "wheel" group can do anything.
#%wheel ALL=(ALL) SETENV: ALL
#  '';
  services.acpid.enable = true;
  services.locate.enable = true;
  services.openssh.enable = true;
  services.printing.enable = true;
  services.ttyBackgrounds.enable = false;
  #services.wicd.enable = true;

  # Add XServer (default if you have used a graphical iso)
  services.xserver = {
    autorun = true;
    # no desktop manager, no window manager configured here. This
    # results in only one session *custom* for slim which executes
    # ~/.xsession. See:
    # https://github.com/chaoflow/chaoflow.skel.home/blob/master/.xsession
    desktopManager.xterm.enable = false;
    displayManager = {
      slim = {
        defaultUser = "cfl";
        hideCursor = true;
      };
    };
    enable = true;
    exportConfiguration = true;
    layout = "us";
    videoDrivers = [ "intel" ];
    xkbOptions = "eurosign:e";
  };

  # Add the NixOS Manual on virtual console 8
  services.nixosManual.showManual = true;

  swapDevices = [
    # List swap partitions that are mounted at boot time.
    { label = "swap"; }
  ];

  time.timeZone = "Europe/Berlin";
}


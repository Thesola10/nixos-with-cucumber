{ config, pkgs, lib, ... }:

{ imports =
  [ ./hardware-configuration.nix
  ];

  networking.hostName = "host";

  boot.loader.grub.enable = false;
  boot.loader.systemd-boot =
    { enable = true;
      configurationLimit = 5;
    };
  boot.enableContainers = true;
}

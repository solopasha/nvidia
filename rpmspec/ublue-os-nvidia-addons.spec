Name:           ublue-os-nvidia-addons
Version:        0.7
Release:        1.1%{?dist}
Summary:        Additional files for nvidia driver support

License:        MIT
URL:            https://github.com/ublue-os/nvidia

BuildArch:      noarch
Supplements:    mokutil policycoreutils

Source0:        nvidia-container-runtime.repo
Source3:        config-rootless.toml
Source4:        nvidia-container.pp
Source5:        environment

%description
Adds various runtime files for nvidia support.

%prep
%setup -q -c -T


%install
# Have different name for *.der in case kmodgenca is needed for creating more keys
install -Dm0644 %{SOURCE0} %{buildroot}%{_datadir}/ublue-os/%{_sysconfdir}/yum.repos.d/nvidia-container-runtime.repo
install -Dm0644 %{SOURCE3} %{buildroot}%{_datadir}/ublue-os/%{_sysconfdir}/nvidia-container-runtime/config-rootless.toml
install -Dm0644 %{SOURCE4} %{buildroot}%{_datadir}/ublue-os/%{_datadir}/selinux/packages/nvidia-container.pp
install -Dm0644 %{SOURCE5} %{buildroot}%{_datadir}/ublue-os/%{_sysconfdir}/sway/environment

sed -i 's@enabled=1@enabled=0@g' %{buildroot}%{_datadir}/ublue-os/%{_sysconfdir}/yum.repos.d/nvidia-container-runtime.repo

install -Dm0644 %{buildroot}%{_datadir}/ublue-os/%{_sysconfdir}/yum.repos.d/nvidia-container-runtime.repo     %{buildroot}%{_sysconfdir}/yum.repos.d/nvidia-container-runtime.repo
install -Dm0644 %{buildroot}%{_datadir}/ublue-os/%{_sysconfdir}/nvidia-container-runtime/config-rootless.toml %{buildroot}%{_sysconfdir}/nvidia-container-runtime/config-rootless.toml
install -Dm0644 %{buildroot}%{_datadir}/ublue-os/%{_datadir}/selinux/packages/nvidia-container.pp             %{buildroot}%{_datadir}/selinux/packages/nvidia-container.pp


%files
%{_datadir}/ublue-os/%{_sysconfdir}/yum.repos.d/nvidia-container-runtime.repo
%{_datadir}/ublue-os/%{_sysconfdir}/nvidia-container-runtime/config-rootless.toml
%{_datadir}/ublue-os/%{_datadir}/selinux/packages/nvidia-container.pp
%{_datadir}/ublue-os/%{_sysconfdir}/sway/environment
%{_sysconfdir}/yum.repos.d/nvidia-container-runtime.repo
%{_sysconfdir}/nvidia-container-runtime/config-rootless.toml
%{_datadir}/selinux/packages/nvidia-container.pp

%changelog
* Sat Jun 17 2023 Benjamin Sherman <benjamin@holyarmy.org> - 0.7
- Remove MOK keys; now provided by ublue-os-akmods-addons

* Sat Jun 17 2023 RJ Trujillo <eyecantcu@pm.me> - 0.6
- Add supergfxctl-plasmoid COPR

* Sun May 17 2023 Benjamin Sherman <benjamin@holyarmy.org> - 0.5
- Add new ublue akmod public key for MOK enrollment

* Sun Mar 26 2023 Joshua Stone <joshua.gage.stone@gmail.com> - 0.4
- Add asus-linux COPR

* Fri Feb 24 2023 Joshua Stone <joshua.gage.stone@gmail.com> - 0.3
- Add sway environment file
- Put ublue-os modifications into a separate data directory

* Thu Feb 16 2023 Joshua Stone <joshua.gage.stone@gmail.com> - 0.2
- Add nvidia-container-runtime repo
- Add nvidia-container-runtime selinux policy file
- Re-purpose into a general-purpose add-on package
- Update URL to point to ublue-os project

* Fri Feb 03 2023 Joshua Stone <joshua.gage.stone@gmail.com> - 0.1
- Add key for enrolling kernel modules in alpha builds

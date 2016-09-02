From: Zefan Li <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: Why would cpu cgroup get disabled by the kernel?
Date: Fri, 2 Sep 2016 17:59:26 +0800
Message-ID: <57C94D7E.4090204@huawei.com>
References: <CAGmahrS4P7kS6_5MOhHA=ge6mcq0C2f85iN9S3z5dgi+qsEh9g@mail.gmail.com>
 <9B0331B6EBBD0E4684FBFAEDA55776F92CE0E032@HASMSX110.ger.corp.intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <9B0331B6EBBD0E4684FBFAEDA55776F92CE0E032-cNwSTNrqBuVnIh7sxsoRyrfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: "Rosen, Rami" <rami.rosen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Sverd Johnsen <sverd.johnsen-gM/Ye1E23mwN+BqQ9rBEUg@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On 2016/9/2 17:44, Rosen, Rami wrote:
> Hi, Sverd,
>=20
> Could it be that you are using the cgroup_nov1=3Dall kernel option (or in=
clude cpu in cgroup_nov1=3D... bitmask)?
> What does cat /proc/cmdline show ?=20
>=20

If the kernel is valinna 4.4.19, there's no cgroup_nov1 option, and I think=
 the only
possibility is cgroup_disable=3Dcpu kernel option.

> Regards,
> Rami Rosen
>=20
>=20
> -----Original Message-----
> From: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:cgrou=
ps-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Sverd Johnsen
> Sent: Friday, September 02, 2016 12:13
> To: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Subject: Why would cpu cgroup get disabled by the kernel?
>=20
> Hi! I'am on 4.4.19 (arm)  and seem to have all requirements for CPU cgrou=
ps build into the kernel:
>=20
>  # zgrep -P "CGROUP|GROUP|FAIR" /proc/config.gz CONFIG_CGROUPS=3Dy # CONF=
IG_CGROUP_DEBUG is not set # CONFIG_CGROUP_FREEZER is not set CONFIG_CGROUP=
_PIDS=3Dy CONFIG_CGROUP_DEVICE=3Dy CONFIG_CGROUP_CPUACCT=3Dy # CONFIG_CGROU=
P_PERF is not set CONFIG_CGROUP_SCHED=3Dy CONFIG_FAIR_GROUP_SCHED=3Dy CONFI=
G_RT_GROUP_SCHED=3Dy CONFIG_BLK_CGROUP=3Dy # CONFIG_DEBUG_BLK_CGROUP is not=
 set # CONFIG_SCHED_AUTOGROUP is not set CONFIG_CFQ_GROUP_IOSCHED=3Dy # CON=
FIG_NET_CLS_CGROUP is not set # CONFIG_CGROUP_NET_PRIO is not set # CONFIG_=
CGROUP_NET_CLASSID is not set # CONFIG_THERMAL_DEFAULT_GOV_FAIR_SHARE is no=
t set # CONFIG_THERMAL_GOV_FAIR_SHARE is not set
>=20
> Other cgroups also work:
>=20
> # findmnt -a
> TARGET                       SOURCE
> FSTYPE     OPTIONS
> |-/sys                       sysfs
> sysfs      rw,nosuid,nodev,noexec,relatime
> | |-/sys/kernel/security     securityfs
> securityfs rw,nosuid,nodev,noexec,relatime
> | |-/sys/fs/cgroup           tmpfs
> tmpfs      ro,nosuid,nodev,noexec,mode=3D755
> | | |-/sys/fs/cgroup/systemd cgroup
> cgroup     rw,nosuid,nodev,noexec,relatime,xattr,release_agent=3D/usr/lib=
/systemd/systemd-cgroups-agent,name=3Dsystemd
> | | |-/sys/fs/cgroup/devices cgroup
> cgroup     rw,nosuid,nodev,noexec,relatime,devices
> | | |-/sys/fs/cgroup/blkio   cgroup
> cgroup     rw,nosuid,nodev,noexec,relatime,blkio
> | | |-/sys/fs/cgroup/pids    cgroup
> cgroup     rw,nosuid,nodev,noexec,relatime,pids
> | | `-/sys/fs/cgroup/cpuacct cgroup
> cgroup     rw,nosuid,nodev,noexec,relatime,cpuacct
>=20
> However I get this:
>=20
> # dmesg | egrep "cgroup|control group"
> [    0.000000] Initializing cgroup subsys cpu
> [    0.000000] Initializing cgroup subsys cpuacct
> [    0.001242] Disabling cpu control group subsystem
> [    0.001263] Initializing cgroup subsys io
> [    0.001289] Initializing cgroup subsys devices
> [    0.001304] Initializing cgroup subsys pids
>=20
> # column -t /proc/cgroups
> #subsys_name  hierarchy  num_cgroups  enabled
> cpu           0          1            0
> cpuacct       5          59           1
> blkio         3          9            1
> devices       2          56           1
> pids          4          64           1
>=20
> Why? really weird. I control the boot process (systemd 231) and nothing t=
here apparently disables it. When I try to mount cpu cgroup manually I just=
 get ENOENT
> --
> To unsubscribe from this list: send the line "unsubscribe cgroups" in the=
 body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org Mor=
e majordomo info at  http://vger.kernel.org/majordomo-info.html
> =13=EF=BF=BD=EF=BF=BD=EC=B9=BB=1C=EF=BF=BD&=EF=BF=BD~=EF=BF=BD&=EF=BF=BD=
=18=EF=BF=BD=EF=BF=BD+-=EF=BF=BD=EF=BF=BD=DD=B6=17=EF=BF=BD=EF=BF=BDw=EF=BF=
=BD=EF=BF=BD=CB=9B=EF=BF=BD=EF=BF=BD=EF=BF=BDm=EF=BF=BD =EF=BF=BD=EF=BF=BD=
=EF=BF=BD=EF=BF=BD)=EF=BF=BD=EF=BF=BD=EF=BF=BDw*=1Fjg=EF=BF=BD=EF=BF=BD=EF=
=BF=BD=1E=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=DD=A2j/=EF=BF=BD=EF=
=BF=BD=EF=BF=BDz=EF=BF=BD=DE=96=EF=BF=BD=EF=BF=BD2=EF=BF=BD=DE=99=EF=BF=BD=
=EF=BF=BD=EF=BF=BD&=EF=BF=BD)=DF=A1=EF=BF=BDa=EF=BF=BD=EF=BF=BD=7F=EF=BF=BD=
=EF=BF=BD=1E=EF=BF=BDG=EF=BF=BD=EF=BF=BD=EF=BF=BDh=EF=BF=BD=0F=EF=BF=BDj:+v=
=EF=BF=BD=EF=BF=BD=EF=BF=BDw=EF=BF=BD=D9=A5
>=20

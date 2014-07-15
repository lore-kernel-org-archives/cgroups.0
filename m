From: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCHSET v2 cgroup/for-3.17] cgroup: distinguish the default
 and legacy hierarchies when handling cftypes
Date: Tue, 15 Jul 2014 18:27:23 +0800
Message-ID: <53C5020B.60303@huawei.com>
References: <1405352648-4279-1-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1405352648-4279-1-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-9"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

=D3=DA 2014/7/14 23:44, Tejun Heo =D0=B4=B5=C0:
> Hello,
>=20
> This is v2 of dfl_files patchset.  Changes from the last version [1]
> are
>=20
> * Rebased on top of cgroup/for-3.17.
>=20
> * 0004 updated so that CFTYPE_ONLY_ON_DFL and CFTYPE_INSANE are
>   cleared when cfts are removed as suggested by Li.
>=20
> Until now, cftype arrays carried files for both the default and legac=
y
> hierarchies and the files which needed to be used on only one of them
> were flagged with either CFTYPE_ONLY_ON_DFL or CFTYPE_INSANE.  This
> gets confusing very quickly and we may end up exposing interface file=
s
> to the default hierarchy without thinking it through.
>=20
> This patchset makes cgroup core provide separate sets of interfaces
> for cftype handling so that the cftypes for the default and legacy
> hierarchies are clearly distinguished.  This makes all the existing
> subsystem interface files legacy-only by default and all subsystems
> will have no interface file created when enabled on the default
> hierarchy.  Each subsystem should explicitly review and compose the
> interface for the default hierarchy.
>=20
> This patchset contains the following six patches.
>=20
>  0001-cgroup-split-cgroup_base_files-into-cgroup_-dfl-lega.patch
>  0002-cgroup-rename-cgroup_subsys-base_cftypes-to-legacy_c.patch
>  0003-cgroup-replace-cgroup_add_cftypes-with-cgroup_add_le.patch
>  0004-cgroup-distinguish-the-default-and-legacy-hierarchie.patch
>  0005-cgroup-make-CFTYPE_ONLY_ON_DFL-and-CFTYPE_NO_-intern.patch
>  0006-cgroup-initialize-cgrp_dfl_root_inhibit_ss_mask-from.patch
>=20
> This patchset is on top of afd1a8b3e0bc ("cpuset: export effective
> masks to userspace")
>=20
> and available in the following git branch.
>=20
>  git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git review-d=
fl_files-v2
>=20
> diffstat follows.  Thanks.
>=20
>  Documentation/cgroups/unified-hierarchy.txt |   18 ++-
>  block/blk-cgroup.c                          |    5
>  include/linux/cgroup.h                      |   17 ++
>  kernel/cgroup.c                             |  160 +++++++++++++++++=
++++-------
>  kernel/cgroup_freezer.c                     |    2
>  kernel/cpuset.c                             |    2
>  kernel/sched/core.c                         |    2
>  kernel/sched/cpuacct.c                      |    2
>  mm/hugetlb_cgroup.c                         |    5
>  mm/memcontrol.c                             |    6 -
>  net/core/netclassid_cgroup.c                |    2
>  net/core/netprio_cgroup.c                   |    2
>  net/ipv4/tcp_memcontrol.c                   |    2
>  security/device_cgroup.c                    |    2
>  14 files changed, 160 insertions(+), 67 deletions(-)
>=20

Acked-by: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

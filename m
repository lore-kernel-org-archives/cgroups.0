From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [GIT PULL] cgroup: Changes for v6.6
Date: Thu, 31 Aug 2023 12:02:18 -1000
Message-ID: <ZPEN6j8Zm6ZfpqxJ@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1693519341; x=1694124141; darn=vger.kernel.org;
        h=content-transfer-encoding:content-disposition:mime-version
         :message-id:subject:cc:to:from:date:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mQOyDv9sjSzw+C3k8cWIKUlFmXgFOg/u8urYymdnFIg=;
        b=bxR1AAsGu/hk+dyUT059z5i0Pgz+9q+sS7WpTWc3Q6I7VnhDQU/pH97KgssRCY2z4b
         UfsS4y8ryzjEBVRfK33YY06ORPyYh9sEcHczmOfctfJWE/H19p4joPIIQjy37goBkWPY
         3HaGOGbqaLGJSrBOBaP0TQo3DKoV4VRFhdflxa9qcOaCHeNv9Ombzlz0OVFCeLiHae3j
         N+8ZxrXHWQ0hNHzq2EmXlrR5NFUSCIxT214nzjMVxQeft/QU6DnZALBlAfbSOTPFid8N
         mVEibLNuxdRGR6E6rj/nXxn+A/UEdqWajk5SHbirwUJyO+2zCmnPHWLpEBaS5khPMJ5L
         6Kew==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

The following changes since commit 3f01e9fed8454dcd89727016c3e5b2fbb8f8e50c:

  Merge tag 'linux-watchdog-6.5-rc2' of git://www.linux-watchdog.org/linux-=
watchdog (2023-07-10 10:04:26 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git/ tags/cgroup-=
for-6.6

for you to fetch changes up to 78d44b824ed04dd1553c55c5b839c9a55cbcaf4e:

  cgroup: Avoid -Wstringop-overflow warnings (2023-08-17 11:55:05 -1000)

----------------------------------------------------------------
cgroup: Changes for v6.6

* Per-cpu cpu usage stats are now tracked. This currently isn't printed out
  in the cgroupfs interface and can only be accessed through e.g. BPF.
  Should decide on a not-too-ugly way to show per-cpu stats in cgroupfs.

* cpuset received some cleanups and prepatory patches for the pending
  cpus.exclusive patchset which will allow cpuset partitions to be created
  below non-partition parents, which should ease the management of partition
  cpusets.

* A lot of code and documentation cleanup patches.

* tools/testing/selftests/cgroup/test_cpuset.c is added. This causes trivial
  conflicts in .gitignore and Makefile under the directory against
  fe3b1bf19bdf ("selftests: cgroup: add test_zswap program"). They can be
  resolved by keeping lines from both branches.

----------------------------------------------------------------
Cai Xinchen (1):
      cgroup/cpuset: fix kernel-doc

Gustavo A. R. Silva (1):
      cgroup: Avoid -Wstringop-overflow warnings

Haitao Huang (2):
      cgroup/misc: Change counters to be explicit 64bit types
      cgroup/misc: Store atomic64_t reads to u64

Han Dapeng (1):
      Documentation: cgroup-v2.rst: Correct number of stats entries

Hao Jia (1):
      cgroup/rstat: Record the cumulative per-cpu time of cgroup and its de=
scendants

Kamalesh Babulal (3):
      cgroup: remove cgrp->kn check in css_populate_dir()
      cgroup/misc: update struct members descriptions
      cgroup: clean up printk()

Lu Jialin (1):
      cgroup:namespace: Remove unused cgroup_namespaces_init()

Miaohe Lin (13):
      cgroup: remove unneeded return value of cgroup_rm_cftypes_locked()
      cgroup: minor cleanup for cgroup_extra_stat_show()
      cgroup/cpuset: simplify the percpu kthreads check in update_tasks_cpu=
mask()
      cgroup/cpuset: avoid unneeded cpuset_mutex re-lock
      cgroup: fix obsolete comment above for_each_css()
      cgroup: put cgroup_tryget_css() inside CONFIG_CGROUP_SCHED
      cgroup: remove obsolete comment above struct cgroupstats
      cgroup: use cached local variable parent in for loop
      cgroup: fix obsolete function name
      cgroup: fix obsolete comment above cgroup_create()
      cgroup: fix obsolete function name above css_free_rwork_fn()
      cgroup: fix obsolete function name in cgroup_destroy_locked()
      cgroup: clean up if condition in cgroup_pidlist_start()

Michal Koutn=FD (3):
      cpuset: Allow setscheduler regardless of manipulated task
      selftests: cgroup: Minor code reorganizations
      selftests: cgroup: Add cpuset migrations testcase

Waiman Long (4):
      cgroup/cpuset: Inherit parent's load balance state in v2
      cgroup/cpuset: Extract out CS_CPU_EXCLUSIVE & CS_SCHED_LOAD_BALANCE h=
andling
      cgroup/cpuset: Improve temporary cpumasks handling
      cgroup/cpuset: Allow suppression of sched domain rebuild in update_cp=
umasks_hier()

Xiongwei Song (2):
      docs: cgroup-v1: correct the term of Page Cache organization in inode
      docs: cgroup-v1: fix typo

 Documentation/admin-guide/cgroup-v1/memory.rst    |   6 +-
 Documentation/admin-guide/cgroup-v2.rst           |   2 +-
 MAINTAINERS                                       |   2 +
 include/linux/cgroup-defs.h                       |  14 ++
 include/linux/misc_cgroup.h                       |  28 +--
 include/uapi/linux/cgroupstats.h                  |   2 -
 kernel/cgroup/cgroup-v1.c                         |   2 +-
 kernel/cgroup/cgroup.c                            |  85 ++++---
 kernel/cgroup/cpuset.c                            | 264 +++++++++++++-----=
---
 kernel/cgroup/misc.c                              |  55 +++--
 kernel/cgroup/namespace.c                         |   6 -
 kernel/cgroup/rstat.c                             |  12 +-
 tools/testing/selftests/cgroup/.gitignore         |   1 +
 tools/testing/selftests/cgroup/Makefile           |   2 +
 tools/testing/selftests/cgroup/cgroup_util.c      |   2 +
 tools/testing/selftests/cgroup/cgroup_util.h      |   2 +
 tools/testing/selftests/cgroup/test_core.c        |   2 +-
 tools/testing/selftests/cgroup/test_cpuset.c      | 275 ++++++++++++++++++=
++++
 tools/testing/selftests/cgroup/test_cpuset_prs.sh |   2 +-
 19 files changed, 560 insertions(+), 204 deletions(-)
 create mode 100644 tools/testing/selftests/cgroup/test_cpuset.c

--=20
tejun

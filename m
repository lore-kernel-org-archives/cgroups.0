From: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 0/5] cpuacct, cgroup: Remove cgroup_subsys.active
Date: Thu, 28 Mar 2013 15:20:04 +0800
Message-ID: <5153EF24.3040608@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

cpuacct is the only user of cgroup_subsys.active flag.

The flag is needed because cpuacct_charge() and cpuacct_account_field() can
be called when cpuacct hasn't been initialized during system bootup.

This patch initializes cpuacct earlier, and the result is we don't have
to check the flag in scheduler hot path.

Note, this patchset is based on "[PATCH 0/7] sched: Split cpuacct"
(just because there're code conflicts)

	http://lkml.org/lkml/2013/3/28/1

0001-cpuacct-allocate-per_cpu-cpuusage-for-root-cpuacct-s.patch
0002-cpuacct-Initialize-root-cpuacct-earlier.patch
0003-cpuacct-Initialize-cpuacct-subsystem-earlier.patch
0004-cpuacct-No-need-to-check-subsys-active-state.patch
0005-cgroup-Remove-subsys.active-flag.patch

--
 include/linux/cgroup.h |  1 -
 kernel/cgroup.c        |  3 ---
 kernel/sched/core.c    |  2 --
 kernel/sched/cpuacct.c | 30 +++++++++++-------------------
 kernel/sched/cpuacct.h |  5 -----
 5 files changed, 11 insertions(+), 30 deletions(-)

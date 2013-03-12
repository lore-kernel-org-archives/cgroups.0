From: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 0/8] cgroup: a bunch of cleanups
Date: Tue, 12 Mar 2013 14:49:52 +0800
Message-ID: <513ED010.5060906@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Hi Tejun,

If you're busy with other stuff, just take your time to go through those
patches.

0001-cgroup-remove-cgroup_is_descentant.patch
0002-cgroup-remove-unused-variables-in-cgroup_destroy_loc.patch
0003-cgroup-hold-cgroup_mutex-before-calling-css_offline.patch
0004-cgroup-don-t-bother-to-resize-pid-array.patch
0005-cgroup-remove-useless-code-in-cgroup_write_event_con.patch
0006-cgroup-remove-unneeded-includes-from-cgroup.h.patch
0007-cgroup-fix-an-almost-harmless-off-by-one-bug.patch
0008-cgroup-consolidate-cgroup_attach_task-and-cgroup_att.patch

---
 Documentation/cgroups/cgroups.txt |   1 +
 include/linux/cgroup.h            |  10 +--
 kernel/cgroup.c                   | 239 +++++++++++-----------------------------------------
 kernel/cpuset.c                   |   2 +-
 4 files changed, 52 insertions(+), 200 deletions(-)

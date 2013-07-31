From: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 0/7] some pending cgroup patches
Date: Wed, 31 Jul 2013 16:16:05 +0800
Message-ID: <51F8C7C5.9040608@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

The first one is a small bug fix, and the rest are pure cleanups.

Li Zefan (7):
      cgroup: fix a leak when percpu_ref_init() fails
      cgroup: remove sparse tags from offline_css()
      cgroup: restructure the failure path in cgroup_write_event_control()
      cgroup: rename cgroup_pidlist->mutex
      cgroup: remove struct cgroup_seqfile_state
      cgroup: rename current_css_set_cg_links
      cgroup: more naming cleanups
--
 include/linux/cgroup.h |   6 +--
 kernel/cgroup.c        | 138 ++++++++++++++++++++++++++++-----------------------------------
 kernel/cpuset.c        |  16 ++++----
 3 files changed, 72 insertions(+), 88 deletions(-)

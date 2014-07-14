From: Tejun Heo <tj@kernel.org>
Subject: [PATCHSET v2 cgroup/for-3.17] cgroup: distinguish the default and legacy hierarchies when handling cftypes
Date: Mon, 14 Jul 2014 11:44:02 -0400
Message-ID: <1405352648-4279-1-git-send-email-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id;
        bh=aOIAtKg6by6+AT95ajkkKm/BAIpVZs71nn+T41+NbAU=;
        b=vpaWBLXmooVNr0UW+dX+AffuxyG6vIKjz3JnNTF1vaqvuoZBVbuEu+OQxUCifWrMDc
         +3stlhHT/mNGkoQT8pu9iC5cM9o7NWQE0g31Xa+vjs++GEfs0z7Xkjzu0Z5+HaxD9Okk
         IXOXg1LJEaq3Md3tsIb0EZ8o+ae8ret27XUXbpFCJBS+bnth/PTuSBs0Ei1C2tU8wevz
         BJcccVsNfuQlAloZoEDsWihGlmNGyi6D7xs3Hkw640Za2pVwR+EXJ+zWHL65XflJnOnH
         s+0e3a2gpIh4MfgyK40kdCiYU3akm/1RqMSOny07ZmBdeo0B1kNwsN/FJVVUAg3K/RlS
         QQFg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan@huawei.com
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

Hello,

This is v2 of dfl_files patchset.  Changes from the last version [1]
are

* Rebased on top of cgroup/for-3.17.

* 0004 updated so that CFTYPE_ONLY_ON_DFL and CFTYPE_INSANE are
  cleared when cfts are removed as suggested by Li.

Until now, cftype arrays carried files for both the default and legacy
hierarchies and the files which needed to be used on only one of them
were flagged with either CFTYPE_ONLY_ON_DFL or CFTYPE_INSANE.  This
gets confusing very quickly and we may end up exposing interface files
to the default hierarchy without thinking it through.

This patchset makes cgroup core provide separate sets of interfaces
for cftype handling so that the cftypes for the default and legacy
hierarchies are clearly distinguished.  This makes all the existing
subsystem interface files legacy-only by default and all subsystems
will have no interface file created when enabled on the default
hierarchy.  Each subsystem should explicitly review and compose the
interface for the default hierarchy.

This patchset contains the following six patches.

 0001-cgroup-split-cgroup_base_files-into-cgroup_-dfl-lega.patch
 0002-cgroup-rename-cgroup_subsys-base_cftypes-to-legacy_c.patch
 0003-cgroup-replace-cgroup_add_cftypes-with-cgroup_add_le.patch
 0004-cgroup-distinguish-the-default-and-legacy-hierarchie.patch
 0005-cgroup-make-CFTYPE_ONLY_ON_DFL-and-CFTYPE_NO_-intern.patch
 0006-cgroup-initialize-cgrp_dfl_root_inhibit_ss_mask-from.patch

This patchset is on top of afd1a8b3e0bc ("cpuset: export effective
masks to userspace")

and available in the following git branch.

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git review-dfl_files-v2

diffstat follows.  Thanks.

 Documentation/cgroups/unified-hierarchy.txt |   18 ++-
 block/blk-cgroup.c                          |    5
 include/linux/cgroup.h                      |   17 ++
 kernel/cgroup.c                             |  160 +++++++++++++++++++++-------
 kernel/cgroup_freezer.c                     |    2
 kernel/cpuset.c                             |    2
 kernel/sched/core.c                         |    2
 kernel/sched/cpuacct.c                      |    2
 mm/hugetlb_cgroup.c                         |    5
 mm/memcontrol.c                             |    6 -
 net/core/netclassid_cgroup.c                |    2
 net/core/netprio_cgroup.c                   |    2
 net/ipv4/tcp_memcontrol.c                   |    2
 security/device_cgroup.c                    |    2
 14 files changed, 160 insertions(+), 67 deletions(-)

--
tejun

[1] http://lkml.kernel.org/g/1404345055-8196-1-git-send-email-tj@kernel.org

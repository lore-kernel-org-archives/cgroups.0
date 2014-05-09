From: Tejun Heo <tj@kernel.org>
Subject: [PATCHSET v2 cgroup/for-3.16] cgroup: post unified hierarchy fixes and updates
Date: Fri,  9 May 2014 15:32:48 -0400
Message-ID: <1399663975-315-1-git-send-email-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id;
        bh=fcYbEtwzASJODVg9oS683FumZItDyoMy24nUQ2ic6SU=;
        b=AAQYSjKLoZ+c/BQDa9CyLl4Mv8cSPDCHdJJyd376wK3uuJWgcOAG9akYj6QM3sIbSU
         xJurVN5qPwG042W1TDEH4TJaZYoDtsKZAKiyaE6fYWJma83NqYojmFxY6Oo1ExxrSKPj
         Omq1sYMi99DsZMniYISJ8j5fdwep1lKfGoVM4tiSjIn+83OmWoGMS66dNxLhYHJtCAtE
         cVDRoeoF5X+yooTlIuys7NXh5vEo4/Q3Kpd5tyaSND7l3ASV8lNPLx6fQoQ768w+OfcR
         uyz/tMiOdaByMKiqZTxjYeKus7Wf2X+qxJ1E32dL3011Tg6ov5qXuJE/9AMiycJGXeO2
         dqhw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan@huawei.com
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

Hello,

Changes from the last take[L] are,

* 0002, 0003 and 0007 added.

* Other patches are refreshed without content change.

This patchset contains the following seven patches.

 0001-cgroup-fix-offlining-child-waiting-in-cgroup_subtree.patch
 0002-cgroup-cgroup_idr_lock-should-be-bh.patch
 0003-cgroup-css_release-shouldn-t-clear-cgroup-subsys.patch
 0004-cgroup-update-and-fix-parsing-of-cgroup.subtree_cont.patch
 0005-cgroup-use-restart_syscall-for-retries-after-offline.patch
 0006-cgroup-use-release_agent_path_lock-in-cgroup_release.patch
 0007-cgroup-rename-css_tryget-to-css_tryget_online.patch

0001 fixes two bugs in cgroup_subtree_control_write().

0004 fixes and makes subtree_control parsing stricter.

0005 simplifies cgroup_substree_control_write() retry path by using
restart_syscall().

0006 makes cgroup_release_agent_show() use release_path_lock.  The
original conversion missed this one.

0007 renames css_tryget() to css_tryget_online().  This patch was
posted separately before - [1] - and acked by Michal and Johannes.

This patchset is on top of cgroup/for-3.16 6e1a046e9458 ("Merge branch
'for-3.16' of git://git.kernel.org/pub/scm/linux/kernel/git/tj/percpu
into for-3.16") and available in the following git branch.

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git review-post-unified-updates-v2

diffstat follows.

 block/blk-cgroup.c     |    2 -
 fs/bio.c               |    2 -
 include/linux/cgroup.h |   14 +++----
 kernel/cgroup.c        |   88 +++++++++++++++++++++++++------------------------
 kernel/cpuset.c        |    6 +--
 kernel/events/core.c   |    3 +
 mm/hugetlb_cgroup.c    |    2 -
 mm/memcontrol.c        |   46 +++++++++++++------------
 8 files changed, 84 insertions(+), 79 deletions(-)

--
tejun

[L] http://lkml.kernel.org/g/1399377044-29873-1-git-send-email-tj@kernel.org
[1] http://lkml.kernel.org/g/20140507160429.GE26540@htj.dyndns.org

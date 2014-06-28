From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCHSET cgroup/for-3.17] cgroup, blkcg, memcg: make blkcg depend on memcg on unified hierarchy
Date: Fri, 27 Jun 2014 21:03:06 -0400
Message-ID: <1403917392-32555-1-git-send-email-tj@kernel.org>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id;
        bh=rzwXDgoEVdsKQcdQXhb6RHm1i8e9Frwe2ccbsGaJjjs=;
        b=OkfJxAoMfIwawl/nBzQmR2y/GPYscLCaHIgr8GccGPA3Y6VXLdPuITr36LMa1JgOLl
         iISX79COBh3ZdPzjPYINO3Hy8kucSXYNCVT2hsRi6+vJmvG+6NF/pSEnaklO+xZDBTwY
         TwEk9qGh0wXGE8P/7CWiVURTyxngYNDsOG5W9VNgEpKGYQn5fbJYOMFTwrV7XPZombO7
         AFtbm4/Jl0OXLvPUs0SFWG2dLiBgD43C4nTsi/Q+8ZCbjNmQ31V3L6/MTHlbN6Ixn8Zj
         kTYof09R9PwJnCe02j6GJvf0GY/r/vMRC7xGSvTNlndYPXnc2LRqmtV8FqEa9Hx6B+ai
         Atzg==
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-AlSwsSmVLrQ@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org

Hello, guys.

Currently, the blkio subsystem attributes all of writeback IOs to the
root.  One of the issues is that there's no way to tell who originated
a writeback IO from block layer.  Those IOs are usually issued
asynchronously from a task which didn't have anything to do with
actually generating the dirty pages.  The memory subsystem, when
enabled, already keeps track of the ownership of each dirty page and
it's desirable for blkio to piggyback instead of adding its own
per-page tag.

This can be achieved on the unified hierarchy without too much
difficulty.  This patchset implements a dependency mechanism in the
cgroup such that a subsystem can depends on other subsystems.  If
available, the depended-upon subsystems are enabled together
implicitly when the subsystem is turned on.  Implicitly enabled
subsystems are invisible and the dependencies are transparent to
userland.

This patchset implements the dependency mechanism in cgroup core and
make blkcg depend on memcg.  This doesn't actually solve the writeback
problem yet but is an important step.

This patchset contains the following six patches.

 0001-cgroup-reorganize-cgroup_subtree_control_write.patch
 0002-cgroup-introduce-cgroup-subtree_control.patch
 0003-cgroup-make-interface-files-visible-iff-enabled-on-c.patch
 0004-cgroup-implement-cgroup_subsys-css_reset.patch
 0005-cgroup-implement-cgroup_subsys-depends_on.patch
 0006-blkcg-memcg-make-blkcg-depend-on-memcg-on-the-defaul.patch

0001-0005 gradually implement the dependency mechanism.

0006 makes blkcg depend on memcg.

This patchset is on top of a497c3ba1d97 ("Linux 3.16-rc2") and
available in the following git branch.

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git review-cgroup-dependency

diffstat follows.  Thanks.

 Documentation/cgroups/cgroups.txt           |   14 +
 Documentation/cgroups/unified-hierarchy.txt |   23 ++-
 block/blk-cgroup.c                          |    7
 include/linux/cgroup.h                      |   20 ++
 kernel/cgroup.c                             |  201 ++++++++++++++++++++++------
 mm/memcontrol.c                             |   24 +++
 6 files changed, 243 insertions(+), 46 deletions(-)

--
tejun

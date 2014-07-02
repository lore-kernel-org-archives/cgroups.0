From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCHSET cgroup/for-3.17] cgroup: remove sane_behavior support on non-default hierarchies
Date: Wed,  2 Jul 2014 19:45:43 -0400
Message-ID: <1404344747-7957-1-git-send-email-tj@kernel.org>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id;
        bh=WMrlzDJYzRLSc+Ao+9+jubKM4WgcKF3yMbx13NOi9y8=;
        b=BOJn3/iFjlMCkMcydFYhPhWaKQT/rsxkCxtl/UQPZCeSdm3O1aeIDb8yKyYvRiZpbK
         ZX+K16Rr4kaDAxGeApsXEojE8/zEDt0ZLsAnC8ccXVZQzFiXMOUBpYoP+kCIL2wdcOQs
         bnNuzYVDPYtb+PU6ZHbuW8xgzJ01/+L+E1JVBh/65DibYkjKWsb1u2JlpbpR1xwEcxWM
         th2tuGMTJcuwLuV3IHgVwsW6yZSWDUBX4oUkRUrhRReIpe31G8tiURJgtXYxjHaU7VlI
         +tAjtP30haisHip7H7KQdQWcI7bYwvHKWVPS/Jd8a9TIrhjBk4Di+37yEs0d4QMbYz8c
         kfIA==
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello,

sane_behavior has been used as a development vehicle for the default
unified hierarchy.  Now that the default hierarchy is in place, the
flag became redundant and confusing as its usage is allowed on all
hierarchies.  There are gonna be either the default hierarchy or
legacy ones.  Let's make that clear by removing sane_behavior support
on non-default hierarchies.

This patchset contains the following four patches.

 0001-cgroup-remove-CGRP_ROOT_OPTION_MASK.patch
 0002-cgroup-make-interface-file-cgroup.sane_behavior-lega.patch
 0003-cgroup-remove-sane_behavior-support-on-non-default-h.patch
 0004-cgroup-clean-up-sane_behavior-handling.patch

0001 is a trivial cleanup.

0002 removes "cgroup.sane_behavior" from the default hierarchy.

0003 removes sane_behavior support on non-default hierarchies.

0004 cleans up sane_behavior handling.

This patchset is on top of a497c3ba1d97 ("Linux 3.16-rc2") and
available in the following git branch.

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git review-dfl-instead-of-sane

diffstat follows.  Thanks.

 block/blk-throttle.c   |    6 +-
 include/linux/cgroup.h |  128 ++++++++++++++++++++-----------------------------
 kernel/cgroup.c        |   96 +++++++++++++++---------------------
 kernel/cpuset.c        |   33 +++++-------
 mm/memcontrol.c        |    7 +-
 5 files changed, 117 insertions(+), 153 deletions(-)

--
tejun

From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCHSET cgroup,block/for-4.3] cgroup, blkcg: establish controller interface conventions
Date: Sun,  2 Aug 2015 16:23:40 -0400
Message-ID: <1438547024-23497-1-git-send-email-tj@kernel.org>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id;
        bh=uvWX6ef5nekJ6vKNeALoytXMbAcJ0xCDQSLGV179YR0=;
        b=FWCmc0COCwi/4D6Wbw5hWnm9yhTydLEkKTGVERP5uDGbcRcYflLTGLjBX/raD9idLK
         7NKw7YLmbkjguAnX7rsNURAmR7SVcWuBu3rv6mtXeZXEpg38oMTrwp6ez9zy4GTSZ5Mg
         j0Y4X1MRXVn0gt2uC0RIAn0SyNygGl9useD9JeQQj1rsnXzUpQXx4Bm52xcbKiS6mdyZ
         3yiGlLDj9x1NGfB1QXgxxgOemElVPFCXufBwv0O/FoB5NzkDRrGWtYezKGIap4EieIjU
         AUueUmXFxp70uVtTQmI2Y2oGpxS5b9LRsKNp0wB8MQqQZI38GJx4KltEh7yCzRt/OAu+
         fPEA==
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, avanzini.arianna-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

Hello,

On the legacy hierarchies, different controllers implemented interface
without much guidance and as a result there isn't much consistency
across controllers even when they're doing similar things.

Controllers which already implemented interface for the unified
hierarchy are already pretty consistent and this patchset explicitly
sets up the conventions so that it's easier to make future conversions
conformant.

For blkcg, the only thing which needs to be changed is the range and
default value of io.weight which is currently [10, 1000] and 500.  For
the unified hierarchy, cgroup now defines the standard range and
default value to be [1, 10000] and 100 so that there's enough room for
100x bias in both directions.

This patchset contains the following four patches.

 0001-cgroup-export-cgrp_dfl_root.patch
 0002-cgroup-define-controller-file-conventions.patch
 0003-blkcg-s-CFQ_WEIGHT_-CFQ_WEIGHT_LEGACY_.patch
 0004-blkcg-use-CGROUP_WEIGHT_-scale-for-io.weight-on-the-.patch

0001-0002 explicitly defines the controller interface file conventions
on the unified hierarchy.  0003-0004 update blkcg so that it conforms
to the standard weight range.

This patchset is also available in the following git branch.

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git review-blkcg-normalize-weight

and is on top of

  block/for-linus f3f5da624e0a ("block: Do a full clone when splitting discard bios")
+ [1] [PATCHSET block/for-4.3] writeback: cgroup writeback updates
+ [2] [PATCHSET v2 block/for-4.3] block, cgroup: make cfq charge async IOs to the appropriate blkcgs
+ [3] [PATCHSET v3 block/for-4.3] blkcg: blkcg policy methods and data handling cleanup
+ [4] [PATCHSET v2 block/for-4.3] blkcg: blkcg stats cleanup
+ [5] [PATCHSET block/for-4.3] blkcg: implement interface for the unified hierarchy

diffstat follows.  Thanks.

 Documentation/cgroups/unified-hierarchy.txt |   77 ++++++++++++++++++++++++----
 block/blk-cgroup.c                          |   21 +++++++
 block/cfq-iosched.c                         |   63 ++++++++++++++++------
 include/linux/blk-cgroup.h                  |    2 
 include/linux/cgroup.h                      |    9 +++
 kernel/cgroup.c                             |    1 
 6 files changed, 145 insertions(+), 28 deletions(-)

--
tejun

[L] http://lkml.kernel.org/g/1435268337-1738-1-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
[1] http://lkml.kernel.org/g/1436281823-1947-1-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
[2] http://lkml.kernel.org/g/1436283361-3889-1-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
[3] http://lkml.kernel.org/g/1436637654-28110-1-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
[4] http://lkml.kernel.org/g/1436724043-12986-1-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
[5] http://lkml.kernel.org/g/1437763434-28699-1-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org

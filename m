From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCHSET block/for-4.2/writeback] blkcg: blkcg stats cleanup
Date: Thu, 25 Jun 2015 17:38:51 -0400
Message-ID: <1435268337-1738-1-git-send-email-tj@kernel.org>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id;
        bh=K6uA5Mubv4VEb6reFZNQhFImW4U0ghVAtpnkX2rxAn8=;
        b=su9pkkFj/d1drLizdTcZIVCKBIHzmMN61Bv+vcj4rXbz44DgfZefkAzhepl6br4Y39
         SSxkJonpQqdjFs+9vFOTCdIGy1obImHt2aUnqfwA3SA4pjebkGXAg+KLyPvPrpmmhFP3
         82Gp4B0MblVKF+24rSDJacu/lP5EZFrSTKVjRoEApVMx22ArH4mQjg3yTDT0BoT6nlRt
         TbBz/WAxGEo7fCtYPVYFWlFLJTsbZh4Ay3I5tgL4PpedOcsu6kVGEPDOuR2A3Qf3qO+e
         yIbaZglfvoHx6EXzpwAoVZuLYaL2maXrau8AJ1M/VM/YB4R6LlqpXkzq+We5SBLC/CwI
         8AAA==
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, avanzini.arianna-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

Hello,

blkcg's stats have always been somwhat of a mess.  This patchset tries
to improve the situation a bit.

* cfq-iosched implements custom recursive stats and blk-throttle
  implements custom per-cpu stats.  This patchset make blkcg core
  support both by default.

* cfq-iosched and blk-throttle keep track of the same stats multiple
  times.  Unify them.

Jens, as we're in the middle of the 4.2 merge window, I'll ping /
repost this patchset along with other pending patchsets once -rc1
drops.

This patchset contains the following six patches.

 0001-cgroup-make-cftype-private-a-unsigned-long.patch
 0002-blkcg-add-blkg_-rw-stat-aux_cnt-and-replace-cfq_grou.patch
 0003-blkcg-make-blkcg_-rw-stat-per-cpu.patch
 0004-blkcg-make-blkg_-rw-stat_recursive_sum-to-be-able-to.patch
 0005-blkcg-move-io_service_bytes-and-io_serviced-stats-in.patch
 0006-blkcg-remove-cfqg_stats-sectors.patch

This patchset is also available in the following git branch.

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git review-blkcg-stats-cleanup

and is on top of

[1] block/for-4.2/writeback
[2] [PATCHSET block/for-4.2/writeback] block, cgroup: make cfq charge async IOs to the appropriate blkcgs
[3] [PATCHSET block/for-4.2/writeback] blkcg: blkcg_policy methods cleanup

diffstat follows.  Thanks.

 block/blk-cgroup.c         |  175 ++++++++++++++++++++++++++++++++------
 block/blk-core.c           |    4 
 block/blk-throttle.c       |  115 +------------------------
 block/cfq-iosched.c        |  204 +++++++++++++++++++++++----------------------
 include/linux/blk-cgroup.h |  181 ++++++++++++++++++++++++++-------------
 include/linux/cgroup.h     |    2 
 6 files changed, 385 insertions(+), 296 deletions(-)

--
tejun

[1] 5857cd637bc0 ("bdi: fix wrong error return value in cgwb_create()").
[2] http://lkml.kernel.org/g/1433753973-23684-1-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
[3] http://lkml.kernel.org/g/1435113853-12053-1-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org

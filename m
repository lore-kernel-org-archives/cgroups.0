From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCHSET 2/3 v2 block/for-4.1/core] writeback: cgroup writeback backpressure propagation
Date: Mon,  6 Apr 2015 16:04:15 -0400
Message-ID: <1428350674-8303-1-git-send-email-tj@kernel.org>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id;
        bh=W2qf8s31QeZnD5jEdSQUYod+TGlmkWxBZYqeXTLaW3A=;
        b=GNkDyQODlt29pOW5Ec/Sq+Je7G240ZXYUMaQc2InlLeG4pAVvnXCTYky12aiLDbhf1
         veTPYDFSh1w1Xg0gRELbdIBXoVNnUYXF0uJrfEdawMEhyXADy7n7l4oxgm8dFnM92cwI
         IWqwsfU/6uQaZNZNZdYSY5o6Yk+yNZcY6hAiIn7j/wS23VEEV2AtnOn4WtO1ELWLAP51
         JOCpEDMEja03gLPzfCC5fKYsrL6aJjM+k3I4ftDht5ocD3FIffvmq+6CwwtT1/75JU7+
         gqnTu2LO4nReM0J8yICAVEGzqRzk4rd0pMvrGL+1yZo8yVNR3sst07WDw16BWVd3/4xR
         WPjg==
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jack-AlSwsSmVLrQ@public.gmane.org, hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, mhocko-AlSwsSmVLrQ@public.gmane.org, clm-b10kYP2dOMg@public.gmane.org, fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org, gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org

Hello,

Changes from the last take[L] are

* 0002-writeback-clean-up-wb_dirty_limit.patch added.

* 0008-writeback-make-__wb_calc_thresh-take-dirty_throttle_.patch was
  scaling the wrong parameter leading to weird throttling behavior.
  Fixed.

* 0019-mm-vmscan-disable-memcg-direct-reclaim-stalling-if-c.patch
  updated so that vmscan behavior when !CONFIG_CGROUP_WRITEBACK isn't
  affected.

While the previous patchset[2] implemented cgroup writeback support,
the IO back pressure propagation mechanism implemented in
balance_dirty_pages() and its subroutines isn't yet aware of cgroup
writeback.

Processes belonging to a memcg may have access to only subset of total
memory available in the system and not factoring this into dirty
throttling rendered it completely ineffective for processes under
memcg limits and memcg ended up building a separate ad-hoc degenerate
mechanism directly into vmscan code to limit page dirtying.

This patchset refactors the dirty throttling logic implemented in
balance_dirty_pages() and its subroutines os that it can handle both
global and memcg memory domains.  Dirty throttling mechanism is
applied against both the global and memcg constraints and the more
restricted of the two is used for actual throttling.

This makes the dirty throttling mechanism operational for memcg
domains including writeback-bandwidth-proportional dirty page
distribution inside them.

This patchset contains the following 19 patches.

 0001-memcg-make-mem_cgroup_read_-stat-event-iterate-possi.patch
 0002-writeback-clean-up-wb_dirty_limit.patch
 0003-writeback-reorganize-__-wb_update_bandwidth.patch
 0004-writeback-implement-wb_domain.patch
 0005-writeback-move-global_dirty_limit-into-wb_domain.patch
 0006-writeback-consolidate-dirty-throttle-parameters-into.patch
 0007-writeback-add-dirty_throttle_control-wb_bg_thresh.patch
 0008-writeback-make-__wb_calc_thresh-take-dirty_throttle_.patch
 0009-writeback-add-dirty_throttle_control-pos_ratio.patch
 0010-writeback-add-dirty_throttle_control-wb_completions.patch
 0011-writeback-add-dirty_throttle_control-dom.patch
 0012-writeback-make-__wb_writeout_inc-and-hard_dirty_limi.patch
 0013-writeback-separate-out-domain_dirty_limits.patch
 0014-writeback-move-over_bground_thresh-to-mm-page-writeb.patch
 0015-writeback-update-wb_over_bg_thresh-to-use-wb_domain-.patch
 0016-writeback-implement-memcg-wb_domain.patch
 0017-writeback-reset-wb_domain-dirty_limit-_tstmp-when-me.patch
 0018-writeback-implement-memcg-writeback-domain-based-thr.patch
 0019-mm-vmscan-disable-memcg-direct-reclaim-stalling-if-c.patch

0001-0003 are prep patches.

0004-0015 refactors dirty throttling logic so that it operates on
wb_domain.

0016-0019 implement memcg wb_domain.

This patchset is on top of

  block/for-4.1/core bfd343aa1718 ("blk-mq: don't wait in blk_mq_queue_enter() if __GFP_WAIT isn't set")
+ [1] [PATCH] writeback: fix possible underflow in write bandwidth calculation
+ [2] [PATCHSET 1/3 v3 block/for-4.1/core] writeback: cgroup writeback support

and available in the following git branch.

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git review-cgroup-writeback-backpressure-20150322

diffstat follows.  Thanks.

 fs/fs-writeback.c                |   32 -
 include/linux/backing-dev-defs.h |    1 
 include/linux/memcontrol.h       |   21 +
 include/linux/writeback.h        |   82 +++-
 include/trace/events/writeback.h |    7 
 mm/backing-dev.c                 |    9 
 mm/memcontrol.c                  |  145 +++++--
 mm/page-writeback.c              |  722 +++++++++++++++++++++++++--------------
 mm/vmscan.c                      |  109 +----
 9 files changed, 716 insertions(+), 412 deletions(-)

--
tejun

[L] http://lkml.kernel.org/g/
[1] http://lkml.kernel.org/g/20150323041848.GA8991-piEFEHQLUPpN0TnZuCh8vA@public.gmane.org
[2] http://lkml.kernel.org/g/

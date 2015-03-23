From: Tejun Heo <tj@kernel.org>
Subject: [PATCHSET 2/3 block/for-4.1/core] writeback: cgroup writeback backpressure propagation
Date: Mon, 23 Mar 2015 01:07:29 -0400
Message-ID: <1427087267-16592-1-git-send-email-tj@kernel.org>
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id;
        bh=5myIwa5Zose88r5pbQud8d0dsoZK/zITqhOAf+3Dxlw=;
        b=y8NsBheJ3PYB50+ngGV53Fk0NWODLidrfi3+waieD3tsRYEZUrcbZ8OWXuz/6G6Irl
         6BKhY+Q67sWwTpYHtBx8RuEVff8IqXsf7n0XKnKioUvFn1T4RRQgM7QOEe4xOYE6bKcv
         jEArvEsww1ZI3w4QqgVaxFEdm3Zj21GgX4SwlUnemXNbcSIfAenW5N0O9PMgpTZXBjP6
         Jd00BqkLrx3sR2yUUGj1pF6s2h3uowSwAUXBPHJ4RiLnTqO6dhsOuhTSv7RwLzlBr6Jl
         Hti0OyG4ED8bfVCl3k+WRO+Wrxp0LSCF/r6aJWkLrPMLRmJIQuYj028w+jqeGIaF5zUt
         G2LA==
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, jack@suse.cz, hch@infradead.org, hannes@cmpxchg.org, linux-fsdevel@vger.kernel.org, vgoyal@redhat.com, lizefan@huawei.com, cgroups@vger.kernel.org, linux-mm@kvack.org, mhocko@suse.cz, clm@fb.com, fengguang.wu@intel.com, david@fromorbit.com, gthelen@google.com

Hello,

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

This patchset contains the following 18 patches.

 0001-memcg-make-mem_cgroup_read_-stat-event-iterate-possi.patch
 0002-writeback-reorganize-__-wb_update_bandwidth.patch
 0003-writeback-implement-wb_domain.patch
 0004-writeback-move-global_dirty_limit-into-wb_domain.patch
 0005-writeback-consolidate-dirty-throttle-parameters-into.patch
 0006-writeback-add-dirty_throttle_control-wb_bg_thresh.patch
 0007-writeback-make-__wb_dirty_limit-take-dirty_throttle_.patch
 0008-writeback-add-dirty_throttle_control-pos_ratio.patch
 0009-writeback-add-dirty_throttle_control-wb_completions.patch
 0010-writeback-add-dirty_throttle_control-dom.patch
 0011-writeback-make-__wb_writeout_inc-and-hard_dirty_limi.patch
 0012-writeback-separate-out-domain_dirty_limits.patch
 0013-writeback-move-over_bground_thresh-to-mm-page-writeb.patch
 0014-writeback-update-wb_over_bg_thresh-to-use-wb_domain-.patch
 0015-writeback-implement-memcg-wb_domain.patch
 0016-writeback-reset-wb_domain-dirty_limit-_tstmp-when-me.patch
 0017-writeback-implement-memcg-writeback-domain-based-thr.patch
 0018-mm-vmscan-remove-memcg-stalling-on-writeback-pages-d.patch

0001-0002 are prep patches.

0003-0014 refactors dirty throttling logic so that it operates on
wb_domain.

0015-0018 implement memcg wb_domain.

This patchset is on top of

  block/for-4.1/core bfd343aa1718 ("blk-mq: don't wait in blk_mq_queue_enter() if __GFP_WAIT isn't set")
+ [1] [PATCH] writeback: fix possible underflow in write bandwidth calculation
+ [2] [PATCHSET 1/3 v2 block/for-4.1/core] writeback: cgroup writeback support

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

[L] http://lkml.kernel.org/g/1420579582-8516-1-git-send-email-tj@kernel.org
[1] http://lkml.kernel.org/g/20150323041848.GA8991@htj.duckdns.org
[2] http://lkml.kernel.org/g/1427086499-15657-1-git-send-email-tj@kernel.org

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>

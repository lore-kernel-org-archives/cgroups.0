From: Tejun Heo <tj@kernel.org>
Subject: [PATCHSET 2/3 v3 block/for-4.2/core] writeback: cgroup writeback backpressure propagation
Date: Fri, 22 May 2015 18:23:17 -0400
Message-ID: <1432333416-6221-1-git-send-email-tj@kernel.org>
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id;
        bh=kEdyySS9+kSwzbiqCIf+V4GNq9SQejfUvekDQVgSnnY=;
        b=EpE+KxaKOT1ZQq+SHya6oHxa2Ze0tZgprBJB2I3VX6WJ/NzfskoVl+aAfJ4XIhXXqG
         YAXAuQ4sYtAbj0qGT9piX/MECm8Gj3cCknpRiNJDQFm5dG0Qpe07xRkclzKN5EYgoKKG
         1HIGW1gfz8GWK6MX52tMK8IE9gvd9Qzw12t3oHbZGpIPpdAnJpFZFnrohFC72J+dsIah
         yzsFNbT8ChndTntgZo4xNHvvR3tTLd8cMLbik0vJNeQuc32LKSWb1r8s7/XkeAM4nsS5
         6Xrt+JjpuPPZLPix+QCRrWX6wPZtJoDRk0B4uIuM+/iJC02hHXIu1qKGLsKMgjiizhd3
         Sn2g==
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, jack@suse.cz, hch@infradead.org, hannes@cmpxchg.org, linux-fsdevel@vger.kernel.org, vgoyal@redhat.com, lizefan@huawei.com, cgroups@vger.kernel.org, linux-mm@kvack.org, mhocko@suse.cz, clm@fb.com, fengguang.wu@intel.com, david@fromorbit.com, gthelen@google.com, khlebnikov@yandex-team.ru

Hello,

Changes from the last take[L] are

* Rebased on top of block/for-4.2/core.

While the previous patchset[1] implemented cgroup writeback support,
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

  block/for-4.2/core b04a5636a665 ("block: replace trylock with mutex_lock in blkdev_reread_part()")
+ [1] [PATCHSET 1/3 v4 block/for-4.2/core] writeback: cgroup writeback support

and available in the following git branch.

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git review-cgroup-writeback-backpressure-20150522

diffstat follows.  Thanks.

 fs/fs-writeback.c                |   32 -
 include/linux/backing-dev-defs.h |    1 
 include/linux/memcontrol.h       |   21 +
 include/linux/writeback.h        |   84 +++-
 include/trace/events/writeback.h |    7 
 mm/backing-dev.c                 |   15 
 mm/memcontrol.c                  |  145 +++++--
 mm/page-writeback.c              |  744 +++++++++++++++++++++++++--------------
 mm/vmscan.c                      |   51 ++
 9 files changed, 739 insertions(+), 361 deletions(-)

--
tejun

[L] http://lkml.kernel.org/g/1428350674-8303-1-git-send-email-tj@kernel.org
[1] http://lkml.kernel.org/g/1432329245-5844-1-git-send-email-tj@kernel.org

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>

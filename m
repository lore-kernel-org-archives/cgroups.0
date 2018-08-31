From: Dennis Zhou <dennisszhou@gmail.com>
Subject: [PATCH 00/15] blkcg ref count refactor/cleanup + blkcg avg_lat
Date: Thu, 30 Aug 2018 21:53:41 -0400
Message-ID: <20180831015356.69796-1-dennisszhou@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=lTD1Ps/FbavEAiwg4U+GtxM5IKlNXvp/Uhyx42P8vp8=;
        b=WFzxyVb1cI9gSVLkDAsvn3VSewaZLYOA9M6eezx+fnI6QzkATIFXMgWqRcM3Ae+NYd
         NIZZH8xFe21mTOpXZTyNxOPFW5G51nME5U9xqIbXzH1ZjLxJ32XzJuv8wSOEax55VcDm
         u8fESKST2EpewrcDYhjt+mm9TAzH556dyEnuX1oQD6SooDXWI+D0544L/MtZ2TPM8++Y
         pxxX3aLff73DDXiu7wvLPXx9bPKcdd/1LNSNqxa6Kbbd/5XR1F+tQttnBVB+chWKXYgL
         XwWNIBD/aJdP6NyA+ZGf7Da4o6ZrwxOj/AhUPeegjjXAwJYqW4KttGaAjeE3bRFTgtK2
         6zHA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, Josef Bacik <josef@toxicpanda.com>
Cc: kernel-team@fb.com, linux-block@vger.kernel.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Dennis Zhou <dennisszhou@gmail.com>

Hi everyone,

This is a fairly lengthy patchset that aims to cleanup reference
counting for blkcgs and blkgs. There are 4 problems that this patchset
tries to address:
  1. fix blkcg destruction
  2. always associate a bio with a blkg
  3. remove the extra css ref held by bios and utilize the blkg ref
  4. add average latency tracking to blkcg core in io.stat.

First, there is a regression in blkcg destruction where references
weren't properly put causing blkcgs to never be destroyed. Previously,
blkgs were destroyed during offlining of the blkcg. This puts back the
blkcg reference a blkg holds allowing blkcg ref to reach zero. Then,
blkcg_css_free() is called as part of the final cleanup.

To address the first problem, 0001 reverts the broken commit, 0002
delays blkg destruction until writeback has finished, and 0003 closes
the window on a race condition between a css migration and dying, and 
blkg association. This should fix the issue where blkg_get() was getting
called when a blkcg had already begun exiting. If a bio finds itself
here, it will just fall back to root. Oddly enough at one point,
blk-throttle was using policy data from and associating with potentially
different blkgs, thus how this was exposed.

0004 also address a similar problem with task_css(current, ...) where
association tries to get a css of a task that is migrating with the
cgroup dying.

Second, both blk-throttle and blk-iolatency rely on blkg association
to enable their policies. Rather than each policy (and future policies)
implement this logic independently, this consolidates it such that
all bios are tagged with a blkg.

Third, with the addition of always having a blkg reference, the blkcg
can now be referenced through it rather than maintaining an additional
pointer and reference. So let's clean this up.

Finally, it seems rather useful to know on average how well IOs are
doing per cgroup. This adds the average latency statistic to core where
it encompasses IOs from all decendants.

This patchset contains the following 15 patches:

  0001-Revert-blk-throttle-fix-race-between-blkcg_bio_issue.patch
  0002-blkcg-delay-blkg-destruction-until-after-writeback-h.patch
  0003-blkcg-use-tryget-logic-when-associating-a-blkg-with-.patch
  0004-blkcg-fix-ref-count-issue-with-bio_blkcg-using-task_.patch
  0005-blkcg-update-blkg_lookup_create-to-do-locking.patch
  0006-blkcg-always-associate-a-bio-with-a-blkg.patch
  0007-blkcg-consolidate-bio_issue_init-and-blkg-associatio.patch
  0008-blkcg-associate-a-blkg-for-pages-being-evicted-by-sw.patch
  0009-blkcg-associate-writeback-bios-with-a-blkg.patch
  0010-blkcg-remove-bio-bi_css-and-instead-use-bio-bi_blkg.patch
  0011-blkcg-remove-additional-reference-to-the-css.patch
  0012-blkcg-cleanup-and-make-blk_get_rl-use-blkg_lookup_cr.patch
  0013-blkcg-change-blkg-reference-counting-to-use-percpu_r.patch
  0014-blkcg-rename-blkg_try_get-to-blkg_tryget.patch
  0015-blkcg-add-average-latency-tracking-to-blk-cgroup.patch

0001-0003 addresses the regression in the blkcg cleanup path.
0004 fixes a small window race condition with task_css(current, ...).
0005 is a prepatory patch that cleans up blkg lookup create.
0006-0009 associates all bios with a blkg: regular IO, swap, writeback.
0010 removes the extra css pointer in bios.
0011 removes the implicit reference left behind in 0010.
0012 cleans up blk_get_rl making use of the new blkg ref
0013 changes blkg ref counting from atomic to percpu.
0014 renames and makes blkg_try_get consistent with css_tryget.
0015 adds average latency tracking as part of blk-cgroup.

This patchset is on top of axboe#for-4.19/block #b86d865cb1ca.

diffstats below:

Dennis Zhou (Facebook) (15):
  Revert "blk-throttle: fix race between blkcg_bio_issue_check() and
    cgroup_rmdir()"
  blkcg: delay blkg destruction until after writeback has finished
  blkcg: use tryget logic when associating a blkg with a bio
  blkcg: fix ref count issue with bio_blkcg using task_css
  blkcg: update blkg_lookup_create to do locking
  blkcg: always associate a bio with a blkg
  blkcg: consolidate bio_issue_init and blkg association
  blkcg: associate a blkg for pages being evicted by swap
  blkcg: associate writeback bios with a blkg
  blkcg: remove bio->bi_css and instead use bio->bi_blkg
  blkcg: remove additional reference to the css
  blkcg: cleanup and make blk_get_rl use blkg_lookup_create
  blkcg: change blkg reference counting to use percpu_ref
  blkcg: rename blkg_try_get to blkg_tryget
  blkcg: add average latency tracking to blk-cgroup

 Documentation/admin-guide/cgroup-v2.rst |  14 +-
 block/bio.c                             | 187 +++++++++++----
 block/blk-cgroup.c                      | 298 +++++++++++++++++-------
 block/blk-iolatency.c                   |  26 +--
 block/blk-throttle.c                    |  12 +-
 block/bounce.c                          |   4 +-
 drivers/block/loop.c                    |   5 +-
 drivers/md/raid0.c                      |   2 +-
 fs/buffer.c                             |  10 +-
 fs/ext4/page-io.c                       |   2 +-
 include/linux/bio.h                     |  23 +-
 include/linux/blk-cgroup.h              | 167 ++++++++-----
 include/linux/blk_types.h               |   1 -
 include/linux/cgroup.h                  |   2 +
 include/linux/writeback.h               |   5 +-
 kernel/cgroup/cgroup.c                  |   4 +-
 kernel/trace/blktrace.c                 |   4 +-
 mm/backing-dev.c                        |   5 +
 mm/page_io.c                            |   2 +-
 19 files changed, 520 insertions(+), 253 deletions(-)

Thanks,
Dennis

From: Dennis Zhou <dennisszhou@gmail.com>
Subject: [PATCH 00/12] block: always associate blkg and refcount cleanup
Date: Thu,  6 Sep 2018 17:10:33 -0400
Message-ID: <20180906211045.29055-1-dennisszhou@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=CxZOb6PLVyhKJ0NyoVh/rmba5v2FOrA4jy/PeKrQmVU=;
        b=PMAfn8PKSyjmkhupwy6gvyXjIUw/ADlttACBgrlrRIWf5ZqZGoudw3bLYfmLS+/k4d
         LzuBd1K6MCR5Xu6acHb7BkPXpskr63OYYIphueqoEdHlpvG9GyS4iZS9kkAOT9RjkiSN
         36/gRT2W9p6yHJCqzW5evoahJ8KmTkYTgV9RdF1CIEC/bxV6I+SB2VEN6Ol3vp/cXMgW
         3WyTjjV8o4MUCcokWKLvyxdYf8Gw7NU7cO/KyTqqBYRig7AIe/lwuhJd+wVIp+2lfd89
         Px8eETTDCbMF0KeUFaOgwEPd8hP0N8EMPAe/HmtLXfUn6Qnm8XrtTc2sI5gK79Adp07Z
         3tGw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, Josef Bacik <josef@toxicpanda.com>
Cc: kernel-team@fb.com, linux-block@vger.kernel.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Dennis Zhou <dennisszhou@gmail.com>

Hi everyone,

This is a followup to the patch series I sent out earlier [1] containing
the middle two points:
  1. always associate a bio with a blkg
  2. remove the extra css ref held by bios and utilize the blkg ref

The major difference with v2 is that error handling on blkg creation
and association failure is handled more gracefully. Rather than having
the complex logic to fallback to root, failures walk up the blkg tree.
This seems more natural and less prone to error with the many possible
failure scenarios.

Additionally, there are fixes for kbuild errors and some key details
overlooked by me in the first series that were pointed out in review.

Modified from the first patchset:
First, both blk-throttle and blk-iolatency rely on blkg association
to enable their policies. Rather than each policy (and future policies)
implement this logic independently, this consolidates it such that
all bios are tagged with a blkg.

Second, with the addition of always having a blkg reference, the blkcg
can now be referenced through it rather than maintaining an additional
pointer and reference. So let's clean this up.

[1] https://lore.kernel.org/lkml/20180831015356.69796-1-dennisszhou@gmail.com/T

This patchset contains the following 12 patches:
  0001-blkcg-fix-ref-count-issue-with-bio_blkcg-using-task_.patch
  0002-blkcg-update-blkg_lookup_create-to-do-locking.patch
  0003-blkcg-convert-blkg_lookup_create-to-find-closest-blk.patch
  0004-blkcg-always-associate-a-bio-with-a-blkg.patch
  0005-blkcg-consolidate-bio_issue_init-to-be-a-part-of-cor.patch
  0006-blkcg-associate-a-blkg-for-pages-being-evicted-by-sw.patch
  0007-blkcg-associate-writeback-bios-with-a-blkg.patch
  0008-blkcg-remove-bio-bi_css-and-instead-use-bio-bi_blkg.patch
  0009-blkcg-remove-additional-reference-to-the-css.patch
  0010-blkcg-cleanup-and-make-blk_get_rl-use-blkg_lookup_cr.patch
  0011-blkcg-change-blkg-reference-counting-to-use-percpu_r.patch
  0012-blkcg-rename-blkg_try_get-to-blkg_tryget.patch

This patchset is on top of axboe#for-next 9c8f7b6493d9, a merge commit
from merging back axboe#for-linus.

diffstats below:

Dennis Zhou (Facebook) (12):
  blkcg: fix ref count issue with bio_blkcg using task_css
  blkcg: update blkg_lookup_create to do locking
  blkcg: convert blkg_lookup_create to find closest blkg
  blkcg: always associate a bio with a blkg
  blkcg: consolidate bio_issue_init to be a part of core
  blkcg: associate a blkg for pages being evicted by swap
  blkcg: associate writeback bios with a blkg
  blkcg: remove bio->bi_css and instead use bio->bi_blkg
  blkcg: remove additional reference to the css
  blkcg: cleanup and make blk_get_rl use blkg_lookup_create
  blkcg: change blkg reference counting to use percpu_ref
  blkcg: rename blkg_try_get to blkg_tryget

 Documentation/admin-guide/cgroup-v2.rst |   8 +-
 block/bfq-cgroup.c                      |   4 +-
 block/bfq-iosched.c                     |   2 +-
 block/bio.c                             | 153 ++++++++++++++++--------
 block/blk-cgroup.c                      | 120 +++++++++++++------
 block/blk-iolatency.c                   |  26 +---
 block/blk-throttle.c                    |  13 +-
 block/bounce.c                          |   4 +-
 block/cfq-iosched.c                     |   4 +-
 drivers/block/loop.c                    |   5 +-
 drivers/md/raid0.c                      |   2 +-
 fs/buffer.c                             |  10 +-
 fs/ext4/page-io.c                       |   2 +-
 include/linux/bio.h                     |  23 ++--
 include/linux/blk-cgroup.h              | 147 ++++++++++++++++-------
 include/linux/blk_types.h               |   1 -
 include/linux/cgroup.h                  |   2 +
 include/linux/writeback.h               |   5 +-
 kernel/cgroup/cgroup.c                  |  53 ++++++--
 kernel/trace/blktrace.c                 |   4 +-
 mm/page_io.c                            |   2 +-
 21 files changed, 380 insertions(+), 210 deletions(-)

Thanks,
Dennis

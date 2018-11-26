From: Dennis Zhou <dennis@kernel.org>
Subject: [PATCH 00/13 v4] block: always associate blkg and refcount cleanup
Date: Mon, 26 Nov 2018 16:19:33 -0500
Message-ID: <20181126211946.77067-1-dennis@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, Josef Bacik <josef@toxicpanda.com>
Cc: kernel-team@fb.com, linux-block@vger.kernel.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Dennis Zhou <dennis@kernel.org>

Hi everyone,

This is respin of v3 [1] with fixes for the errors reported in [2] and
[3]. v3 was reverted in [4].

The issue in [3] was that bio->bi_disk->queue and blkg->q were out
of sync. So when I changed blk_get_rl() to use blkg->q, the wrong queue
was returned and elevator from q->elevator->type threw a NPE. Note, with
v4.21, the old block stack was removed and so this patch was dropped. I
did backport this to v4.20 and verified this series does not encounter
the error.

The biggest changes in v4 are when association occurs and clearly
defining the cases where association should happen.
  1. Association is now done when the device is set to keep blkg->q and
     bio->bi_disk->queue in sync.
  2. When a bio is submitted directly to the device, it will not be
     associated with a blkg. This is because a blkg represents the
     relationship between a blkcg and a request_queue. Going directly to
     the device means the request_queue may not exist meaning no blkg
     will exist.

The patch updating blk_get_rl() was dropped (v3 10/12). The patch to
always associate a blkg from v3 (v3 04/12) was fixed and split into
patches 0004 and 0005. 0011 is new removing bio_disassociate_task().

Summarizing the ideas of this series:
  1. Gracefully handle blkg failure to create by walking up the blkg
     tree rather than fall through to root.
  2. Associate a bio with a blkg in core logic rather than per
     controller logic.
  3. Rather than have a css and blkg reference, hold just a blkg ref
     as it also holds a css ref.
  4. Switch to percpu ref counting for blkg.

[1] https://lore.kernel.org/lkml/20180911184137.35897-1-dennisszhou@gmail.com/ 
[2] https://lore.kernel.org/lkml/13987.1539646128@turing-police.cc.vt.edu/
[3] https://marc.info/?l=linux-cgroups&m=154110436103723
[4] https://lore.kernel.org/lkml/20181101212410.47569-1-dennis@kernel.org/

This patchset contains the following 13 patches:
  0001-blkcg-fix-ref-count-issue-with-bio_blkcg-using-task_.patch
  0002-blkcg-update-blkg_lookup_create-to-do-locking.patch
  0003-blkcg-convert-blkg_lookup_create-to-find-closest-blk.patch
  0004-blkcg-introduce-common-blkg-association-logic.patch
  0005-blkcg-associate-blkg-when-associating-a-device.patch
  0006-blkcg-consolidate-bio_issue_init-to-be-a-part-of-cor.patch
  0007-blkcg-associate-a-blkg-for-pages-being-evicted-by-sw.patch
  0008-blkcg-associate-writeback-bios-with-a-blkg.patch
  0009-blkcg-remove-bio-bi_css-and-instead-use-bio-bi_blkg.patch
  0010-blkcg-remove-additional-reference-to-the-css.patch
  0011-blkcg-remove-bio_disassociate_task.patch
  0012-blkcg-change-blkg-reference-counting-to-use-percpu_r.patch
  0013-blkcg-rename-blkg_try_get-to-blkg_tryget.patch

This patchset is on top of linux-block#for-4.21/block 5f0ed774ed29.

diffstats below:

Dennis Zhou (13):
  blkcg: fix ref count issue with bio_blkcg() using task_css
  blkcg: update blkg_lookup_create() to do locking
  blkcg: convert blkg_lookup_create() to find closest blkg
  blkcg: introduce common blkg association logic
  blkcg: associate blkg when associating a device
  blkcg: consolidate bio_issue_init() to be a part of core
  blkcg: associate a blkg for pages being evicted by swap
  blkcg: associate writeback bios with a blkg
  blkcg: remove bio->bi_css and instead use bio->bi_blkg
  blkcg: remove additional reference to the css
  blkcg: remove bio_disassociate_task()
  blkcg: change blkg reference counting to use percpu_ref
  blkcg: rename blkg_try_get() to blkg_tryget()

 Documentation/admin-guide/cgroup-v2.rst |   8 +-
 block/bfq-cgroup.c                      |   4 +-
 block/bfq-iosched.c                     |   2 +-
 block/bio.c                             | 189 ++++++++++++++++--------
 block/blk-cgroup.c                      |  97 ++++++++++--
 block/blk-iolatency.c                   |  24 +--
 block/blk-throttle.c                    |  11 --
 block/bounce.c                          |   4 +-
 drivers/block/loop.c                    |   5 +-
 drivers/md/raid0.c                      |   2 +-
 fs/buffer.c                             |  12 +-
 fs/ext4/page-io.c                       |   4 +-
 include/linux/bio.h                     |  34 +++--
 include/linux/blk-cgroup.h              | 119 ++++++++++-----
 include/linux/blk_types.h               |   7 +-
 include/linux/cgroup.h                  |   2 +
 include/linux/writeback.h               |   5 +-
 kernel/cgroup/cgroup.c                  |  48 ++++--
 kernel/trace/blktrace.c                 |   4 +-
 mm/page_io.c                            |   4 +-
 20 files changed, 396 insertions(+), 189 deletions(-)

Thanks,
Dennis

From: Dennis Zhou <dennisszhou@gmail.com>
Subject: [PATCH 0/3] fix blkcg offlining and destruction
Date: Fri, 31 Aug 2018 16:22:41 -0400
Message-ID: <20180831202244.21678-1-dennisszhou@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=mCSyTNKfNKsNWY9w2u1+8RMVPIGW7DHIDC+leU6W8m8=;
        b=TZZjRUqYnoro5nUsjPf4UN65TUPobFhe4ZygsrYrMZsdBT8kXARk8ydRzJl1CDvRlS
         o+1t6T8YeZmEIECE+Od52gLZvTiX89eIn7xwepHE5n3plMboWl3vXM+hj1ViKIG0crH9
         TW8X6BgfTkiTWBXaJziBZiv+UxF1FYxS07PgHlynQG1heAYrfX1u7PZ2PevhvWlxsinh
         NSh9hm2HhRdZKfD66dEof/OzDNZtagZyvgCQ+vXDA3j+AGSWROafB1MOSoshXy1bA7P8
         baEisqpwl+R5vtdE9zpy6j8X9dP8/+jFCaEfutFQmvUSajV+KIGDNgTzTRCnn/H0cReI
         mYYw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, Josef Bacik <josef@toxicpanda.com>
Cc: kernel-team@fb.com, linux-block@vger.kernel.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Dennis Zhou <dennisszhou@gmail.com>

Hi everyone,

This is a split of an earlier series I sent out [1] containing the first
3 patches with fixes from feedback. This series tackles the first
problem where blkcgs were not being destroyed.

There is a regression in blkcg destruction where references weren't
properly put causing blkcgs to never be destroyed. Previously, blkgs
were destroyed during offlining of the blkcg. This puts back the blkcg
reference a blkg holds allowing blkcg ref to reach zero. Then,
blkcg_css_free() is called as part of the final cleanup.

To address the problem, 0001 reverts the broken commit, 0002 delays
blkg destruction until writeback has finished, and 0003 closes the
window on a race condition between a css migration and dying, and
blkg association. This should fix the issue where blkg_get() was getting
called when a blkcg had already begun exiting. If a bio finds itself
here, it will just fall back to root. Oddly enough at one point,
blk-throttle was using policy data from and associating with potentially
different blkgs, thus how this was exposed.

[1] https://lore.kernel.org/lkml/20180831015356.69796-1-dennisszhou@gmail.com/T

This patchset contains the following 3 patches:
  0001-Revert-blk-throttle-fix-race-between-blkcg_bio_issue.patch
  0002-blkcg-delay-blkg-destruction-until-after-writeback-h.patch
  0003-blkcg-use-tryget-logic-when-associating-a-blkg-with-.patch

0001 reverts the broken commit.
0002 delays blkg destruction until after writeback.
0003 fixes a race condition for ongoing IO and blkcg destruction.

This patchset is on top of axboe#for-4.19/block b86d865cb1ca.

diffstats below:

Dennis Zhou (Facebook) (3):
  Revert "blk-throttle: fix race between blkcg_bio_issue_check() and
    cgroup_rmdir()"
  blkcg: delay blkg destruction until after writeback has finished
  blkcg: use tryget logic when associating a blkg with a bio

 block/bio.c                |   3 +-
 block/blk-cgroup.c         | 105 +++++++++++++++++--------------------
 block/blk-throttle.c       |   5 +-
 include/linux/blk-cgroup.h |  45 +++++++++++++++-
 mm/backing-dev.c           |   5 ++
 5 files changed, 102 insertions(+), 61 deletions(-)

Thanks,
Dennis

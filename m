From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCHSET 3/3 v4 block/for-4.2/core] writeback: implement foreign cgroup inode bdi_writeback switching
Date: Thu, 28 May 2015 14:50:48 -0400
Message-ID: <1432839057-17609-1-git-send-email-tj@kernel.org>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id;
        bh=zDUu0ds4nqMdPLJ0bKQxF0KGWJrkLx6ayqI1Wheb7EA=;
        b=a1Rd93IMhJHlx1tqX2Qukpqxgd+CYSjj0/KaMHg7DNXdYZl6eq1E2i/1W41xFiCR/D
         1UuMcKcFbtxoRNucKvzSqnV9J+Z3wqH/HWDkOF2jyTKJ6YN+tP/c4k+3Yk1TBqt0TqZJ
         UGVVqpWvBmZF+AjaO52Bt2ExBeUC9FLVOZ2RsW6mxoe7uGDXLGPKxAWq3WkRrC4SOtLh
         WhJc/7v3h2BO3IiMyHujLXn5e80K+bbTp66kbZRrLqRDzrZ6qPn1/eSHQmC2EDwe0YwU
         sGnmu/ZKtv7JhqeWUoKPKNLm7CfBzcisxh1xbCOUWSsnz87SUEMidcOqYZ4whu5gDgGG
         hjiQ==
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jack-AlSwsSmVLrQ@public.gmane.org, hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, mhocko-AlSwsSmVLrQ@public.gmane.org, clm-b10kYP2dOMg@public.gmane.org, fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org, gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org

Hello,

The changes from the last take[L] are

* 0002-writeback-make-writeback_control-track-the-inode-bei.patch and
  0003-writeback-implement-foreign-cgroup-inode-detection.patch
  assumed that all wbc's are attached to the inode and wb being
  written out; however, pageout() path doesn't participate in cgroup
  writeback leading to oops.

  pageout() isn't the main writeback path, so the impact on isolation
  is relatively limited and as the whole path runs on the same thread
  we don't want it to block on slow cgroups anyway.  In the long term,
  the best route seems to make the path kick off the usual writeback
  path rather than trying to write pages directly.

  Both patches updated to skip cgroup writeback related processing if
  the wbc is not associated with inode / wb.

* might_lock() on tree_lock dropped from
  0007-writeback-add-lockdep-annotation-to-inode_to_wb.patch due to
  spurious locking context warnings.  Unfortunately, there isn't a
  simple way to express _irqsave for might_lock().

The previous two patchsets [1][2] implemented cgroup writeback support
and backpressure propagation through dirty throttling mechanism;
however, the inode is assigned to the wb (bdi_writeback) matching the
first dirtied page and stays there until released.  This first-use
policy can easily lead to gross misbehaviors - a single stray dirty
page can cause gigatbytes to be written by the wrong cgroup.  Also,
while concurrently write sharing an inode is extremely rare and
unsupported, inodes jumping cgroups over time are more common.

This patchset implements foreign cgroup inode detection and wb
switching.  Each writeback run tracks the majority wb being written
using a simple but fairly robust algorithm and when an inode
persistently writes out more foreign cgroup pages than local ones, the
inode is transferred to the majority winner.

This patchset adds 8 bytes to inode making the total per-inode space
overhead of cgroup writeback support 16 bytes on 64bit systems.  The
computational overhead should be negligible.  If the writer changes
from one cgroup to another entirely, the mechanism can render the
correct switch verdict in several seconds of IO time in most cases and
it can converge on the correct answer in reasonable amount of time
even in more ambiguous cases.

This patchset contains the following 8 patches.

 0001-writeback-relocate-wb-_try-_get-wb_put-inode_-attach.patch
 0002-writeback-make-writeback_control-track-the-inode-bei.patch
 0003-writeback-implement-foreign-cgroup-inode-detection.patch
 0004-writeback-implement-locked_-inode_to_wb_and_lock_lis.patch
 0005-writeback-implement-unlocked_inode_to_wb-transaction.patch
 0006-writeback-use-unlocked_inode_to_wb-transaction-in-in.patch
 0007-writeback-add-lockdep-annotation-to-inode_to_wb.patch
 0008-writeback-implement-foreign-cgroup-inode-bdi_writeba.patch
 0009-writeback-disassociate-inodes-from-dying-bdi_writeba.patch

This patchset is on top of

  block/for-4.2/core b04a5636a665 ("block: replace trylock with mutex_lock in blkdev_reread_part()")
+ [1] [PATCHSET 1/3 v4 block/for-4.2/core] writeback: cgroup writeback support
+ [2] [PATCHSET 2/3 v3 block/for-4.2/core] writeback: cgroup writeback backpressure propagation

and available in the following git branch.

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git review-cgroup-writeback-switch-20150528

diffstat follows.  Thanks.

 fs/buffer.c                      |   26 -
 fs/fs-writeback.c                |  532 ++++++++++++++++++++++++++++++++++++++-
 fs/mpage.c                       |    3 
 include/linux/backing-dev-defs.h |   66 ++++
 include/linux/backing-dev.h      |  142 ++++------
 include/linux/fs.h               |   11 
 include/linux/mm.h               |    3 
 include/linux/writeback.h        |  130 +++++++++
 mm/backing-dev.c                 |   30 --
 mm/filemap.c                     |    5 
 mm/page-writeback.c              |   27 +
 11 files changed, 836 insertions(+), 139 deletions(-)

--
tejun

[L] http://lkml.kernel.org/g/1432334183-6324-1-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
[1] http://lkml.kernel.org/g/1432329245-5844-1-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
[2] http://lkml.kernel.org/g/1428350674-8303-1-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org

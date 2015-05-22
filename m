From: Tejun Heo <tj@kernel.org>
Subject: [PATCHSET 3/3 v3 block/for-4.2/core] writeback: implement foreign cgroup inode bdi_writeback switching
Date: Fri, 22 May 2015 18:36:14 -0400
Message-ID: <1432334183-6324-1-git-send-email-tj@kernel.org>
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id;
        bh=y5KKGC6nt9yD9qkwL/F06jlaZlOciB5xfurKUyCdfg4=;
        b=t3v7aqR1DSK50G4XB4t/kYhQZDV0eNq6R+y6z8j6AMu2umlnBpISej4oustCW9VNui
         InRfGxNBOurCyJ2mPuqHTRSTcYkLx6AB4FJB9gRnJ76Fc2OdySMfaVfcHX3pwSzahG5v
         boEjkBFnARbnMFUOdjfTHtia4UtaT02Qs+mhSCAd/IKCrqEnwaH8wLA8H/XVzPCd5zyq
         bEDNV2gkuScBo9VgfAnqqtASzkGyNrJ9chsI3qY/2L4zHmhS0dtYrQu21L8vlnjxEuX6
         aiztDCpb6om6lFe1BO232bnU5CDb4J9gi5tmmVaITDTR9GoVSnj1tEZOu9cZT9mLclwE
         5J3g==
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, jack@suse.cz, hch@infradead.org, hannes@cmpxchg.org, linux-fsdevel@vger.kernel.org, vgoyal@redhat.com, lizefan@huawei.com, cgroups@vger.kernel.org, linux-mm@kvack.org, mhocko@suse.cz, clm@fb.com, fengguang.wu@intel.com, david@fromorbit.com, gthelen@google.com, khlebnikov@yandex-team.ru

Hello,

The changes from the last take[L] are

* Rebased on top of block/for-4.2/core.

* 0004-truncate-swap-the-order-of-conditionals-in-cancel_di.patch
  became unnecessary due to recent changes to cancel_page_dirty().
  Dropped.

* unlocked_inode_to_wb_begin/end() usages were using the wrong locking
  order when used in combination with memcg stat transactions.  Orders
  reversed and might_lock() added to
  0007-writeback-add-lockdep-annotation-to-inode_to_wb.patch so that
  bugs like this can be caught reliably.

The previous two patchsets [2][3] implemented cgroup writeback support
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

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git review-cgroup-writeback-switch-20150522

diffstat follows.  Thanks.

 fs/buffer.c                      |   26 -
 fs/fs-writeback.c                |  523 ++++++++++++++++++++++++++++++++++++++-
 fs/mpage.c                       |    3 
 include/linux/backing-dev-defs.h |   66 ++++
 include/linux/backing-dev.h      |  144 +++++-----
 include/linux/fs.h               |   11 
 include/linux/mm.h               |    3 
 include/linux/writeback.h        |  123 +++++++++
 mm/backing-dev.c                 |   30 --
 mm/filemap.c                     |    5 
 mm/page-writeback.c              |   27 +-
 11 files changed, 822 insertions(+), 139 deletions(-)

--
tejun

[L] http://lkml.kernel.org/g/1428351508-8399-1-git-send-email-tj@kernel.org
[1] http://lkml.kernel.org/g/1432329245-5844-1-git-send-email-tj@kernel.org
[2] http://lkml.kernel.org/g/1428350674-8303-1-git-send-email-tj@kernel.org

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>

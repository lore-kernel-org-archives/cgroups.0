From: Tejun Heo <tj@kernel.org>
Subject: [PATCHSET 3/3 block/for-4.1/core] writeback: implement foreign cgroup inode bdi_writeback switching
Date: Mon, 23 Mar 2015 01:25:36 -0400
Message-ID: <1427088344-17542-1-git-send-email-tj@kernel.org>
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id;
        bh=Yv6gmJOB6iikJM08INgRY3z1eNJ/ax9Tdy62jG487mA=;
        b=HDVPURzQYAmWc5O4ZcFnvF3og0YPVy/AwAWvyNcCta7KOxJsAlnlqOKdkKw1yVDAQJ
         JgkljFykpvyb/21mud5OqpRi5fslrCz6VeblOuUHQr5opuN4xXE4VbvDkaVk7HiTUoHT
         cDGlswG814LbkHwCezCmOSTcsR1GL9TfT7AMWt3GYueoM91QjrSNzaSwwvzU5cmT8di0
         Or496kJBbl8bZrbe/odH0YFC7HfogLAbTOf+qEHmV5/aHqo+rYvJ+3qyZL3T3hwbb7FQ
         DgT+X0RczxDt6oVsaGoLNKe+WDGll50CxW1NkjvdJSnDI0qbrCMOpNh8JjvgOGXdAvAs
         bbDQ==
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, jack@suse.cz, hch@infradead.org, hannes@cmpxchg.org, linux-fsdevel@vger.kernel.org, vgoyal@redhat.com, lizefan@huawei.com, cgroups@vger.kernel.org, linux-mm@kvack.org, mhocko@suse.cz, clm@fb.com, fengguang.wu@intel.com, david@fromorbit.com, gthelen@google.com

Hello,

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
 0004-truncate-swap-the-order-of-conditionals-in-cancel_di.patch
 0005-writeback-implement-locked_-inode_to_wb_and_lock_lis.patch
 0006-writeback-implement-I_WB_SWITCH-and-bdi_writeback-st.patch
 0007-writeback-add-lockdep-annotation-to-inode_to_wb.patch
 0008-writeback-implement-foreign-cgroup-inode-bdi_writeba.patch

This patchset is on top of

  block/for-4.1/core bfd343aa1718 ("blk-mq: don't wait in blk_mq_queue_enter() if __GFP_WAIT isn't set")
+ [1] [PATCH] writeback: fix possible underflow in write bandwidth calculation
+ [2] [PATCHSET 1/3 v2 block/for-4.1/core] writeback: cgroup writeback support
+ [3] [PATCHSET 2/3 block/for-4.1/core] writeback: cgroup writeback backpressure propagation

and available in the following git branch.

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git review-cgroup-writeback-switch-20150322

diffstat follows.  Thanks.

 fs/buffer.c                      |   26 +-
 fs/fs-writeback.c                |  499 ++++++++++++++++++++++++++++++++++++++-
 fs/mpage.c                       |    3 
 include/linux/backing-dev-defs.h |   50 +++
 include/linux/backing-dev.h      |  136 ++++------
 include/linux/fs.h               |   11 
 include/linux/writeback.h        |  123 +++++++++
 mm/backing-dev.c                 |   30 --
 mm/filemap.c                     |    2 
 mm/page-writeback.c              |   16 +
 mm/truncate.c                    |   21 +
 11 files changed, 773 insertions(+), 144 deletions(-)

--
tejun

[L] http://lkml.kernel.org/g/1420579582-8516-1-git-send-email-tj@kernel.org
[1] http://lkml.kernel.org/g/20150323041848.GA8991@htj.duckdns.org
[2] http://lkml.kernel.org/g/1427086499-15657-1-git-send-email-tj@kernel.org
[3] http://lkml.kernel.org/g/1427087267-16592-1-git-send-email-tj@kernel.org

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>

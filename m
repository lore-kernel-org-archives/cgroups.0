From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 3/3] writeback, blkio: add documentation for cgroup writeback support
Date: Fri, 12 Jun 2015 16:57:34 -0500
Message-ID: <1434146254-26220-4-git-send-email-tj@kernel.org>
References: <1434146254-26220-1-git-send-email-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=E49RNiBUVbJPA8J2isuH8lRnSfUoTzOG5z3jOt1/CP8=;
        b=DohJObujhBm5OoAGdLlPATEliKc2vHIw/1kGbRcnfh7vVbl8juRt300Oh/Ah/fkl1Q
         7gbab/cMjgL4dWHIUCcMf25WY6AB+WLLw1F4Ep9nHdPFK63SBt/HT5pWTkUFY3d4v4N9
         SmmjpGgrrHfbF1IltLhvGys7LiBs1KDA8AQBFL/LsUJN45AmM/QSXx1pJIJbueL2igSn
         xKv85WfqSlnU3rALXQyfdgysh7+MxGjTzr1I0WB2DiNYvrM7tc7RMgVQ8NXqRQsym8Zi
         9pXRd6zktocMxl5Zn1miPJvN5nrZ71SgI7O9HGb5+N90K3kF+2HNoxvucgnxrpJ626Jj
         aq7g==
In-Reply-To: <1434146254-26220-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, lizefan@huawei.com, cgroups@vger.kernel.org, Tejun Heo <tj@kernel.org>, Vivek Goyal <vgoyal@redhat.com>

Update Documentation/cgroups/blkio-controller.txt to reflect the
recently added cgroup writeback support.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Li Zefan <lizefan@huawei.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: cgroups@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org
---
 Documentation/cgroups/blkio-controller.txt | 83 ++++++++++++++++++++++++++++--
 1 file changed, 78 insertions(+), 5 deletions(-)

diff --git a/Documentation/cgroups/blkio-controller.txt b/Documentation/cgroups/blkio-controller.txt
index cd556b9..68b6a6a 100644
--- a/Documentation/cgroups/blkio-controller.txt
+++ b/Documentation/cgroups/blkio-controller.txt
@@ -387,8 +387,81 @@ groups and put applications in that group which are not driving enough
 IO to keep disk busy. In that case set group_idle=0, and CFQ will not idle
 on individual groups and throughput should improve.
 
-What works
-==========
-- Currently only sync IO queues are support. All the buffered writes are
-  still system wide and not per group. Hence we will not see service
-  differentiation between buffered writes between groups.
+Writeback
+=========
+
+Page cache is dirtied through buffered writes and shared mmaps and
+written asynchronously to the backing filesystem by the writeback
+mechanism.  Writeback sits between the memory and IO domains and
+regulates the proportion of dirty memory by balancing dirtying and
+write IOs.
+
+On traditional cgroup hierarchies, relationships between different
+controllers cannot be established making it impossible for writeback
+to operate accounting for cgroup resource restrictions and all
+writeback IOs are attributed to the root cgroup.
+
+If both the blkio and memory controllers are used on the v2 hierarchy
+and the filesystem supports cgroup writeback, writeback operations
+correctly follow the resource restrictions imposed by both memory and
+blkio controllers.
+
+Writeback examines both system-wide and per-cgroup dirty memory status
+and enforces the more restrictive of the two.  Also, writeback control
+parameters which are absolute values - vm.dirty_bytes and
+vm.dirty_background_bytes - are distributed across cgroups according
+to their current writeback bandwidth.
+
+There's a peculiarity stemming from the discrepancy in ownership
+granularity between memory controller and writeback.  While memory
+controller tracks ownership per page, writeback operates on inode
+basis.  cgroup writeback bridges the gap by tracking ownership by
+inode but migrating ownership if too many foreign pages, pages which
+don't match the current inode ownership, have been encountered while
+writing back the inode.
+
+This is a conscious design choice as writeback operations are
+inherently tied to inodes making strictly following page ownership
+complicated and inefficient.  The only use case which suffers from
+this compromise is multiple cgroups concurrently dirtying disjoint
+regions of the same inode, which is an unlikely use case and decided
+to be unsupported.  Note that as memory controller assigns page
+ownership on the first use and doesn't update it until the page is
+released, even if cgroup writeback strictly follows page ownership,
+multiple cgroups dirtying overlapping areas wouldn't work as expected.
+In general, write-sharing an inode across multiple cgroups is not well
+supported.
+
+Filesystem support for cgroup writeback
+---------------------------------------
+
+A filesystem can make writeback IOs cgroup-aware by updating
+address_space_operations->writepage[s]() to annotate bio's using the
+following two functions.
+
+* wbc_init_bio(@wbc, @bio)
+
+  Should be called for each bio carrying writeback data and associates
+  the bio with the inode's owner cgroup.  Can be called anytime
+  between bio allocation and submission.
+
+* wbc_account_io(@wbc, @page, @bytes)
+
+  Should be called for each data segment being written out.  While
+  this function doesn't care exactly when it's called during the
+  writeback session, it's the easiest and most natural to call it as
+  data segments are added to a bio.
+
+With writeback bio's annotated, cgroup support can be enabled per
+super_block by setting MS_CGROUPWB in ->s_flags.  This allows for
+selective disabling of cgroup writeback support which is helpful when
+certain filesystem features, e.g. journaled data mode, are
+incompatible.
+
+wbc_init_bio() binds the specified bio to its cgroup.  Depending on
+the configuration, the bio may be executed at a lower priority and if
+the writeback session is holding shared resources, e.g. a journal
+entry, may lead to priority inversion.  There is no one easy solution
+for the problem.  Filesystems can try to work around specific problem
+cases by skipping wbc_init_bio() or using bio_associate_blkcg()
+directly.
-- 
2.4.2

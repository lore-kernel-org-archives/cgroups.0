From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 4/9] writeback: implement [locked_]inode_to_wb_and_lock_list()
Date: Fri, 22 May 2015 18:36:18 -0400
Message-ID: <1432334183-6324-5-git-send-email-tj@kernel.org>
References: <1432334183-6324-1-git-send-email-tj@kernel.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=mTagYuIpMsfmd1369BsVEi4yBi4E44zX2jvRm5939BA=;
        b=g25/S5FE6UUJKLh56zzbWeuFZaMhp0cdPJ6NRP26WhMJZzylyM1N2xqqkJeoyDPb/x
         7tgN01iWmC3/m86zozzWsLMNZWTImnnExrnfONNqz7htumXRAoq+mF9nqMBNUYBPzSC/
         FqTMS27RlXBSY2xN7PNcK0Kl+eJMcL8rpAwu8t/CUR9tzapSMEwpsT3r0ufp+BcTPBf/
         I77kFJPEPLeNSxIdEfrckWZhsZdiTJxLSowE8K6F9TfGq7vtmJ5RXqvB440TFyvZph+A
         L5m+2Mcq4mqR5Mau8Ag9lL7NbfdiNnzpo1/AMjorrNijBN+Id5RrwinDJ0NrV+jfiJn6
         V45A==
In-Reply-To: <1432334183-6324-1-git-send-email-tj@kernel.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, jack@suse.cz, hch@infradead.org, hannes@cmpxchg.org, linux-fsdevel@vger.kernel.org, vgoyal@redhat.com, lizefan@huawei.com, cgroups@vger.kernel.org, linux-mm@kvack.org, mhocko@suse.cz, clm@fb.com, fengguang.wu@intel.com, david@fromorbit.com, gthelen@google.com, khlebnikov@yandex-team.ru, Tejun Heo <tj@kernel.org>

cgroup writeback currently assumes that inode to wb association
doesn't change; however, with the planned foreign inode wb switching
mechanism, the association will change dynamically.

When an inode needs to be put on one of the IO lists of its wb, the
current code simply calls inode_to_wb() and locks the returned wb;
however, with the planned wb switching, the association may change
before locking the wb and may even get released.

This patch implements [locked_]inode_to_wb_and_lock_list() which pins
the associated wb while holding i_lock, releases it, acquires
wb->list_lock and verifies that the association hasn't changed
inbetween.  As the association will be protected by both locks among
other things, this guarantees that the wb is the inode's associated wb
until the list_lock is released.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Jan Kara <jack@suse.cz>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Cc: Greg Thelen <gthelen@google.com>
---
 fs/fs-writeback.c | 80 +++++++++++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 75 insertions(+), 5 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 8fb5edd..f5565db 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -259,6 +259,56 @@ void __inode_attach_wb(struct inode *inode, struct page *page)
 }
 
 /**
+ * locked_inode_to_wb_and_lock_list - determine a locked inode's wb and lock it
+ * @inode: inode of interest with i_lock held
+ *
+ * Returns @inode's wb with its list_lock held.  @inode->i_lock must be
+ * held on entry and is released on return.  The returned wb is guaranteed
+ * to stay @inode's associated wb until its list_lock is released.
+ */
+static struct bdi_writeback *
+locked_inode_to_wb_and_lock_list(struct inode *inode)
+	__releases(&inode->i_lock)
+	__acquires(&wb->list_lock)
+{
+	while (true) {
+		struct bdi_writeback *wb = inode_to_wb(inode);
+
+		/*
+		 * inode_to_wb() association is protected by both
+		 * @inode->i_lock and @wb->list_lock but list_lock nests
+		 * outside i_lock.  Drop i_lock and verify that the
+		 * association hasn't changed after acquiring list_lock.
+		 */
+		wb_get(wb);
+		spin_unlock(&inode->i_lock);
+		spin_lock(&wb->list_lock);
+		wb_put(wb);		/* not gonna deref it anymore */
+
+		if (likely(wb == inode_to_wb(inode)))
+			return wb;	/* @inode already has ref */
+
+		spin_unlock(&wb->list_lock);
+		cpu_relax();
+		spin_lock(&inode->i_lock);
+	}
+}
+
+/**
+ * inode_to_wb_and_lock_list - determine an inode's wb and lock it
+ * @inode: inode of interest
+ *
+ * Same as locked_inode_to_wb_and_lock_list() but @inode->i_lock isn't held
+ * on entry.
+ */
+static struct bdi_writeback *inode_to_wb_and_lock_list(struct inode *inode)
+	__acquires(&wb->list_lock)
+{
+	spin_lock(&inode->i_lock);
+	return locked_inode_to_wb_and_lock_list(inode);
+}
+
+/**
  * wbc_attach_and_unlock_inode - associate wbc with target inode and unlock it
  * @wbc: writeback_control of interest
  * @inode: target inode
@@ -594,6 +644,27 @@ static void bdi_split_work_to_wbs(struct backing_dev_info *bdi,
 
 #else	/* CONFIG_CGROUP_WRITEBACK */
 
+static struct bdi_writeback *
+locked_inode_to_wb_and_lock_list(struct inode *inode)
+	__releases(&inode->i_lock)
+	__acquires(&wb->list_lock)
+{
+	struct bdi_writeback *wb = inode_to_wb(inode);
+
+	spin_unlock(&inode->i_lock);
+	spin_lock(&wb->list_lock);
+	return wb;
+}
+
+static struct bdi_writeback *inode_to_wb_and_lock_list(struct inode *inode)
+	__acquires(&wb->list_lock)
+{
+	struct bdi_writeback *wb = inode_to_wb(inode);
+
+	spin_lock(&wb->list_lock);
+	return wb;
+}
+
 static long wb_split_bdi_pages(struct bdi_writeback *wb, long nr_pages)
 {
 	return nr_pages;
@@ -669,9 +740,9 @@ void wb_start_background_writeback(struct bdi_writeback *wb)
  */
 void inode_wb_list_del(struct inode *inode)
 {
-	struct bdi_writeback *wb = inode_to_wb(inode);
+	struct bdi_writeback *wb;
 
-	spin_lock(&wb->list_lock);
+	wb = inode_to_wb_and_lock_list(inode);
 	inode_wb_list_del_locked(inode, wb);
 	spin_unlock(&wb->list_lock);
 }
@@ -1775,12 +1846,11 @@ void __mark_inode_dirty(struct inode *inode, int flags)
 		 * reposition it (that would break b_dirty time-ordering).
 		 */
 		if (!was_dirty) {
-			struct bdi_writeback *wb = inode_to_wb(inode);
+			struct bdi_writeback *wb;
 			struct list_head *dirty_list;
 			bool wakeup_bdi = false;
 
-			spin_unlock(&inode->i_lock);
-			spin_lock(&wb->list_lock);
+			wb = locked_inode_to_wb_and_lock_list(inode);
 
 			WARN(bdi_cap_writeback_dirty(wb->bdi) &&
 			     !test_bit(WB_registered, &wb->state),
-- 
2.4.0


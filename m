From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH block/for-linus] writeback: flush inode cgroup wb switches
 instead of pinning super_block
Date: Mon, 29 Feb 2016 15:47:24 -0500
Message-ID: <20160229204724.GV3965@htj.duckdns.org>
References: <CAAeU0aNCq7LGODvVGRU-oU_o-6enii5ey0p1c26D1ZzYwkDc5A@mail.gmail.com>
 <20160215210047.GN3965@htj.duckdns.org>
 <CAAeU0aNAd1Ra6LXmWwq8row4MD_BpVHiSXOwHx07m86UWREvHw@mail.gmail.com>
 <20160216182457.GO3741@mtj.duckdns.org>
 <20160217205721.GE14140@quack.suse.cz>
 <20160217210744.GA6479@mtj.duckdns.org>
 <20160217223009.GN14140@quack.suse.cz>
 <CAAeU0aOvSwPbLPU0=20D1RExNj8VsbB38hUnyso2L8xNSQC0XA@mail.gmail.com>
 <20160217230231.GC6479@mtj.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=ugWsLB3EWZZc9I4qXzBdpMAX15Qbbog/Wg11o1cApnE=;
        b=lDXQ5uRArCmrbF4rUAYf2m3My6A2haWD6PcrTdM7Be1vSr1RpCoUjejuiX1EsYGUG5
         jY4k05QzWw53omX94pe3dBDzB1ttEpUm3QkjCy9YXqONCk0iPM0M/wrPzwuskovXcSHv
         TiKT0U0ATHwokv9KxEfc0xeX2VGU13FAsxC60pohjr5CnUvXUmlwAtPdm4AmlUPHULuo
         YO1rCjjGeAPJ+8B+vFym+H07FWnDIe4n9pwdCXtZE4YasHaubmREYjx1NknbXIU19o8L
         qDg8ZI8v2r5CHBeK3hnuCBn9Nezau++x7FXJTsOm5glh6B476LfDYMj8HkaibL3+h21G
         jU5w==
Content-Disposition: inline
In-Reply-To: <20160217230231.GC6479-qYNAdHglDFBN0TnZuCh8vA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tahsin Erdogan <tahsin-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, Nauman Rafique <nauman-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jan Kara <jack-IBi9RG/b67k@public.gmane.org>, Al Viro <viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>

If cgroup writeback is in use, inodes can be scheduled for
asynchronous wb switching.  Before 5ff8eaac1636 ("writeback: keep
superblock pinned during cgroup writeback association switches"), this
could race with umount leading to super_block being destroyed while
inodes are pinned for wb switching.  5ff8eaac1636 fixed it by bumping
s_active while wb switches are in flight; however, this allowed
in-flight wb switches to make umounts asynchronous when the userland
expected synchronosity - e.g. fsck immediately following umount may
fail because the device is still busy.

This patch removes the problematic super_block pinning and instead
makes generic_shutdown_super() flush in-flight wb switches.  wb
switches are now executed on a dedicated isw_wq so that they can be
flushed and isw_nr_in_flight keeps track of the number of in-flight wb
switches so that flushing can be avoided in most cases.

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Reported-by: Tahsin Erdogan <tahsin-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Cc: Al Viro <viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Link: http://lkml.kernel.org/g/CAAeU0aNCq7LGODvVGRU-oU_o-6enii5ey0p1c26D1ZzYwkDc5A-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org
Fixes: 5ff8eaac1636 ("writeback: keep superblock pinned during cgroup writeback association switches")
Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org #v4.5
---
Hello,

Tahsin, can you please verify that this removes the asynchronous
behavior while still avoiding the original issue?

Thanks.

 fs/fs-writeback.c         |   51 +++++++++++++++++++++++++++++++++++-----------
 fs/super.c                |    1 
 include/linux/writeback.h |    5 ++++
 3 files changed, 45 insertions(+), 12 deletions(-)

--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -223,6 +223,9 @@ static void wb_wait_for_completion(struc
 #define WB_FRN_HIST_MAX_SLOTS	(WB_FRN_HIST_THR_SLOTS / 2 + 1)
 					/* one round can affect upto 5 slots */
 
+static atomic_t isw_nr_in_flight = ATOMIC_INIT(0);
+static struct workqueue_struct *isw_wq;
+
 void __inode_attach_wb(struct inode *inode, struct page *page)
 {
 	struct backing_dev_info *bdi = inode_to_bdi(inode);
@@ -317,7 +320,6 @@ static void inode_switch_wbs_work_fn(str
 	struct inode_switch_wbs_context *isw =
 		container_of(work, struct inode_switch_wbs_context, work);
 	struct inode *inode = isw->inode;
-	struct super_block *sb = inode->i_sb;
 	struct address_space *mapping = inode->i_mapping;
 	struct bdi_writeback *old_wb = inode->i_wb;
 	struct bdi_writeback *new_wb = isw->new_wb;
@@ -424,8 +426,9 @@ skip_switch:
 	wb_put(new_wb);
 
 	iput(inode);
-	deactivate_super(sb);
 	kfree(isw);
+
+	atomic_dec(&isw_nr_in_flight);
 }
 
 static void inode_switch_wbs_rcu_fn(struct rcu_head *rcu_head)
@@ -435,7 +438,7 @@ static void inode_switch_wbs_rcu_fn(stru
 
 	/* needs to grab bh-unsafe locks, bounce to work item */
 	INIT_WORK(&isw->work, inode_switch_wbs_work_fn);
-	schedule_work(&isw->work);
+	queue_work(isw_wq, &isw->work);
 }
 
 /**
@@ -471,20 +474,19 @@ static void inode_switch_wbs(struct inod
 
 	/* while holding I_WB_SWITCH, no one else can update the association */
 	spin_lock(&inode->i_lock);
-
 	if (inode->i_state & (I_WB_SWITCH | I_FREEING) ||
-	    inode_to_wb(inode) == isw->new_wb)
-		goto out_unlock;
-
-	if (!atomic_inc_not_zero(&inode->i_sb->s_active))
-		goto out_unlock;
-
+	    inode_to_wb(inode) == isw->new_wb) {
+		spin_unlock(&inode->i_lock);
+		goto out_free;
+	}
 	inode->i_state |= I_WB_SWITCH;
 	spin_unlock(&inode->i_lock);
 
 	ihold(inode);
 	isw->inode = inode;
 
+	atomic_inc(&isw_nr_in_flight);
+
 	/*
 	 * In addition to synchronizing among switchers, I_WB_SWITCH tells
 	 * the RCU protected stat update paths to grab the mapping's
@@ -494,8 +496,6 @@ static void inode_switch_wbs(struct inod
 	call_rcu(&isw->rcu_head, inode_switch_wbs_rcu_fn);
 	return;
 
-out_unlock:
-	spin_unlock(&inode->i_lock);
 out_free:
 	if (isw->new_wb)
 		wb_put(isw->new_wb);
@@ -847,6 +847,33 @@ restart:
 		wb_put(last_wb);
 }
 
+/**
+ * cgroup_writeback_umount - flush inode wb switches for umount
+ *
+ * This function is called when a super_block is about to be destroyed and
+ * flushes in-flight inode wb switches.  An inode wb switch goes through
+ * RCU and then workqueue, so the two need to be flushed in order to ensure
+ * that all previously scheduled switches are finished.  As wb switches are
+ * rare occurrences and synchronize_rcu() can take a while, perform
+ * flushing iff wb switches are in flight.
+ */
+void cgroup_writeback_umount(void)
+{
+	if (atomic_read(&isw_nr_in_flight)) {
+		synchronize_rcu();
+		flush_workqueue(isw_wq);
+	}
+}
+
+static int __init cgroup_writeback_init(void)
+{
+	isw_wq = alloc_workqueue("inode_switch_wbs", 0, 0);
+	if (!isw_wq)
+		return -ENOMEM;
+	return 0;
+}
+fs_initcall(cgroup_writeback_init);
+
 #else	/* CONFIG_CGROUP_WRITEBACK */
 
 static struct bdi_writeback *
--- a/fs/super.c
+++ b/fs/super.c
@@ -414,6 +414,7 @@ void generic_shutdown_super(struct super
 		sync_filesystem(sb);
 		sb->s_flags &= ~MS_ACTIVE;
 
+		cgroup_writeback_umount();
 		fsnotify_unmount_inodes(sb);
 
 		evict_inodes(sb);
--- a/include/linux/writeback.h
+++ b/include/linux/writeback.h
@@ -198,6 +198,7 @@ void wbc_attach_and_unlock_inode(struct
 void wbc_detach_inode(struct writeback_control *wbc);
 void wbc_account_io(struct writeback_control *wbc, struct page *page,
 		    size_t bytes);
+void cgroup_writeback_umount(void);
 
 /**
  * inode_attach_wb - associate an inode with its wb
@@ -301,6 +302,10 @@ static inline void wbc_account_io(struct
 {
 }
 
+static inline void cgroup_writeback_umount(void)
+{
+}
+
 #endif	/* CONFIG_CGROUP_WRITEBACK */
 
 /*

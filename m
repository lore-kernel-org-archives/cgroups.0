From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 4/5] writeback, memcg: Implement cgroup_writeback_by_id()
Date: Thu, 15 Aug 2019 12:59:02 -0700
Message-ID: <20190815195902.GE2263813@devbig004.ftw2.facebook.com>
References: <20190815195619.GA2263813@devbig004.ftw2.facebook.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=LTjjxYDcINav7DiTg3r+K5uyvclxft6ApAzOA1thajw=;
        b=ReQZ+Ab0hATpZtDXOA2ejtpPxUouA+/1xRBT9pTb1ePOZTo2VSyRKjTL2j3RzOyJ7S
         mlcrNaILH3zXXtOaaBVm+e5yQG01QhwfI90xWoTHI3jXtQ8RPEbodPybOVmvjN9wSaPt
         EaJaVv1bmqhFDi+MaB4fvT5nUovo3hGXJ52wdQU56ZxArTR0gW5bs5CDYoWb8QHWBjEq
         +xWRzvOeKJ1HPiDh+Zawly8QwcsWoCzCpWbL/+Ca7PTd1evz6glff1DdWU4lNTP+/Gm6
         utFTGkkDos6KzH8N0RhsbOYj9FshB3Uth+gddwFR0l77/gvDZnCzRj2R/DXN380JqxnN
         7XWg==
Content-Disposition: inline
In-Reply-To: <20190815195619.GA2263813@devbig004.ftw2.facebook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: axboe@kernel.dk, jack@suse.cz, hannes@cmpxchg.org, mhocko@kernel.org, vdavydov.dev@gmail.com
Cc: cgroups@vger.kernel.org, linux-mm@kvack.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com, guro@fb.com, akpm@linux-foundation.org

Implement cgroup_writeback_by_id() which initiates cgroup writeback
from bdi and memcg IDs.  This will be used by memcg foreign inode
flushing.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 fs/fs-writeback.c         |   67 ++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/writeback.h |    2 +
 2 files changed, 69 insertions(+)

--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -892,6 +892,73 @@ restart:
 }
 
 /**
+ * cgroup_writeback_by_id - initiate cgroup writeback from bdi and memcg IDs
+ * @bdi_id: target bdi id
+ * @memcg_id: target memcg css id
+ * @nr_pages: number of pages to write
+ * @reason: reason why some writeback work initiated
+ * @done: target wb_completion
+ *
+ * Initiate flush of the bdi_writeback identified by @bdi_id and @memcg_id
+ * with the specified parameters.
+ */
+int cgroup_writeback_by_id(u64 bdi_id, int memcg_id, unsigned long nr,
+			   enum wb_reason reason, struct wb_completion *done)
+{
+	struct backing_dev_info *bdi;
+	struct cgroup_subsys_state *memcg_css;
+	struct bdi_writeback *wb;
+	struct wb_writeback_work *work;
+	int ret;
+
+	/* lookup bdi and memcg */
+	bdi = bdi_get_by_id(bdi_id);
+	if (!bdi)
+		return -ENOENT;
+
+	rcu_read_lock();
+	memcg_css = css_from_id(memcg_id, &memory_cgrp_subsys);
+	if (memcg_css && !css_tryget(memcg_css))
+		memcg_css = NULL;
+	rcu_read_unlock();
+	if (!memcg_css) {
+		ret = -ENOENT;
+		goto out_bdi_put;
+	}
+
+	/*
+	 * And find the associated wb.  If the wb isn't there already
+	 * there's nothing to flush, don't create one.
+	 */
+	wb = wb_get_lookup(bdi, memcg_css);
+	if (!wb) {
+		ret = -ENOENT;
+		goto out_css_put;
+	}
+
+	/* issue the writeback work */
+	work = kzalloc(sizeof(*work), GFP_NOWAIT | __GFP_NOWARN);
+	if (work) {
+		work->nr_pages = nr;
+		work->sync_mode = WB_SYNC_NONE;
+		work->reason = reason;
+		work->done = done;
+		work->auto_free = 1;
+		wb_queue_work(wb, work);
+		ret = 0;
+	} else {
+		ret = -ENOMEM;
+	}
+
+	wb_put(wb);
+out_css_put:
+	css_put(memcg_css);
+out_bdi_put:
+	bdi_put(bdi);
+	return ret;
+}
+
+/**
  * cgroup_writeback_umount - flush inode wb switches for umount
  *
  * This function is called when a super_block is about to be destroyed and
--- a/include/linux/writeback.h
+++ b/include/linux/writeback.h
@@ -217,6 +217,8 @@ void wbc_attach_and_unlock_inode(struct
 void wbc_detach_inode(struct writeback_control *wbc);
 void wbc_account_cgroup_owner(struct writeback_control *wbc, struct page *page,
 			      size_t bytes);
+int cgroup_writeback_by_id(u64 bdi_id, int memcg_id, unsigned long nr_pages,
+			   enum wb_reason reason, struct wb_completion *done);
 void cgroup_writeback_umount(void);
 
 /**

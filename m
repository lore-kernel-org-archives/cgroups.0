From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 4/5] writeback, memcg: Implement cgroup_writeback_by_id()
Date: Mon, 26 Aug 2019 09:06:55 -0700
Message-ID: <20190826160656.870307-5-tj@kernel.org>
References: <20190826160656.870307-1-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=E6MTfC4z3G0quoIF3DBw3b87rQV2WqMBkOF2p8Csnt4=;
        b=f7PWgdQaNS08y3O69h2TR6wz4T9l5sgzCskuEu75Rl4PPIoqtP1eKAL8MIWvGgBGtD
         b9nHdxjt/X7Yhwz4de8X2WBOiT4ZepZsWVsoCYdmY2fMXZfNCQehm+t0G3Ku1Ww+4huv
         PQ6z8migaaxzUVn9akM/4OyyWFicteYTGNjr2o9iivqYNfvwcZBbtk9hiqePLSyjKXxt
         0RoWxaEApyGfC0uS3sh3e33KjgJQNMv299LqP+PaH6YtTg+QfOuubHX1AmqbNWUaATVV
         gLgNdO4IRMKOeIBRyMaFmxRomthURawpH6qAf1+ZHXC5o5v4K5s/VBLoljkuFuy5JFa0
         OhGA==
In-Reply-To: <20190826160656.870307-1-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: axboe@kernel.dk, jack@suse.cz, hannes@cmpxchg.org, mhocko@kernel.org, vdavydov.dev@gmail.com
Cc: cgroups@vger.kernel.org, linux-mm@kvack.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com, guro@fb.com, akpm@linux-foundation.org, Tejun Heo <tj@kernel.org>

Implement cgroup_writeback_by_id() which initiates cgroup writeback
from bdi and memcg IDs.  This will be used by memcg foreign inode
flushing.

v2: Use wb_get_lookup() instead of wb_get_create() to avoid creating
    spurious wbs.

v3: Interpret 0 @nr as 1.25 * nr_dirty to implement best-effort
    flushing while avoding possible livelocks.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reviewed-by: Jan Kara <jack@suse.cz>
---
 fs/fs-writeback.c         | 83 +++++++++++++++++++++++++++++++++++++++
 include/linux/writeback.h |  2 +
 2 files changed, 85 insertions(+)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 9442f1fd6460..658dc16c9e6d 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -891,6 +891,89 @@ static void bdi_split_work_to_wbs(struct backing_dev_info *bdi,
 		wb_put(last_wb);
 }
 
+/**
+ * cgroup_writeback_by_id - initiate cgroup writeback from bdi and memcg IDs
+ * @bdi_id: target bdi id
+ * @memcg_id: target memcg css id
+ * @nr_pages: number of pages to write, 0 for best-effort dirty flushing
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
+	/*
+	 * If @nr is zero, the caller is attempting to write out most of
+	 * the currently dirty pages.  Let's take the current dirty page
+	 * count and inflate it by 25% which should be large enough to
+	 * flush out most dirty pages while avoiding getting livelocked by
+	 * concurrent dirtiers.
+	 */
+	if (!nr) {
+		unsigned long filepages, headroom, dirty, writeback;
+
+		mem_cgroup_wb_stats(wb, &filepages, &headroom, &dirty,
+				      &writeback);
+		nr = dirty * 10 / 8;
+	}
+
+	/* issue the writeback work */
+	work = kzalloc(sizeof(*work), GFP_NOWAIT | __GFP_NOWARN);
+	if (work) {
+		work->nr_pages = nr;
+		work->sync_mode = WB_SYNC_NONE;
+		work->range_cyclic = 1;
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
 /**
  * cgroup_writeback_umount - flush inode wb switches for umount
  *
diff --git a/include/linux/writeback.h b/include/linux/writeback.h
index 8945aac31392..a19d845dd7eb 100644
--- a/include/linux/writeback.h
+++ b/include/linux/writeback.h
@@ -217,6 +217,8 @@ void wbc_attach_and_unlock_inode(struct writeback_control *wbc,
 void wbc_detach_inode(struct writeback_control *wbc);
 void wbc_account_cgroup_owner(struct writeback_control *wbc, struct page *page,
 			      size_t bytes);
+int cgroup_writeback_by_id(u64 bdi_id, int memcg_id, unsigned long nr_pages,
+			   enum wb_reason reason, struct wb_completion *done);
 void cgroup_writeback_umount(void);
 
 /**
-- 
2.17.1


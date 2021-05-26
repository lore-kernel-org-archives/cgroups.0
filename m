From: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Subject: [PATCH v5 2/2] writeback, cgroup: release dying cgwbs by switching attached inodes
Date: Wed, 26 May 2021 15:25:57 -0700
Message-ID: <20210526222557.3118114-3-guro@fb.com>
References: <20210526222557.3118114-1-guro@fb.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=upg3t5shzXRGgTa68wVqIPfFpLcD5pG4JjjszPkvr3s=;
 b=pXmMxe1EcrBE6Auo/Et4S0yZjyZTd8RcDj6U9hkGzzsAn71VE/KiEsvXtVmVZLAzQNi+
 WCldWrLZAgkoHU/D+Jwf/tuXmbD1fbxqXGqCMrxjh7bhunQ3XE04SrRgW8eenkIdzB91
 awrqNZTU8gOmelDl+h3a1vdu9ejJIyDZ0NU= 
In-Reply-To: <20210526222557.3118114-1-guro-b10kYP2dOMg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Dennis Zhou <dennis-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Dave Chinner <dchinner-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>

Asynchronously try to release dying cgwbs by switching clean attached
inodes to the bdi's wb. It helps to get rid of per-cgroup writeback
structures themselves and of pinned memory and block cgroups, which
are way larger structures (mostly due to large per-cpu statistics
data). It helps to prevent memory waste and different scalability
problems caused by large piles of dying cgroups.

A cgwb cleanup operation can fail due to different reasons (e.g. the
cgwb has in-glight/pending io, an attached inode is locked or isn't
clean, etc). In this case the next scheduled cleanup will make a new
attempt. An attempt is made each time a new cgwb is offlined (in other
words a memcg and/or a blkcg is deleted by a user). In the future an
additional attempt scheduled by a timer can be implemented.

Signed-off-by: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
---
 fs/fs-writeback.c                | 35 ++++++++++++++++++
 include/linux/backing-dev-defs.h |  1 +
 include/linux/writeback.h        |  1 +
 mm/backing-dev.c                 | 61 ++++++++++++++++++++++++++++++--
 4 files changed, 96 insertions(+), 2 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 631ef6366293..8fbcd50844f0 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -577,6 +577,41 @@ static void inode_switch_wbs(struct inode *inode, in=
t new_wb_id)
 	kfree(isw);
 }
=20
+/**
+ * cleanup_offline_wb - detach associated clean inodes
+ * @wb: target wb
+ *
+ * Switch the inode->i_wb pointer of the attached inodes to the bdi's wb=
 and
+ * drop the corresponding per-cgroup wb's reference. Skip inodes which a=
re
+ * dirty, freeing, in the active writeback process or are in any way bus=
y.
+ */
+void cleanup_offline_wb(struct bdi_writeback *wb)
+{
+	struct inode *inode, *tmp;
+
+	spin_lock(&wb->list_lock);
+restart:
+	list_for_each_entry_safe(inode, tmp, &wb->b_attached, i_io_list) {
+		if (!spin_trylock(&inode->i_lock))
+			continue;
+		xa_lock_irq(&inode->i_mapping->i_pages);
+		if ((inode->i_state & I_REFERENCED) !=3D I_REFERENCED) {
+			struct bdi_writeback *bdi_wb =3D &inode_to_bdi(inode)->wb;
+
+			WARN_ON_ONCE(inode->i_wb !=3D wb);
+
+			inode->i_wb =3D bdi_wb;
+			list_del_init(&inode->i_io_list);
+			wb_put(wb);
+		}
+		xa_unlock_irq(&inode->i_mapping->i_pages);
+		spin_unlock(&inode->i_lock);
+		if (cond_resched_lock(&wb->list_lock))
+			goto restart;
+	}
+	spin_unlock(&wb->list_lock);
+}
+
 /**
  * wbc_attach_and_unlock_inode - associate wbc with target inode and unl=
ock it
  * @wbc: writeback_control of interest
diff --git a/include/linux/backing-dev-defs.h b/include/linux/backing-dev=
-defs.h
index e5dc238ebe4f..07d6b6d6dbdf 100644
--- a/include/linux/backing-dev-defs.h
+++ b/include/linux/backing-dev-defs.h
@@ -155,6 +155,7 @@ struct bdi_writeback {
 	struct list_head memcg_node;	/* anchored at memcg->cgwb_list */
 	struct list_head blkcg_node;	/* anchored at blkcg->cgwb_list */
 	struct list_head b_attached;	/* attached inodes, protected by list_lock=
 */
+	struct list_head offline_node;	/* anchored at offline_cgwbs */
=20
 	union {
 		struct work_struct release_work;
diff --git a/include/linux/writeback.h b/include/linux/writeback.h
index 572a13c40c90..922f15fe6ad4 100644
--- a/include/linux/writeback.h
+++ b/include/linux/writeback.h
@@ -222,6 +222,7 @@ void wbc_account_cgroup_owner(struct writeback_contro=
l *wbc, struct page *page,
 int cgroup_writeback_by_id(u64 bdi_id, int memcg_id, unsigned long nr_pa=
ges,
 			   enum wb_reason reason, struct wb_completion *done);
 void cgroup_writeback_umount(void);
+void cleanup_offline_wb(struct bdi_writeback *wb);
=20
 /**
  * inode_attach_wb - associate an inode with its wb
diff --git a/mm/backing-dev.c b/mm/backing-dev.c
index 54c5dc4b8c24..92a00bcaa504 100644
--- a/mm/backing-dev.c
+++ b/mm/backing-dev.c
@@ -371,12 +371,16 @@ static void wb_exit(struct bdi_writeback *wb)
 #include <linux/memcontrol.h>
=20
 /*
- * cgwb_lock protects bdi->cgwb_tree, blkcg->cgwb_list, and memcg->cgwb_=
list.
- * bdi->cgwb_tree is also RCU protected.
+ * cgwb_lock protects bdi->cgwb_tree, blkcg->cgwb_list, offline_cgwbs an=
d
+ * memcg->cgwb_list.  bdi->cgwb_tree is also RCU protected.
  */
 static DEFINE_SPINLOCK(cgwb_lock);
 static struct workqueue_struct *cgwb_release_wq;
=20
+static LIST_HEAD(offline_cgwbs);
+static void cleanup_offline_cgwbs_workfn(struct work_struct *work);
+static DECLARE_WORK(cleanup_offline_cgwbs_work, cleanup_offline_cgwbs_wo=
rkfn);
+
 static void cgwb_release_workfn(struct work_struct *work)
 {
 	struct bdi_writeback *wb =3D container_of(work, struct bdi_writeback,
@@ -395,6 +399,7 @@ static void cgwb_release_workfn(struct work_struct *w=
ork)
=20
 	fprop_local_destroy_percpu(&wb->memcg_completions);
 	percpu_ref_exit(&wb->refcnt);
+	WARN_ON(!list_empty(&wb->offline_node));
 	wb_exit(wb);
 	WARN_ON_ONCE(!list_empty(&wb->b_attached));
 	kfree_rcu(wb, rcu);
@@ -414,6 +419,10 @@ static void cgwb_kill(struct bdi_writeback *wb)
 	WARN_ON(!radix_tree_delete(&wb->bdi->cgwb_tree, wb->memcg_css->id));
 	list_del(&wb->memcg_node);
 	list_del(&wb->blkcg_node);
+	if (!list_empty(&wb->b_attached))
+		list_add(&wb->offline_node, &offline_cgwbs);
+	else
+		INIT_LIST_HEAD(&wb->offline_node);
 	percpu_ref_kill(&wb->refcnt);
 }
=20
@@ -635,6 +644,50 @@ static void cgwb_bdi_unregister(struct backing_dev_i=
nfo *bdi)
 	mutex_unlock(&bdi->cgwb_release_mutex);
 }
=20
+/**
+ * cleanup_offline_cgwbs - try to release dying cgwbs
+ *
+ * Try to release dying cgwbs by switching attached inodes to the wb
+ * belonging to the root memory cgroup. Processed wbs are placed at the
+ * end of the list to guarantee the forward progress.
+ *
+ * Should be called with the acquired cgwb_lock lock, which might
+ * be released and re-acquired in the process.
+ */
+static void cleanup_offline_cgwbs_workfn(struct work_struct *work)
+{
+	struct bdi_writeback *wb;
+	LIST_HEAD(processed);
+
+	spin_lock_irq(&cgwb_lock);
+
+	while (!list_empty(&offline_cgwbs)) {
+		wb =3D list_first_entry(&offline_cgwbs, struct bdi_writeback,
+				      offline_node);
+		list_move(&wb->offline_node, &processed);
+
+		if (wb_has_dirty_io(wb))
+			continue;
+
+		if (!percpu_ref_tryget(&wb->refcnt))
+			continue;
+
+		spin_unlock_irq(&cgwb_lock);
+		cleanup_offline_wb(wb);
+		spin_lock_irq(&cgwb_lock);
+
+		if (list_empty(&wb->b_attached))
+			list_del_init(&wb->offline_node);
+
+		wb_put(wb);
+	}
+
+	if (!list_empty(&processed))
+		list_splice_tail(&processed, &offline_cgwbs);
+
+	spin_unlock_irq(&cgwb_lock);
+}
+
 /**
  * wb_memcg_offline - kill all wb's associated with a memcg being offlin=
ed
  * @memcg: memcg being offlined
@@ -650,6 +703,10 @@ void wb_memcg_offline(struct mem_cgroup *memcg)
 	list_for_each_entry_safe(wb, next, memcg_cgwb_list, memcg_node)
 		cgwb_kill(wb);
 	memcg_cgwb_list->next =3D NULL;	/* prevent new wb's */
+
+	if (!list_empty(&offline_cgwbs))
+		schedule_work(&cleanup_offline_cgwbs_work);
+
 	spin_unlock_irq(&cgwb_lock);
 }
=20
--=20
2.31.1


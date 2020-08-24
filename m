From: Dan Schatzberg <schatzberg.dan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 2/4] mm: support nesting memalloc_use_memcg()
Date: Mon, 24 Aug 2020 11:36:00 -0400
Message-ID: <20200824153607.6595-3-schatzberg.dan@gmail.com>
References: <20200824153607.6595-1-schatzberg.dan@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=mquvtW23tRDFpTzlE8ED31sKF5mD/fykcSWQYhD45BU=;
        b=VQndbuWT0DpMkgBvLsSdvUtHrXVHJg/0kHEHKUEC1QP49Pr+63PJxHzhd3pNfj3cE2
         w+V+dNXbF3sTSirWF7gaOJ3T+HfJvWyurbegfBgH+mov0Yeeo/+Y8XDUDYXNK4vAg1+P
         vYeWh9Kifo/FMz/LtHY0tuaz6IRCY1GwT0Vhnp2FWB88M49/XXUINpHWJKeANg4iVJfw
         EQbtf2vlcCQMYqWipvj0qJWCizJlBz8NU8YzlRD2ARqb1lhqZoQQFl/tD3VV4gRG9SHX
         tBD20mk3xwRvhLfu5R6xHCDr5zRliPHMga3p6S/zDQkp1VL0/pw9bxQhBkmHQpbE3thu
         4oNQ==
In-Reply-To: <20200824153607.6595-1-schatzberg.dan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: 
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Naresh Kamboju <naresh.kamboju-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, Amir Goldstein <amir73il-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>, Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>, Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Yang Shi <yang.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Mathieu Desnoyers <mathieu.desnoyers@eff>

From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

The memalloc_use_memcg() function to override the default memcg
accounting context currently doesn't nest. But the patches to make the
loop driver cgroup-aware will end up nesting:

[   98.137605]  alloc_page_buffers+0x210/0x288
[   98.141799]  __getblk_gfp+0x1d4/0x400
[   98.145475]  ext4_read_block_bitmap_nowait+0x148/0xbc8
[   98.150628]  ext4_mb_init_cache+0x25c/0x9b0
[   98.154821]  ext4_mb_init_group+0x270/0x390
[   98.159014]  ext4_mb_good_group+0x264/0x270
[   98.163208]  ext4_mb_regular_allocator+0x480/0x798
[   98.168011]  ext4_mb_new_blocks+0x958/0x10f8
[   98.172294]  ext4_ext_map_blocks+0xec8/0x1618
[   98.176660]  ext4_map_blocks+0x1b8/0x8a0
[   98.180592]  ext4_writepages+0x830/0xf10
[   98.184523]  do_writepages+0xb4/0x198
[   98.188195]  __filemap_fdatawrite_range+0x170/0x1c8
[   98.193086]  filemap_write_and_wait_range+0x40/0xb0
[   98.197974]  ext4_punch_hole+0x4a4/0x660
[   98.201907]  ext4_fallocate+0x294/0x1190
[   98.205839]  loop_process_work+0x690/0x1100
[   98.210032]  loop_workfn+0x2c/0x110
[   98.213529]  process_one_work+0x3e0/0x648
[   98.217546]  worker_thread+0x70/0x670
[   98.221217]  kthread+0x1b8/0x1c0
[   98.224452]  ret_from_fork+0x10/0x18

where loop_process_work() sets the memcg override to the memcg that
submitted the IO request, and alloc_page_buffers() sets the override
to the memcg that instantiated the cache page, which may differ.

Make memalloc_use_memcg() return the old memcg and convert existing
users to a stacking model. Delete the unused memalloc_unuse_memcg().

Signed-off-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Reviewed-by: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Acked-by: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Reported-by: Naresh Kamboju <naresh.kamboju-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---
 fs/buffer.c                          |  6 +++---
 fs/notify/fanotify/fanotify.c        |  5 +++--
 fs/notify/inotify/inotify_fsnotify.c |  5 +++--
 include/linux/sched/mm.h             | 28 +++++++++-------------------
 mm/memcontrol.c                      |  6 +++---
 5 files changed, 21 insertions(+), 29 deletions(-)

diff --git a/fs/buffer.c b/fs/buffer.c
index d468ed9981e0..804170cb59fe 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -842,13 +842,13 @@ struct buffer_head *alloc_page_buffers(struct page *page, unsigned long size,
 	struct buffer_head *bh, *head;
 	gfp_t gfp = GFP_NOFS | __GFP_ACCOUNT;
 	long offset;
-	struct mem_cgroup *memcg;
+	struct mem_cgroup *memcg, *old_memcg;
 
 	if (retry)
 		gfp |= __GFP_NOFAIL;
 
 	memcg = get_mem_cgroup_from_page(page);
-	memalloc_use_memcg(memcg);
+	old_memcg = memalloc_use_memcg(memcg);
 
 	head = NULL;
 	offset = PAGE_SIZE;
@@ -867,7 +867,7 @@ struct buffer_head *alloc_page_buffers(struct page *page, unsigned long size,
 		set_bh_page(bh, page, offset);
 	}
 out:
-	memalloc_unuse_memcg();
+	memalloc_use_memcg(old_memcg);
 	mem_cgroup_put(memcg);
 	return head;
 /*
diff --git a/fs/notify/fanotify/fanotify.c b/fs/notify/fanotify/fanotify.c
index c942910a8649..c8fd563e02a3 100644
--- a/fs/notify/fanotify/fanotify.c
+++ b/fs/notify/fanotify/fanotify.c
@@ -533,6 +533,7 @@ static struct fanotify_event *fanotify_alloc_event(struct fsnotify_group *group,
 	unsigned int fid_mode = FAN_GROUP_FLAG(group, FANOTIFY_FID_BITS);
 	struct inode *child = NULL;
 	bool name_event = false;
+	struct mem_cgroup *old_memcg;
 
 	if ((fid_mode & FAN_REPORT_DIR_FID) && dirid) {
 		/*
@@ -580,7 +581,7 @@ static struct fanotify_event *fanotify_alloc_event(struct fsnotify_group *group,
 		gfp |= __GFP_RETRY_MAYFAIL;
 
 	/* Whoever is interested in the event, pays for the allocation. */
-	memalloc_use_memcg(group->memcg);
+	old_memcg = memalloc_use_memcg(group->memcg);
 
 	if (fanotify_is_perm_event(mask)) {
 		event = fanotify_alloc_perm_event(path, gfp);
@@ -608,7 +609,7 @@ static struct fanotify_event *fanotify_alloc_event(struct fsnotify_group *group,
 		event->pid = get_pid(task_tgid(current));
 
 out:
-	memalloc_unuse_memcg();
+	memalloc_use_memcg(old_memcg);
 	return event;
 }
 
diff --git a/fs/notify/inotify/inotify_fsnotify.c b/fs/notify/inotify/inotify_fsnotify.c
index a65cf8c9f600..8017a51561c4 100644
--- a/fs/notify/inotify/inotify_fsnotify.c
+++ b/fs/notify/inotify/inotify_fsnotify.c
@@ -66,6 +66,7 @@ static int inotify_one_event(struct fsnotify_group *group, u32 mask,
 	int ret;
 	int len = 0;
 	int alloc_len = sizeof(struct inotify_event_info);
+	struct mem_cgroup *old_memcg;
 
 	if ((inode_mark->mask & FS_EXCL_UNLINK) &&
 	    path && d_unlinked(path->dentry))
@@ -87,9 +88,9 @@ static int inotify_one_event(struct fsnotify_group *group, u32 mask,
 	 * trigger OOM killer in the target monitoring memcg as it may have
 	 * security repercussion.
 	 */
-	memalloc_use_memcg(group->memcg);
+	old_memcg = memalloc_use_memcg(group->memcg);
 	event = kmalloc(alloc_len, GFP_KERNEL_ACCOUNT | __GFP_RETRY_MAYFAIL);
-	memalloc_unuse_memcg();
+	memalloc_use_memcg(old_memcg);
 
 	if (unlikely(!event)) {
 		/*
diff --git a/include/linux/sched/mm.h b/include/linux/sched/mm.h
index f889e332912f..b8fde48d44a9 100644
--- a/include/linux/sched/mm.h
+++ b/include/linux/sched/mm.h
@@ -312,31 +312,21 @@ static inline void memalloc_nocma_restore(unsigned int flags)
  * __GFP_ACCOUNT allocations till the end of the scope will be charged to the
  * given memcg.
  *
- * NOTE: This function is not nesting safe.
+ * NOTE: This function can nest. Users must save the return value and
+ * reset the previous value after their own charging scope is over
  */
-static inline void memalloc_use_memcg(struct mem_cgroup *memcg)
+static inline struct mem_cgroup *
+memalloc_use_memcg(struct mem_cgroup *memcg)
 {
-	WARN_ON_ONCE(current->active_memcg);
+	struct mem_cgroup *old = current->active_memcg;
 	current->active_memcg = memcg;
-}
-
-/**
- * memalloc_unuse_memcg - Ends the remote memcg charging scope.
- *
- * This function marks the end of the remote memcg charging scope started by
- * memalloc_use_memcg().
- */
-static inline void memalloc_unuse_memcg(void)
-{
-	current->active_memcg = NULL;
+	return old;
 }
 #else
-static inline void memalloc_use_memcg(struct mem_cgroup *memcg)
-{
-}
-
-static inline void memalloc_unuse_memcg(void)
+static inline struct mem_cgroup *
+memalloc_use_memcg(struct mem_cgroup *memcg)
 {
+	return NULL;
 }
 #endif
 
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index b807952b4d43..b2468c80085d 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -5271,12 +5271,12 @@ static struct cgroup_subsys_state * __ref
 mem_cgroup_css_alloc(struct cgroup_subsys_state *parent_css)
 {
 	struct mem_cgroup *parent = mem_cgroup_from_css(parent_css);
-	struct mem_cgroup *memcg;
+	struct mem_cgroup *memcg, *old_memcg;
 	long error = -ENOMEM;
 
-	memalloc_use_memcg(parent);
+	old_memcg = memalloc_use_memcg(parent);
 	memcg = mem_cgroup_alloc();
-	memalloc_unuse_memcg();
+	memalloc_use_memcg(old_memcg);
 	if (IS_ERR(memcg))
 		return ERR_CAST(memcg);
 
-- 
2.24.1


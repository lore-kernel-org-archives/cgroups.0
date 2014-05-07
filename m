From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH cgroup/for-3.16] cgroup: rename css_tryget*() to
 css_tryget_online*()
Date: Wed, 7 May 2014 12:04:29 -0400
Message-ID: <20140507160429.GE26540@htj.dyndns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        bh=JOYtVu2jBe8CvyPSTxZtxD09zBnq079CahT92QfO8Os=;
        b=uTb3nsfAV/dpGCBQVOTXYEZ2+bCmxCXlVzxsHt/lQxayqVhqgnt9cUwpo4oDBfF+S+
         QQqsHDyJXH+oWQsMynE8m/zkbUMhWJSz3LSSEVTbl88+vVuHVdNWjICjqZEV2ih+DHH7
         /gay4tL7XEw3SVNXJEGCKNnrYDMWMON1v4z0xSgsXSkRMdt6t5oSBdgSK6P385GMdHxj
         t26cv5Ean0NEop0Ys9kIdOnpPTZb4fT5dwQOZ6jZyz75jqHAUZJjOQlBEQDjLMPl4S4B
         gsUURJ/i/oRQBuA+mOeGpPNUo6/gof64qGpTnGfTwZWxrXwwoIOIiCMpDPPks9gZsYMI
         JSFQ==
Content-Disposition: inline
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Peter Zijlstra <a.p.zijlstra-/NLkJaSkS4VmR6Xm/wNWPw@public.gmane.org>, Paul Mackerras <paulus-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Arnaldo Carvalho de Melo <acme-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Unlike the more usual refcnting, what css_tryget() provides is the
distinction between online and offline csses instead of protection
against upping a refcnt which already reached zero.  cgroup is
planning to provide actual tryget which fails if the refcnt already
reached zero.  Let's rename the existing trygets so that they clearly
indicate that they're onliness.

I thought about keeping the existing names as-are and introducing new
names for the planned actual tryget; however, given that each
controller participates in the synchronization of the online state, it
seems worthwhile to make it explicit that these functions are about
on/offline state.

Rename css_tryget() to css_tryget_online() and css_tryget_from_dir()
to css_tryget_online_from_dir().  This is pure rename.

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Peter Zijlstra <a.p.zijlstra-/NLkJaSkS4VmR6Xm/wNWPw@public.gmane.org>
Cc: Paul Mackerras <paulus-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Cc: Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Arnaldo Carvalho de Melo <acme-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
---
 block/blk-cgroup.c     |    2 +-
 fs/bio.c               |    2 +-
 include/linux/cgroup.h |   14 +++++++-------
 kernel/cgroup.c        |   40 ++++++++++++++++++++--------------------
 kernel/cpuset.c        |    6 +++---
 kernel/events/core.c   |    3 ++-
 mm/hugetlb_cgroup.c    |    2 +-
 mm/memcontrol.c        |   46 ++++++++++++++++++++++++----------------------
 8 files changed, 59 insertions(+), 56 deletions(-)

--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -185,7 +185,7 @@ static struct blkcg_gq *blkg_create(stru
 	lockdep_assert_held(q->queue_lock);
 
 	/* blkg holds a reference to blkcg */
-	if (!css_tryget(&blkcg->css)) {
+	if (!css_tryget_online(&blkcg->css)) {
 		ret = -EINVAL;
 		goto err_free_blkg;
 	}
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -1970,7 +1970,7 @@ int bio_associate_current(struct bio *bi
 	/* associate blkcg if exists */
 	rcu_read_lock();
 	css = task_css(current, blkio_cgrp_id);
-	if (css && css_tryget(css))
+	if (css && css_tryget_online(css))
 		bio->bi_css = css;
 	rcu_read_unlock();
 
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -95,16 +95,16 @@ static inline void css_get(struct cgroup
 }
 
 /**
- * css_tryget - try to obtain a reference on the specified css
+ * css_tryget_online - try to obtain a reference on the specified css if online
  * @css: target css
  *
- * Obtain a reference on @css if it's alive.  The caller naturally needs to
- * ensure that @css is accessible but doesn't have to be holding a
+ * Obtain a reference on @css if it's online.  The caller naturally needs
+ * to ensure that @css is accessible but doesn't have to be holding a
  * reference on it - IOW, RCU protected access is good enough for this
  * function.  Returns %true if a reference count was successfully obtained;
  * %false otherwise.
  */
-static inline bool css_tryget(struct cgroup_subsys_state *css)
+static inline bool css_tryget_online(struct cgroup_subsys_state *css)
 {
 	if (css->flags & CSS_ROOT)
 		return true;
@@ -115,7 +115,7 @@ static inline bool css_tryget(struct cgr
  * css_put - put a css reference
  * @css: target css
  *
- * Put a reference obtained via css_get() and css_tryget().
+ * Put a reference obtained via css_get() and css_tryget_online().
  */
 static inline void css_put(struct cgroup_subsys_state *css)
 {
@@ -890,8 +890,8 @@ void css_task_iter_end(struct css_task_i
 int cgroup_attach_task_all(struct task_struct *from, struct task_struct *);
 int cgroup_transfer_tasks(struct cgroup *to, struct cgroup *from);
 
-struct cgroup_subsys_state *css_tryget_from_dir(struct dentry *dentry,
-						struct cgroup_subsys *ss);
+struct cgroup_subsys_state *css_tryget_online_from_dir(struct dentry *dentry,
+						       struct cgroup_subsys *ss);
 
 #else /* !CONFIG_CGROUPS */
 
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -3768,7 +3768,7 @@ int cgroupstats_build(struct cgroupstats
 
 	/*
 	 * We aren't being called from kernfs and there's no guarantee on
-	 * @kn->priv's validity.  For this and css_tryget_from_dir(),
+	 * @kn->priv's validity.  For this and css_tryget_online_from_dir(),
 	 * @kn->priv is RCU safe.  Let's do the RCU dancing.
 	 */
 	rcu_read_lock();
@@ -4057,9 +4057,9 @@ err:
  *    Implemented in kill_css().
  *
  * 2. When the percpu_ref is confirmed to be visible as killed on all CPUs
- *    and thus css_tryget() is guaranteed to fail, the css can be offlined
- *    by invoking offline_css().  After offlining, the base ref is put.
- *    Implemented in css_killed_work_fn().
+ *    and thus css_tryget_online() is guaranteed to fail, the css can be
+ *    offlined by invoking offline_css().  After offlining, the base ref is
+ *    put.  Implemented in css_killed_work_fn().
  *
  * 3. When the percpu_ref reaches zero, the only possible remaining
  *    accessors are inside RCU read sections.  css_release() schedules the
@@ -4384,7 +4384,7 @@ static int cgroup_mkdir(struct kernfs_no
 
 /*
  * This is called when the refcnt of a css is confirmed to be killed.
- * css_tryget() is now guaranteed to fail.
+ * css_tryget_online() is now guaranteed to fail.
  */
 static void css_killed_work_fn(struct work_struct *work)
 {
@@ -4396,8 +4396,8 @@ static void css_killed_work_fn(struct wo
 	mutex_lock(&cgroup_mutex);
 
 	/*
-	 * css_tryget() is guaranteed to fail now.  Tell subsystems to
-	 * initate destruction.
+	 * css_tryget_online() is guaranteed to fail now.  Tell subsystems
+	 * to initate destruction.
 	 */
 	offline_css(css);
 
@@ -4438,8 +4438,8 @@ static void css_killed_ref_fn(struct per
  *
  * This function initiates destruction of @css by removing cgroup interface
  * files and putting its base reference.  ->css_offline() will be invoked
- * asynchronously once css_tryget() is guaranteed to fail and when the
- * reference count reaches zero, @css will be released.
+ * asynchronously once css_tryget_online() is guaranteed to fail and when
+ * the reference count reaches zero, @css will be released.
  */
 static void kill_css(struct cgroup_subsys_state *css)
 {
@@ -4460,7 +4460,7 @@ static void kill_css(struct cgroup_subsy
 	/*
 	 * cgroup core guarantees that, by the time ->css_offline() is
 	 * invoked, no new css reference will be given out via
-	 * css_tryget().  We can't simply call percpu_ref_kill() and
+	 * css_tryget_online().  We can't simply call percpu_ref_kill() and
 	 * proceed to offlining css's because percpu_ref_kill() doesn't
 	 * guarantee that the ref is seen as killed on all CPUs on return.
 	 *
@@ -4476,9 +4476,9 @@ static void kill_css(struct cgroup_subsy
  *
  * css's make use of percpu refcnts whose killing latency shouldn't be
  * exposed to userland and are RCU protected.  Also, cgroup core needs to
- * guarantee that css_tryget() won't succeed by the time ->css_offline() is
- * invoked.  To satisfy all the requirements, destruction is implemented in
- * the following two steps.
+ * guarantee that css_tryget_online() won't succeed by the time
+ * ->css_offline() is invoked.  To satisfy all the requirements,
+ * destruction is implemented in the following two steps.
  *
  * s1. Verify @cgrp can be destroyed and mark it dying.  Remove all
  *     userland visible parts and start killing the percpu refcnts of
@@ -4572,9 +4572,9 @@ static int cgroup_destroy_locked(struct
 	/*
 	 * There are two control paths which try to determine cgroup from
 	 * dentry without going through kernfs - cgroupstats_build() and
-	 * css_tryget_from_dir().  Those are supported by RCU protecting
-	 * clearing of cgrp->kn->priv backpointer, which should happen
-	 * after all files under it have been removed.
+	 * css_tryget_online_from_dir().  Those are supported by RCU
+	 * protecting clearing of cgrp->kn->priv backpointer, which should
+	 * happen after all files under it have been removed.
 	 */
 	kernfs_remove(cgrp->kn);	/* @cgrp has an extra ref on its kn */
 	RCU_INIT_POINTER(*(void __rcu __force **)&cgrp->kn->priv, NULL);
@@ -5171,7 +5171,7 @@ static int __init cgroup_disable(char *s
 __setup("cgroup_disable=", cgroup_disable);
 
 /**
- * css_tryget_from_dir - get corresponding css from the dentry of a cgroup dir
+ * css_tryget_online_from_dir - get corresponding css from a cgroup dentry
  * @dentry: directory dentry of interest
  * @ss: subsystem of interest
  *
@@ -5179,8 +5179,8 @@ __setup("cgroup_disable=", cgroup_disabl
  * to get the corresponding css and return it.  If such css doesn't exist
  * or can't be pinned, an ERR_PTR value is returned.
  */
-struct cgroup_subsys_state *css_tryget_from_dir(struct dentry *dentry,
-						struct cgroup_subsys *ss)
+struct cgroup_subsys_state *css_tryget_online_from_dir(struct dentry *dentry,
+						       struct cgroup_subsys *ss)
 {
 	struct kernfs_node *kn = kernfs_node_from_dentry(dentry);
 	struct cgroup_subsys_state *css = NULL;
@@ -5202,7 +5202,7 @@ struct cgroup_subsys_state *css_tryget_f
 	if (cgrp)
 		css = cgroup_css(cgrp, ss);
 
-	if (!css || !css_tryget(css))
+	if (!css || !css_tryget_online(css))
 		css = ERR_PTR(-ENOENT);
 
 	rcu_read_unlock();
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -875,7 +875,7 @@ static void update_tasks_cpumask_hier(st
 				continue;
 			}
 		}
-		if (!css_tryget(&cp->css))
+		if (!css_tryget_online(&cp->css))
 			continue;
 		rcu_read_unlock();
 
@@ -1110,7 +1110,7 @@ static void update_tasks_nodemask_hier(s
 				continue;
 			}
 		}
-		if (!css_tryget(&cp->css))
+		if (!css_tryget_online(&cp->css))
 			continue;
 		rcu_read_unlock();
 
@@ -2155,7 +2155,7 @@ static void cpuset_hotplug_workfn(struct
 
 		rcu_read_lock();
 		cpuset_for_each_descendant_pre(cs, pos_css, &top_cpuset) {
-			if (cs == &top_cpuset || !css_tryget(&cs->css))
+			if (cs == &top_cpuset || !css_tryget_online(&cs->css))
 				continue;
 			rcu_read_unlock();
 
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -607,7 +607,8 @@ static inline int perf_cgroup_connect(in
 	if (!f.file)
 		return -EBADF;
 
-	css = css_tryget_from_dir(f.file->f_dentry, &perf_event_cgrp_subsys);
+	css = css_tryget_online_from_dir(f.file->f_dentry,
+					 &perf_event_cgrp_subsys);
 	if (IS_ERR(css)) {
 		ret = PTR_ERR(css);
 		goto out;
--- a/mm/hugetlb_cgroup.c
+++ b/mm/hugetlb_cgroup.c
@@ -181,7 +181,7 @@ int hugetlb_cgroup_charge_cgroup(int idx
 again:
 	rcu_read_lock();
 	h_cg = hugetlb_cgroup_from_task(current);
-	if (!css_tryget(&h_cg->css)) {
+	if (!css_tryget_online(&h_cg->css)) {
 		rcu_read_unlock();
 		goto again;
 	}
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -567,7 +567,8 @@ void sock_update_memcg(struct sock *sk)
 		memcg = mem_cgroup_from_task(current);
 		cg_proto = sk->sk_prot->proto_cgroup(memcg);
 		if (!mem_cgroup_is_root(memcg) &&
-		    memcg_proto_active(cg_proto) && css_tryget(&memcg->css)) {
+		    memcg_proto_active(cg_proto) &&
+		    css_tryget_online(&memcg->css)) {
 			sk->sk_cgrp = cg_proto;
 		}
 		rcu_read_unlock();
@@ -834,7 +835,7 @@ retry:
 	 */
 	__mem_cgroup_remove_exceeded(mz->memcg, mz, mctz);
 	if (!res_counter_soft_limit_excess(&mz->memcg->res) ||
-		!css_tryget(&mz->memcg->css))
+	    !css_tryget_online(&mz->memcg->css))
 		goto retry;
 done:
 	return mz;
@@ -1076,7 +1077,7 @@ static struct mem_cgroup *get_mem_cgroup
 		memcg = mem_cgroup_from_task(rcu_dereference(mm->owner));
 		if (unlikely(!memcg))
 			memcg = root_mem_cgroup;
-	} while (!css_tryget(&memcg->css));
+	} while (!css_tryget_online(&memcg->css));
 	rcu_read_unlock();
 	return memcg;
 }
@@ -1113,7 +1114,8 @@ skip_node:
 	 */
 	if (next_css) {
 		if ((next_css == &root->css) ||
-		    ((next_css->flags & CSS_ONLINE) && css_tryget(next_css)))
+		    ((next_css->flags & CSS_ONLINE) &&
+		     css_tryget_online(next_css)))
 			return mem_cgroup_from_css(next_css);
 
 		prev_css = next_css;
@@ -1159,7 +1161,7 @@ mem_cgroup_iter_load(struct mem_cgroup_r
 		 * would be returned all the time.
 		 */
 		if (position && position != root &&
-				!css_tryget(&position->css))
+		    !css_tryget_online(&position->css))
 			position = NULL;
 	}
 	return position;
@@ -2785,9 +2787,9 @@ static void __mem_cgroup_cancel_local_ch
 
 /*
  * A helper function to get mem_cgroup from ID. must be called under
- * rcu_read_lock().  The caller is responsible for calling css_tryget if
- * the mem_cgroup is used for charging. (dropping refcnt from swap can be
- * called against removed memcg.)
+ * rcu_read_lock().  The caller is responsible for calling
+ * css_tryget_online() if the mem_cgroup is used for charging. (dropping
+ * refcnt from swap can be called against removed memcg.)
  */
 static struct mem_cgroup *mem_cgroup_lookup(unsigned short id)
 {
@@ -2810,14 +2812,14 @@ struct mem_cgroup *try_get_mem_cgroup_fr
 	lock_page_cgroup(pc);
 	if (PageCgroupUsed(pc)) {
 		memcg = pc->mem_cgroup;
-		if (memcg && !css_tryget(&memcg->css))
+		if (memcg && !css_tryget_online(&memcg->css))
 			memcg = NULL;
 	} else if (PageSwapCache(page)) {
 		ent.val = page_private(page);
 		id = lookup_swap_cgroup_id(ent);
 		rcu_read_lock();
 		memcg = mem_cgroup_lookup(id);
-		if (memcg && !css_tryget(&memcg->css))
+		if (memcg && !css_tryget_online(&memcg->css))
 			memcg = NULL;
 		rcu_read_unlock();
 	}
@@ -3473,7 +3475,7 @@ struct kmem_cache *__memcg_kmem_get_cach
 	}
 
 	/* The corresponding put will be done in the workqueue. */
-	if (!css_tryget(&memcg->css))
+	if (!css_tryget_online(&memcg->css))
 		goto out;
 	rcu_read_unlock();
 
@@ -4246,8 +4248,8 @@ void mem_cgroup_uncharge_swap(swp_entry_
 	memcg = mem_cgroup_lookup(id);
 	if (memcg) {
 		/*
-		 * We uncharge this because swap is freed.
-		 * This memcg can be obsolete one. We avoid calling css_tryget
+		 * We uncharge this because swap is freed.  This memcg can
+		 * be obsolete one. We avoid calling css_tryget_online().
 		 */
 		if (!mem_cgroup_is_root(memcg))
 			res_counter_uncharge(&memcg->memsw, PAGE_SIZE);
@@ -5840,10 +5842,10 @@ static void kmem_cgroup_css_offline(stru
 	 * which is then paired with css_put during uncharge resp. here.
 	 *
 	 * Although this might sound strange as this path is called from
-	 * css_offline() when the referencemight have dropped down to 0
-	 * and shouldn't be incremented anymore (css_tryget would fail)
-	 * we do not have other options because of the kmem allocations
-	 * lifetime.
+	 * css_offline() when the referencemight have dropped down to 0 and
+	 * shouldn't be incremented anymore (css_tryget_online() would
+	 * fail) we do not have other options because of the kmem
+	 * allocations lifetime.
 	 */
 	css_get(&memcg->css);
 
@@ -6051,8 +6053,8 @@ static int memcg_write_event_control(str
 	 * automatically removed on cgroup destruction but the removal is
 	 * asynchronous, so take an extra ref on @css.
 	 */
-	cfile_css = css_tryget_from_dir(cfile.file->f_dentry->d_parent,
-					&memory_cgrp_subsys);
+	cfile_css = css_tryget_online_from_dir(cfile.file->f_dentry->d_parent,
+					       &memory_cgrp_subsys);
 	ret = -EINVAL;
 	if (IS_ERR(cfile_css))
 		goto out_put_cfile;
@@ -6496,7 +6498,7 @@ static void mem_cgroup_css_free(struct c
 	/*
 	 * XXX: css_offline() would be where we should reparent all
 	 * memory to prepare the cgroup for destruction.  However,
-	 * memcg does not do css_tryget() and res_counter charging
+	 * memcg does not do css_tryget_online() and res_counter charging
 	 * under the same RCU lock region, which means that charging
 	 * could race with offlining.  Offlining only happens to
 	 * cgroups with no tasks in them but charges can show up
@@ -6510,9 +6512,9 @@ static void mem_cgroup_css_free(struct c
 	 *                           lookup_swap_cgroup_id()
 	 *                           rcu_read_lock()
 	 *                           mem_cgroup_lookup()
-	 *                           css_tryget()
+	 *                           css_tryget_online()
 	 *                           rcu_read_unlock()
-	 * disable css_tryget()
+	 * disable css_tryget_online()
 	 * call_rcu()
 	 *   offline_css()
 	 *     reparent_charges()

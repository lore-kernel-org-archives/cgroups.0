From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 2/2] cgroup/cpuset: Make percpu cpuset_rwsem operation depending on DYNMODS state
Date: Thu,  8 Dec 2022 14:56:34 -0500
Message-ID: <20221208195634.2604362-3-longman@redhat.com>
References: <20221208195634.2604362-1-longman@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670529423;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=s03T6k1fAEZ5y4Sx1FORStjPoY8HDaI7yoRA/+1yXuc=;
        b=OgbjEUyNUAl5rBdOMCLahf1u4OA4qC+P+Ep/Nuj51yXy3oASa7RkAlJKLCTTnYGudEwRlS
        +O3cxkqUS2+rC4Pnl2ENhAGQBfwt1W3ZSNbWhw8fGUFdSD6oJ6BvpukNVT/T0yo+fuoa0L
        guiXBNQdvSNdK7hHeGiJ1BWKszfvJ2s=
In-Reply-To: <20221208195634.2604362-1-longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

With commit 6a010a49b63a ("cgroup: Make !percpu threadgroup_rwsem
operations optional"), users can determine if they favor optimizing
for efficiently moving processes between cgroups frequently or for
a more static usage pattern where moving processes among cgroups are
relatively rare.

The percpu cpuset_rwsem is in the same boat as percpu_threadgroup_rwsem
since moving processes among cpusets will have the same latency impact
depending on whether percpu operation in cpuset_rwsem is disabled or not.

Ideally cpuset_bind() is the best place to check if the
cpuset_rwsem should have its reader fast path disabled like
percpu_threadgroup_rwsem so that it gets to be re-evaluated every
time the cpuset is rebound. Unfortunately, cgroup_favor_dynmods()
that sets the CGRP_ROOT_FAVOR_DYNMODS flag is called after the bind()
method call. Instead, the newly added cpuset_check_dynmods() function
is called at the first cpuset_css_online() call after a cpuset_bind()
call when the first child cpuset is created.

Signed-off-by: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 kernel/cgroup/cpuset.c | 36 ++++++++++++++++++++++++++++++++++++
 1 file changed, 36 insertions(+)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 800c65de5daa..daf8ca948176 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -255,6 +255,7 @@ typedef enum {
 	CS_SCHED_LOAD_BALANCE,
 	CS_SPREAD_PAGE,
 	CS_SPREAD_SLAB,
+	CS_FAVOR_DYNMODS,	/* top_cpuset only */
 } cpuset_flagbits_t;
 
 /* convenient tests for these bits */
@@ -3049,6 +3050,27 @@ static struct cftype dfl_files[] = {
 	{ }	/* terminate */
 };
 
+static bool dynmods_checked __read_mostly;
+static void cpuset_check_dynmods(struct cgroup_root *root)
+{
+	bool favor_dynmods;
+
+	lockdep_assert_held(&cgroup_mutex);
+	percpu_rwsem_assert_held(&cpuset_rwsem);
+
+	/*
+	 * Check the CGRP_ROOT_FAVOR_DYNMODS of the cgroup root to find out
+	 * if we need to enable or disable reader fast path of cpuset_rwsem.
+	 */
+	favor_dynmods = test_bit(CS_FAVOR_DYNMODS, &top_cpuset.flags);
+	if (favor_dynmods && !(root->flags & CGRP_ROOT_FAVOR_DYNMODS)) {
+		rcu_sync_exit(&cpuset_rwsem.rss);
+		clear_bit(CS_FAVOR_DYNMODS, &top_cpuset.flags);
+	} else if (!favor_dynmods && (root->flags & CGRP_ROOT_FAVOR_DYNMODS)) {
+		rcu_sync_enter(&cpuset_rwsem.rss);
+		set_bit(CS_FAVOR_DYNMODS, &top_cpuset.flags);
+	}
+}
 
 /*
  *	cpuset_css_alloc - allocate a cpuset css
@@ -3099,6 +3121,14 @@ static int cpuset_css_online(struct cgroup_subsys_state *css)
 	cpus_read_lock();
 	percpu_down_write(&cpuset_rwsem);
 
+	/*
+	 * Check dynmod state on the first css_online() call.
+	 */
+	if (unlikely(!dynmods_checked)) {
+		cpuset_check_dynmods(cpuset_cgrp_subsys.root);
+		dynmods_checked = true;
+	}
+
 	set_bit(CS_ONLINE, &cs->flags);
 	if (is_spread_page(parent))
 		set_bit(CS_SPREAD_PAGE, &cs->flags);
@@ -3201,6 +3231,12 @@ static void cpuset_css_free(struct cgroup_subsys_state *css)
 
 static void cpuset_bind(struct cgroup_subsys_state *root_css)
 {
+	/*
+	 * Reset dynmods_checked to be evaluated again in the next
+	 * cpuset_css_online()
+	 */
+	dynmods_checked = false;
+
 	percpu_down_write(&cpuset_rwsem);
 	spin_lock_irq(&callback_lock);
 
-- 
2.31.1


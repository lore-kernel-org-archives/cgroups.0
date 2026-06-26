Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD5883B895D
	for <cgroups@vger.kernel.org>; Fri, 26 Jun 2026 18:37:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782499072; cv=none; b=IvBIge9CUyMVW8Lkp8xxzzmowpsH9bP3W3KLodoxSA2rdDLY/4vatfXDr7ov3VEHbPfZqmCX4cMO4tipR0JEp7EcbInBAaDfGgW86v7gXCKOOqvJbUGU75ShSbMPF5RHtvlJ7LDB1oT3+nZVm5I1Q2JZzarG6Ra5YNHquZoj738=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782499072; c=relaxed/simple;
	bh=mrr1o5F3wXwi/T5Z6P5NVaqu1xyr4rDLY69gOZzxVvo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Asf22yazI6uvYJvrOOMRG7y+EsQuldD8gmo6K+QRZNSel8ArZr1rK0cfa56dDPBPjIawFYhsG8AQ0KvplTNmeH7Evv+kteTi9pTjlPWYx5BLDmLfyPy6yhRmwSNwwJE7V/FTmQtHv3pN+KjUd7yR2mfkLopzNymKj91UDKD+erw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=BGrKWcD6; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BGrKWcD6"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1782499070;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bkyJrFt9SyBnbStYYqduVV1wWzfFUhWCztXzYT2qQmg=;
	b=BGrKWcD6m/KVQ6aoo7JH262nzWmZCf44/1UGPIIEk0UsIKXWOI9ZwXBR0FkcKm4mPrXI4O
	I3YWidORC1t4pj+3nzNYZ3lwX/yfrY+hHj5jABEy96XwEh90tXX6N70reDiGhe01ek0m1m
	H7ZDnka5T6y/y3/C+4uO7CESDa9hGmA=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-653-A1xrQulhOrq-1Yh2Wm5dBg-1; Fri,
 26 Jun 2026 14:37:46 -0400
X-MC-Unique: A1xrQulhOrq-1Yh2Wm5dBg-1
X-Mimecast-MFC-AGG-ID: A1xrQulhOrq-1Yh2Wm5dBg_1782499064
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7CCB21956048;
	Fri, 26 Jun 2026 18:37:44 +0000 (UTC)
Received: from llong-thinkpadp16vgen1.westford.csb (unknown [10.2.16.156])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 9DC4C19560A3;
	Fri, 26 Jun 2026 18:37:40 +0000 (UTC)
From: Waiman Long <longman@redhat.com>
To: Ridong Chen <ridong.chen@linux.dev>,
	Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Farhad Alemi <farhad.alemi@berkeley.edu>,
	Andrew Morton <akpm@linux-foundation.org>,
	Shuah Khan <shuah@kernel.org>
Cc: cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	Aaron Tomlin <atomlin@atomlin.com>,
	Guopeng Zhang <guopeng.zhang@linux.dev>,
	Gregory Price <gourry@gourry.net>,
	David Hildenbrand <david@kernel.org>,
	Waiman Long <longman@redhat.com>
Subject: [PATCH v8 04/11] cgroup/cpuset: Put all task attach related variables into attach_ctx
Date: Fri, 26 Jun 2026 14:19:16 -0400
Message-ID: <20260626181923.133658-5-longman@redhat.com>
In-Reply-To: <20260626181923.133658-1-longman@redhat.com>
References: <20260626181923.133658-1-longman@redhat.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

Put the task attach related cpuset_attach_old_cs and
cpuset_attach_nodemask_to static variables into the new attach_ctx
structure to improve readability and ease maintanence.

No functional change is expected.

Suggested-by: Ridong Chen <ridong.chen@linux.dev>
Signed-off-by: Waiman Long <longman@redhat.com>
---
 kernel/cgroup/cpuset.c | 21 ++++++++++-----------
 1 file changed, 10 insertions(+), 11 deletions(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index dec9785d0271..1f31f340e0ec 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -362,6 +362,8 @@ static DECLARE_WAIT_QUEUE_HEAD(cpuset_attach_wq);
  */
 static struct {
 	int in_progress;
+	struct cpuset *old_cs;	/* Source cpuset */
+	nodemask_t nodemask_to;
 } attach_ctx;
 
 static inline void check_insane_mems_config(nodemask_t *nodes)
@@ -2996,8 +2998,6 @@ static int update_prstate(struct cpuset *cs, int new_prs)
 	return 0;
 }
 
-static struct cpuset *cpuset_attach_old_cs;
-
 /*
  * Check to see if a cpuset can accept a new task
  * For v1, cpus_allowed and mems_allowed can't be empty.
@@ -3029,8 +3029,8 @@ static int cpuset_can_attach(struct cgroup_taskset *tset)
 	int cpu, ret;
 
 	/* used later by cpuset_attach() */
-	cpuset_attach_old_cs = task_cs(cgroup_taskset_first(tset, &css));
-	oldcs = cpuset_attach_old_cs;
+	attach_ctx.old_cs = task_cs(cgroup_taskset_first(tset, &css));
+	oldcs = attach_ctx.old_cs;
 	cs = css_cs(css);
 
 	mutex_lock(&cpuset_mutex);
@@ -3133,7 +3133,6 @@ static void cpuset_cancel_attach(struct cgroup_taskset *tset)
  * allocate from cpuset_init().
  */
 static cpumask_var_t cpus_attach;
-static nodemask_t cpuset_attach_nodemask_to;
 
 static void cpuset_attach_task(struct cpuset *cs, struct task_struct *task)
 {
@@ -3150,7 +3149,7 @@ static void cpuset_attach_task(struct cpuset *cs, struct task_struct *task)
 	 */
 	WARN_ON_ONCE(set_cpus_allowed_ptr(task, cpus_attach));
 
-	cpuset_change_task_nodemask(task, &cpuset_attach_nodemask_to);
+	cpuset_change_task_nodemask(task, &attach_ctx.nodemask_to);
 	cpuset1_update_task_spread_flags(cs, task);
 }
 
@@ -3160,7 +3159,7 @@ static void cpuset_attach(struct cgroup_taskset *tset)
 	struct task_struct *leader;
 	struct cgroup_subsys_state *css;
 	struct cpuset *cs;
-	struct cpuset *oldcs = cpuset_attach_old_cs;
+	struct cpuset *oldcs = attach_ctx.old_cs;
 	bool cpus_updated, mems_updated;
 	bool queue_task_work = false;
 
@@ -3172,7 +3171,7 @@ static void cpuset_attach(struct cgroup_taskset *tset)
 	cpus_updated = !cpumask_equal(cs->effective_cpus,
 				      oldcs->effective_cpus);
 	mems_updated = !nodes_equal(cs->effective_mems, oldcs->effective_mems);
-	guarantee_online_mems(cs, &cpuset_attach_nodemask_to);
+	guarantee_online_mems(cs, &attach_ctx.nodemask_to);
 
 	/*
 	 * In the default hierarchy, enabling cpuset in the child cgroups
@@ -3211,7 +3210,7 @@ static void cpuset_attach(struct cgroup_taskset *tset)
 			 */
 			if (is_memory_migrate(cs)) {
 				cpuset_migrate_mm(mm, &oldcs->old_mems_allowed,
-						  &cpuset_attach_nodemask_to);
+						  &attach_ctx.nodemask_to);
 				queue_task_work = true;
 			} else
 				mmput(mm);
@@ -3221,7 +3220,7 @@ static void cpuset_attach(struct cgroup_taskset *tset)
 out:
 	if (queue_task_work)
 		schedule_flush_migrate_mm();
-	cs->old_mems_allowed = cpuset_attach_nodemask_to;
+	cs->old_mems_allowed = attach_ctx.nodemask_to;
 
 	if (cs->nr_migrate_dl_tasks) {
 		cs->nr_deadline_tasks += cs->nr_migrate_dl_tasks;
@@ -3685,7 +3684,7 @@ static void cpuset_fork(struct task_struct *task)
 
 	/* CLONE_INTO_CGROUP */
 	mutex_lock(&cpuset_mutex);
-	guarantee_online_mems(cs, &cpuset_attach_nodemask_to);
+	guarantee_online_mems(cs, &attach_ctx.nodemask_to);
 	cpuset_attach_task(cs, task);
 
 	dec_attach_in_progress_locked();
-- 
2.54.0


Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 919EB3002CF
	for <cgroups@vger.kernel.org>; Sun, 21 Jun 2026 03:29:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782012553; cv=none; b=YRKeGciT43szXccWKPADcnfLWWUr9uM2W7MAmYpRhCQLggnH1QXswv8H+fgok/iKJ50sYYrUy2dr2Z+uROjcF/CGd2BJJ0ktGb08ewtPM3LsPDS7mA+xnOdrWkqtMTlXz13ubNHJJ0GxBB/fmCsjRcWtkvhSEiozcvPpHcCH/2o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782012553; c=relaxed/simple;
	bh=UjMB5xamugPwSXL999iygxzReabQxrJ5uHfPwE+sTnk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HWRX9MhybaPV8Qiy/bfUoHuiKsYeYm5HAIUz1ZCa9J2nAVe82ZacZk7hjW3UTYumigZfmfgusS1mmFCaS/18+CBV1devx9oCxntBY+3SByvlGfJMcj2wqWpIFrsy/2Ek2tb/6HXEQjmVWhftmWUbp+vOXHGpkn7AHmepx6H5da4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Gh6FQ0pe; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Gh6FQ0pe"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1782012550;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=keP1v9kW8YLqMhkuAhQSrpPxxUhBMoeWGPXTt4OXFrs=;
	b=Gh6FQ0pec26T8xyNK5Pt310H/b3srbPBXMwvUj+MluHfwaiWlAPmhsJcgG/xrvwZPV68EW
	5OPYaUUTKKxgHZLE2bkm/JwRDrw31x0inrCqes9rn4zVjwPmRtasKypSFCmKhxClTU4dy7
	Pw4lyyB5IUTLQ/pw0i/w4P6gYYhVu90=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-442-2DDqFxJRO4WYYWdahBwxsg-1; Sat,
 20 Jun 2026 23:29:04 -0400
X-MC-Unique: 2DDqFxJRO4WYYWdahBwxsg-1
X-Mimecast-MFC-AGG-ID: 2DDqFxJRO4WYYWdahBwxsg_1782012542
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id EDAF3180059E;
	Sun, 21 Jun 2026 03:29:01 +0000 (UTC)
Received: from llong-thinkpadp16vgen1.westford.csb (unknown [10.22.88.8])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 62C091955F76;
	Sun, 21 Jun 2026 03:28:59 +0000 (UTC)
From: Waiman Long <longman@redhat.com>
To: Ridong Chen <ridong.chen@linux.dev>,
	Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Li Zefan <lizefan@huawei.com>,
	Farhad Alemi <farhad.alemi@berkeley.edu>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Aaron Tomlin <atomlin@atomlin.com>,
	Guopeng Zhang <guopeng.zhang@linux.dev>,
	Gregory Price <gourry@gourry.net>,
	David Hildenbrand <david@kernel.org>,
	Waiman Long <longman@redhat.com>
Subject: [PATCH v7 2/9] cgroup/cpuset: Fix node inconsistencies between cpuset_update_tasks_nodemask() and cpuset_attach()
Date: Sat, 20 Jun 2026 23:28:09 -0400
Message-ID: <20260621032816.1806773-3-longman@redhat.com>
In-Reply-To: <20260621032816.1806773-1-longman@redhat.com>
References: <20260621032816.1806773-1-longman@redhat.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

Whenever memory node mask is changed, there are 4 places where the node
mask has to be updated or used.
 1) task's node mask via cpuset_change_task_nodemask()
 2) memory policy binding via mpol_rebind_mm()
 3) if memory migration is enabled, migrate from old_mems_allowed to
    the new node mask via cpuset_migrate_mm().
 4) setting old_mems_allowed

These memory actions are done in cpuset_update_tasks_nodemask() and
cpuset_attach(). However there are inconsistencies in what node masks
are being used in these 2 functions.

In cpuset_update_tasks_nodemask(),
 - cpuset_change_task_nodemask(): guarantee_online_mems()
 - mpol_rebind_mm(): mems_allowed
 - cpuset_migrate_mm(): guarantee_online_mems()
 - old_mems_allowed: guarantee_online_mems()

In cpuset_attach(),
 - cpuset_change_task_nodemask(): guarantee_online_mems()
 - mpol_rebind_mm(): effective_mems
 - cpuset_migrate_mm(): effective_mems
 - old_mems_allowed: effective_mems

These inconsistencies dates back to quite a long time ago and it is
hard to say what should be the correct values.

The guarantee_online_mems() function returns a node mask from current or
an ancestor cpuset that is a subset of node_states[N_MEMORY]. Nodes in
node_states[N_MEMORY] are all online, i.e. in node_states[N_ONLINE].
However, node in node_states[N_ONLINE] may not have memory. So
node_states[N_MEMORY] should be a subset of node_states[N_ONLINE].

The guarantee_online_mems() function should mostly be useful for v1
where mems_allowed is the same as effective_mems. With v2, the memory
nodes in effective_mems should be a subset of node_states[N_MEMORY]
except when a memory hot-unplug operation is in progress and a memory
node is removed from node_states[N_MEMORY] but not yet reflected in
the effective_mems's as cpuset_handle_hotplug() has not been called
from cpuset_track_online_nodes().

Let use the following setup for both of them and make them consistent.
 - cpuset_change_task_nodemask(): guarantee_online_mems()
 - mpol_rebind_mm(): effective_mems
 - cpuset_migrate_mm(): guarantee_online_mems()
 - old_mems_allowed: guarantee_online_mems()

So for v2, it is effectively all effective_mems most of the time. For
v1, mpol_rebind_mm() uses mems_allowed which may differ from what
guarantee_online_mems() returns, but it conforms to what the cpuset v1
documentation says with respect to setting memory policy.

Reviewed-by: Ridong Chen <ridong.chen@linux.dev>
Signed-off-by: Waiman Long <longman@redhat.com>
---
 kernel/cgroup/cpuset.c | 30 ++++++++++++++++++------------
 1 file changed, 18 insertions(+), 12 deletions(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index b21c31650583..a1c8890d3519 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -489,7 +489,10 @@ static void guarantee_active_cpus(struct task_struct *tsk,
  * Return in *pmask the portion of a cpusets's mems_allowed that
  * are online, with memory.  If none are online with memory, walk
  * up the cpuset hierarchy until we find one that does have some
- * online mems.  The top cpuset always has some mems online.
+ * online mems.  The top cpuset always has some mems online. With v2,
+ * effective_mems should always contain online memory nodes except
+ * during the transition period where a memory node hotunplug operation
+ * is in progress.
  *
  * One way or another, we guarantee to return some non-empty subset
  * of node_states[N_MEMORY].
@@ -2619,6 +2622,14 @@ static void *cpuset_being_rebound;
  * Iterate through each task of @cs updating its mems_allowed to the
  * effective cpuset's.  As this function is called with cpuset_mutex held,
  * cpuset membership stays stable.
+ *
+ * - cpuset_change_task_nodemask(): guarantee_online_mems()
+ * - mpol_rebind_mm(): effective_mems
+ * - cpuset_migrate_mm(): guarantee_online_mems()
+ * - old_mems_allowed: guarantee_online_mems()
+ *
+ * For v2, guarantee_online_mems() should return a node mask that is the same
+ * as the effective_mems of current cpuset.
  */
 void cpuset_update_tasks_nodemask(struct cpuset *cs)
 {
@@ -2627,7 +2638,6 @@ void cpuset_update_tasks_nodemask(struct cpuset *cs)
 	struct task_struct *task;
 
 	cpuset_being_rebound = cs;		/* causes mpol_dup() rebind */
-
 	guarantee_online_mems(cs, &newmems);
 
 	/*
@@ -3148,19 +3158,16 @@ static void cpuset_attach(struct cgroup_taskset *tset)
 	cpus_updated = !cpumask_equal(cs->effective_cpus,
 				      oldcs->effective_cpus);
 	mems_updated = !nodes_equal(cs->effective_mems, oldcs->effective_mems);
+	guarantee_online_mems(cs, &cpuset_attach_nodemask_to);
 
 	/*
 	 * In the default hierarchy, enabling cpuset in the child cgroups
-	 * will trigger a number of cpuset_attach() calls with no change
-	 * in effective cpus and mems. In that case, we can optimize out
-	 * by skipping the task iteration and update.
+	 * will trigger a cpuset_attach() call with no change in effective cpus
+	 * and mems. In that case, we can optimize out by skipping the task
+	 * iteration and update.
 	 */
-	if (cpuset_v2() && !cpus_updated && !mems_updated) {
-		cpuset_attach_nodemask_to = cs->effective_mems;
+	if (cpuset_v2() && !cpus_updated && !mems_updated)
 		goto out;
-	}
-
-	guarantee_online_mems(cs, &cpuset_attach_nodemask_to);
 
 	cgroup_taskset_for_each(task, css, tset)
 		cpuset_attach_task(cs, task);
@@ -3171,7 +3178,6 @@ static void cpuset_attach(struct cgroup_taskset *tset)
 	 * if there is no change in effective_mems and CS_MEMORY_MIGRATE is
 	 * not set.
 	 */
-	cpuset_attach_nodemask_to = cs->effective_mems;
 	if (!is_memory_migrate(cs) && !mems_updated)
 		goto out;
 
@@ -3179,7 +3185,7 @@ static void cpuset_attach(struct cgroup_taskset *tset)
 		struct mm_struct *mm = get_task_mm(leader);
 
 		if (mm) {
-			mpol_rebind_mm(mm, &cpuset_attach_nodemask_to);
+			mpol_rebind_mm(mm, &cs->effective_mems);
 
 			/*
 			 * old_mems_allowed is the same with mems_allowed
-- 
2.54.0


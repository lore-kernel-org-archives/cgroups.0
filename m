From: Kenny Ho <Kenny.Ho-5C7GfCeVMHo@public.gmane.org>
Subject: [PATCH RFC 4/4] bpf, cgroup,
 perf: extend bpf-cgroup to support tracepoint attachment
Date: Thu, 18 Nov 2021 15:28:40 -0500
Message-ID: <20211118202840.1001787-5-Kenny.Ho@amd.com>
References: <20211118202840.1001787-1-Kenny.Ho@amd.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <amd-gfx-bounces-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1; 
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NHKhQbOAr7Mm7h+PoDJFTwWLZ8WOF7rmrZsjJYFpFsc=;
 b=rPxETzrKb9U4nxyEatf1AHRYpnXTHjHKNcBdovdowIUL96wxaNdUcVPvVBxqtYyfIMFGFt/Y5Qrdw4gAnBatwntYFsU+0r1MIHZTbjbx/T8TSQ+VjM+MMQP752e8h9igtt4pILIy1+hBrAGnWzYvF/O32jV5UOrTxyXckpXd1Ws=
In-Reply-To: <20211118202840.1001787-1-Kenny.Ho-5C7GfCeVMHo@public.gmane.org>
List-Id: <cgroups.vger.kernel.org>
List-Unsubscribe: <https://lists.freedesktop.org/mailman/options/amd-gfx>,
 <mailto:amd-gfx-request-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org?subject=unsubscribe>
List-Archive: <https://lists.freedesktop.org/archives/amd-gfx>
List-Post: <mailto:amd-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>
List-Help: <mailto:amd-gfx-request-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org?subject=help>
List-Subscribe: <https://lists.freedesktop.org/mailman/listinfo/amd-gfx>,
 <mailto:amd-gfx-request-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org?subject=subscribe>
Errors-To: amd-gfx-bounces-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org
Sender: "amd-gfx" <amd-gfx-bounces-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>
Content-Type: text/plain; charset="us-ascii"
To: Alexei Starovoitov <ast-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Daniel Borkmann <daniel-FeC+5ew28dpmcu3hnIyYJQ@public.gmane.org>, Andrii Nakryiko <andrii-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Martin KaFai Lau <kafai-b10kYP2dOMg@public.gmane.org>, Song Liu <songliubraving-b10kYP2dOMg@public.gmane.org>, Yonghong Song <yhs-b10kYP2dOMg@public.gmane.org>, John Fastabend <john.fastabend-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, KP Singh <kpsingh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes
 Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Ingo
 Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Arnaldo Carvalho de Melo <acme-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Mark
 Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Alexander Shishkin <alexander.shishkin-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Jiri Olsa <jolsa-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Namhyung
 Kim <namhyung-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, bpf-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-perf-users-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, y2kenny-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Kenny.Ho@amd

bpf progs are attached to cgroups as usual with the idea of effective
progs remain the same.  The perf event / tracepoint's fd is defined as
attachment 'subtype'.  The 'subtype' is passed along during attachment
via bpf_attr, reusing replace_bpf_fd field.

After the effective progs are calculated, perf_event is allocated using
the 'subtype'/'fd' value for all cpus filtering on the perf cgroup that
corresponds to the bpf-cgroup (with assumption of a unified hierarchy.)
The effective bpf prog array is then attached to each newly allocated
perf_event and subsequently enabled by activate_effective_progs.

Change-Id: I07a4dcaa0a682bafa496f05411365100d6c84fff
Signed-off-by: Kenny Ho <Kenny.Ho-5C7GfCeVMHo@public.gmane.org>
---
 include/linux/bpf-cgroup.h | 15 ++++--
 include/linux/perf_event.h |  4 ++
 kernel/bpf/cgroup.c        | 96 +++++++++++++++++++++++++++++++-------
 kernel/cgroup/cgroup.c     |  9 ++--
 kernel/events/core.c       | 45 ++++++++++++++++++
 5 files changed, 142 insertions(+), 27 deletions(-)

diff --git a/include/linux/bpf-cgroup.h b/include/linux/bpf-cgroup.h
index a5e4d9b19470..b6e22fd2aa6e 100644
--- a/include/linux/bpf-cgroup.h
+++ b/include/linux/bpf-cgroup.h
@@ -154,6 +154,11 @@ struct cgroup_bpf {
 
 	/* cgroup_bpf is released using a work queue */
 	struct work_struct release_work;
+
+        /* list of perf events (per child cgroups) for tracepoint/kprobe/uprobe bpf attachment to cgroup */
+        /* TODO: array of tp type with array of events for each cgroup
+         * currently only one tp type supported at a time */
+        struct list_head per_cg_events;
 };
 
 int cgroup_bpf_inherit(struct cgroup *cgrp);
@@ -161,21 +166,21 @@ void cgroup_bpf_offline(struct cgroup *cgrp);
 
 int __cgroup_bpf_attach(struct cgroup *cgrp,
 			struct bpf_prog *prog, struct bpf_prog *replace_prog,
-			struct bpf_cgroup_link *link,
+			struct bpf_cgroup_link *link, int bpf_attach_subtype,
 			enum bpf_attach_type type, u32 flags);
 int __cgroup_bpf_detach(struct cgroup *cgrp, struct bpf_prog *prog,
 			struct bpf_cgroup_link *link,
-			enum bpf_attach_type type);
+			enum bpf_attach_type type, int bpf_attach_subtype);
 int __cgroup_bpf_query(struct cgroup *cgrp, const union bpf_attr *attr,
 		       union bpf_attr __user *uattr);
 
 /* Wrapper for __cgroup_bpf_*() protected by cgroup_mutex */
 int cgroup_bpf_attach(struct cgroup *cgrp,
 		      struct bpf_prog *prog, struct bpf_prog *replace_prog,
-		      struct bpf_cgroup_link *link, enum bpf_attach_type type,
-		      u32 flags);
+		      struct bpf_cgroup_link *link, int bpf_attach_subtype,
+		      enum bpf_attach_type type, u32 flags);
 int cgroup_bpf_detach(struct cgroup *cgrp, struct bpf_prog *prog,
-		      enum bpf_attach_type type);
+		      enum bpf_attach_type type, int bpf_attach_subtype);
 int cgroup_bpf_query(struct cgroup *cgrp, const union bpf_attr *attr,
 		     union bpf_attr __user *uattr);
 
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 9c440db65c18..5a149d8865a1 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -776,6 +776,7 @@ struct perf_event {
 
 #ifdef CONFIG_CGROUP_PERF
 	struct perf_cgroup		*cgrp; /* cgroup event is attach to */
+	struct list_head		bpf_cg_list;
 #endif
 
 #ifdef CONFIG_SECURITY
@@ -982,6 +983,9 @@ extern void perf_pmu_resched(struct pmu *pmu);
 extern int perf_event_refresh(struct perf_event *event, int refresh);
 extern void perf_event_update_userpage(struct perf_event *event);
 extern int perf_event_release_kernel(struct perf_event *event);
+extern int perf_event_create_for_all_cpus(struct perf_event_attr *attr,
+				struct cgroup *cgroup,
+				struct list_head *entries);
 extern struct perf_event *
 perf_event_create_kernel_counter(struct perf_event_attr *attr,
 				int cpu,
diff --git a/kernel/bpf/cgroup.c b/kernel/bpf/cgroup.c
index 03145d45e3d5..0ecf465ddfb2 100644
--- a/kernel/bpf/cgroup.c
+++ b/kernel/bpf/cgroup.c
@@ -14,6 +14,8 @@
 #include <linux/string.h>
 #include <linux/bpf.h>
 #include <linux/bpf-cgroup.h>
+#include <linux/perf_event.h>
+#include <linux/trace_events.h>
 #include <net/sock.h>
 #include <net/bpf_sk_storage.h>
 
@@ -112,6 +114,8 @@ static void cgroup_bpf_release(struct work_struct *work)
 	struct bpf_prog_array *old_array;
 	struct list_head *storages = &cgrp->bpf.storages;
 	struct bpf_cgroup_storage *storage, *stmp;
+	struct list_head *events = &cgrp->bpf.per_cg_events;
+	struct perf_event *event, *etmp;
 
 	unsigned int atype;
 
@@ -141,6 +145,10 @@ static void cgroup_bpf_release(struct work_struct *work)
 		bpf_cgroup_storage_free(storage);
 	}
 
+	list_for_each_entry_safe(event, etmp, events, bpf_cg_list) {
+		perf_event_release_kernel(event);
+	}
+
 	mutex_unlock(&cgroup_mutex);
 
 	for (p = cgroup_parent(cgrp); p; p = cgroup_parent(p))
@@ -226,13 +234,16 @@ static bool hierarchy_allows_attach(struct cgroup *cgrp,
  */
 static int compute_effective_progs(struct cgroup *cgrp,
 				   enum cgroup_bpf_attach_type atype,
+				   int bpf_attach_subtype,
 				   struct bpf_prog_array **array)
 {
 	struct bpf_prog_array_item *item;
 	struct bpf_prog_array *progs;
 	struct bpf_prog_list *pl;
 	struct cgroup *p = cgrp;
-	int cnt = 0;
+	struct perf_event *event, *etmp;
+	struct perf_event_attr attr = {};
+	int rc, cnt = 0;
 
 	/* count number of effective programs by walking parents */
 	do {
@@ -245,6 +256,21 @@ static int compute_effective_progs(struct cgroup *cgrp,
 	if (!progs)
 		return -ENOMEM;
 
+	if (atype == CGROUP_TRACEPOINT) {
+		/* TODO: only create event for cgroup that can have process */
+
+		attr.config = bpf_attach_subtype;
+		attr.type = PERF_TYPE_TRACEPOINT;
+		attr.sample_type = PERF_SAMPLE_RAW;
+		attr.sample_period = 1;
+		attr.wakeup_events = 1;
+
+		rc = perf_event_create_for_all_cpus(&attr, cgrp,
+				&cgrp->bpf.per_cg_events);
+		if (rc)
+			goto err;
+	}
+
 	/* populate the array with effective progs */
 	cnt = 0;
 	p = cgrp;
@@ -264,20 +290,41 @@ static int compute_effective_progs(struct cgroup *cgrp,
 		}
 	} while ((p = cgroup_parent(p)));
 
+	if (atype == CGROUP_TRACEPOINT) {
+		list_for_each_entry_safe(event, etmp, &cgrp->bpf.per_cg_events, bpf_cg_list) {
+			rc = perf_event_attach_bpf_prog_array(event, progs);
+			if (rc)
+				goto err_attach;
+		}
+	}
+
 	*array = progs;
 	return 0;
+err_attach:
+	list_for_each_entry_safe(event, etmp, &cgrp->bpf.per_cg_events, bpf_cg_list)
+		perf_event_release_kernel(event);
+err:
+	bpf_prog_array_free(progs);
+	return rc;
 }
 
 static void activate_effective_progs(struct cgroup *cgrp,
 				     enum cgroup_bpf_attach_type atype,
 				     struct bpf_prog_array *old_array)
 {
-	old_array = rcu_replace_pointer(cgrp->bpf.effective[atype], old_array,
-					lockdep_is_held(&cgroup_mutex));
-	/* free prog array after grace period, since __cgroup_bpf_run_*()
-	 * might be still walking the array
-	 */
-	bpf_prog_array_free(old_array);
+	struct perf_event *event, *etmp;
+
+	if (atype == CGROUP_TRACEPOINT)
+		list_for_each_entry_safe(event, etmp, &cgrp->bpf.per_cg_events, bpf_cg_list)
+			perf_event_enable(event);
+	else {
+		old_array = rcu_replace_pointer(cgrp->bpf.effective[atype], old_array,
+						lockdep_is_held(&cgroup_mutex));
+		/* free prog array after grace period, since __cgroup_bpf_run_*()
+		 * might be still walking the array
+		 */
+		bpf_prog_array_free(old_array);
+	}
 }
 
 /**
@@ -306,9 +353,10 @@ int cgroup_bpf_inherit(struct cgroup *cgrp)
 		INIT_LIST_HEAD(&cgrp->bpf.progs[i]);
 
 	INIT_LIST_HEAD(&cgrp->bpf.storages);
+	INIT_LIST_HEAD(&cgrp->bpf.per_cg_events);
 
 	for (i = 0; i < NR; i++)
-		if (compute_effective_progs(cgrp, i, &arrays[i]))
+		if (compute_effective_progs(cgrp, i, -1, &arrays[i]))
 			goto cleanup;
 
 	for (i = 0; i < NR; i++)
@@ -328,7 +376,8 @@ int cgroup_bpf_inherit(struct cgroup *cgrp)
 }
 
 static int update_effective_progs(struct cgroup *cgrp,
-				  enum cgroup_bpf_attach_type atype)
+				  enum cgroup_bpf_attach_type atype,
+                                  int bpf_attach_subtype)
 {
 	struct cgroup_subsys_state *css;
 	int err;
@@ -340,7 +389,8 @@ static int update_effective_progs(struct cgroup *cgrp,
 		if (percpu_ref_is_zero(&desc->bpf.refcnt))
 			continue;
 
-		err = compute_effective_progs(desc, atype, &desc->bpf.inactive);
+		err = compute_effective_progs(desc, atype, bpf_attach_subtype,
+				&desc->bpf.inactive);
 		if (err)
 			goto cleanup;
 	}
@@ -424,6 +474,7 @@ static struct bpf_prog_list *find_attach_entry(struct list_head *progs,
  * @prog: A program to attach
  * @link: A link to attach
  * @replace_prog: Previously attached program to replace if BPF_F_REPLACE is set
+ * @bpf_attach_subtype: Type ID of perf tracing event for tracepoint/kprobe/uprobe
  * @type: Type of attach operation
  * @flags: Option flags
  *
@@ -432,7 +483,7 @@ static struct bpf_prog_list *find_attach_entry(struct list_head *progs,
  */
 int __cgroup_bpf_attach(struct cgroup *cgrp,
 			struct bpf_prog *prog, struct bpf_prog *replace_prog,
-			struct bpf_cgroup_link *link,
+			struct bpf_cgroup_link *link, int bpf_attach_subtype,
 			enum bpf_attach_type type, u32 flags)
 {
 	u32 saved_flags = (flags & (BPF_F_ALLOW_OVERRIDE | BPF_F_ALLOW_MULTI));
@@ -454,6 +505,14 @@ int __cgroup_bpf_attach(struct cgroup *cgrp,
 	if (!!replace_prog != !!(flags & BPF_F_REPLACE))
 		/* replace_prog implies BPF_F_REPLACE, and vice versa */
 		return -EINVAL;
+        if ((type == BPF_CGROUP_TRACEPOINT) &&
+	    ((flags & BPF_F_REPLACE) || (bpf_attach_subtype < 0) || !(flags & BPF_F_ALLOW_MULTI)))
+		/* replace fd is used to pass the subtype */
+		/* subtype is required for BPF_CGROUP_TRACEPOINT */
+		/* not allow multi BPF progs for the attach type for now */
+                return -EINVAL;
+
+	/* TODO check bpf_attach_subtype is valid */
 
 	atype = to_cgroup_bpf_attach_type(type);
 	if (atype < 0)
@@ -499,7 +558,7 @@ int __cgroup_bpf_attach(struct cgroup *cgrp,
 	bpf_cgroup_storages_assign(pl->storage, storage);
 	cgrp->bpf.flags[atype] = saved_flags;
 
-	err = update_effective_progs(cgrp, atype);
+	err = update_effective_progs(cgrp, atype, bpf_attach_subtype);
 	if (err)
 		goto cleanup;
 
@@ -679,7 +738,8 @@ static struct bpf_prog_list *find_detach_entry(struct list_head *progs,
  * Must be called with cgroup_mutex held.
  */
 int __cgroup_bpf_detach(struct cgroup *cgrp, struct bpf_prog *prog,
-			struct bpf_cgroup_link *link, enum bpf_attach_type type)
+			struct bpf_cgroup_link *link, enum bpf_attach_type type,
+			int bpf_attach_subtype)
 {
 	enum cgroup_bpf_attach_type atype;
 	struct bpf_prog *old_prog;
@@ -708,7 +768,7 @@ int __cgroup_bpf_detach(struct cgroup *cgrp, struct bpf_prog *prog,
 	pl->prog = NULL;
 	pl->link = NULL;
 
-	err = update_effective_progs(cgrp, atype);
+	err = update_effective_progs(cgrp, atype, bpf_attach_subtype);
 	if (err)
 		goto cleanup;
 
@@ -809,7 +869,7 @@ int cgroup_bpf_prog_attach(const union bpf_attr *attr,
 		}
 	}
 
-	ret = cgroup_bpf_attach(cgrp, prog, replace_prog, NULL,
+	ret = cgroup_bpf_attach(cgrp, prog, replace_prog, NULL, attr->replace_bpf_fd,
 				attr->attach_type, attr->attach_flags);
 
 	if (replace_prog)
@@ -832,7 +892,7 @@ int cgroup_bpf_prog_detach(const union bpf_attr *attr, enum bpf_prog_type ptype)
 	if (IS_ERR(prog))
 		prog = NULL;
 
-	ret = cgroup_bpf_detach(cgrp, prog, attr->attach_type);
+	ret = cgroup_bpf_detach(cgrp, prog, attr->attach_type, attr->replace_bpf_fd);
 	if (prog)
 		bpf_prog_put(prog);
 
@@ -861,7 +921,7 @@ static void bpf_cgroup_link_release(struct bpf_link *link)
 	}
 
 	WARN_ON(__cgroup_bpf_detach(cg_link->cgroup, NULL, cg_link,
-				    cg_link->type));
+				    cg_link->type, -1));
 
 	cg = cg_link->cgroup;
 	cg_link->cgroup = NULL;
@@ -961,7 +1021,7 @@ int cgroup_bpf_link_attach(const union bpf_attr *attr, struct bpf_prog *prog)
 		goto out_put_cgroup;
 	}
 
-	err = cgroup_bpf_attach(cgrp, NULL, NULL, link,
+	err = cgroup_bpf_attach(cgrp, NULL, NULL, link, -1,
 				link->type, BPF_F_ALLOW_MULTI);
 	if (err) {
 		bpf_link_cleanup(&link_primer);
diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index a645b212b69b..17a1269dc2f9 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -6626,25 +6626,26 @@ void cgroup_sk_free(struct sock_cgroup_data *skcd)
 #ifdef CONFIG_CGROUP_BPF
 int cgroup_bpf_attach(struct cgroup *cgrp,
 		      struct bpf_prog *prog, struct bpf_prog *replace_prog,
-		      struct bpf_cgroup_link *link,
+		      struct bpf_cgroup_link *link, int bpf_attach_subtype,
 		      enum bpf_attach_type type,
 		      u32 flags)
 {
 	int ret;
 
 	mutex_lock(&cgroup_mutex);
-	ret = __cgroup_bpf_attach(cgrp, prog, replace_prog, link, type, flags);
+	ret = __cgroup_bpf_attach(cgrp, prog, replace_prog, link,
+                bpf_attach_subtype, type, flags);
 	mutex_unlock(&cgroup_mutex);
 	return ret;
 }
 
 int cgroup_bpf_detach(struct cgroup *cgrp, struct bpf_prog *prog,
-		      enum bpf_attach_type type)
+		      enum bpf_attach_type type, int bpf_attach_subtype)
 {
 	int ret;
 
 	mutex_lock(&cgroup_mutex);
-	ret = __cgroup_bpf_detach(cgrp, prog, NULL, type);
+	ret = __cgroup_bpf_detach(cgrp, prog, NULL, type, bpf_attach_subtype);
 	mutex_unlock(&cgroup_mutex);
 	return ret;
 }
diff --git a/kernel/events/core.c b/kernel/events/core.c
index d34e00749c9b..71056af4322b 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -12511,6 +12511,51 @@ perf_event_create_kernel_counter(struct perf_event_attr *attr, int cpu,
 }
 EXPORT_SYMBOL_GPL(perf_event_create_kernel_counter);
 
+int perf_event_create_for_all_cpus(struct perf_event_attr *attr,
+				struct cgroup *cgroup,
+				struct list_head *entries)
+{
+	struct perf_event **events;
+        struct perf_cgroup *perf_cgrp;
+	int cpu, i = 0;
+
+	events = kzalloc(sizeof(struct perf_event *) * num_possible_cpus(),
+			GFP_KERNEL);
+
+	if (!events)
+		return -ENOMEM;
+
+	for_each_possible_cpu(cpu) {
+		/* allocate first, connect the cgroup later */
+		events[i] = perf_event_create_kernel_counter(attr, cpu, NULL, NULL, NULL);
+
+		if (IS_ERR(events[i]))
+			goto err;
+
+		i++;
+	}
+
+	perf_cgrp = cgroup_tryget_perf_cgroup(cgroup);
+	if (!perf_cgrp)
+		goto err;
+
+	for (i--; i >= 0; i--) {
+                events[i]->cgrp = perf_cgrp;
+
+                list_add(&events[i]->bpf_cg_list, entries);
+	}
+
+	kfree(events);
+	return 0;
+
+err:
+	for (i--; i >= 0; i--)
+		free_event(events[i]);
+
+	kfree(events);
+	return -ENOMEM;
+}
+
 void perf_pmu_migrate_context(struct pmu *pmu, int src_cpu, int dst_cpu)
 {
 	struct perf_event_context *src_ctx;
-- 
2.25.1


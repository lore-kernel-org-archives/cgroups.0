From: Yosry Ahmed <yosryahmed@google.com>
Subject: [RFC PATCH bpf-next 2/9] cgroup: bpf: flush bpf stats on rstat flush
Date: Tue, 10 May 2022 00:18:00 +0000
Message-ID: <20220510001807.4132027-3-yosryahmed@google.com>
References: <20220510001807.4132027-1-yosryahmed@google.com>
Mime-Version: 1.0
Return-path: <bpf-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=YvkcjuDpXc8HWz9CnYpHQqOHXSlPjrKDHoLv5HHHOqc=;
        b=MJHi55tk0JN9+q5cGwIIOQ+Jj2WwPhMAlGDibUDUwpt7+quof2cyyE79xyhhUwI89Y
         u/5KnrZvb0DUC2kgcpQz7sODufIBs2ts//Wawz6Ms1xJ1I4sqYsyv16Q7y5aAC3h0NKS
         vmiwyBlLIXY6+YfJOCjAA1DFGpm80zmopqy2PFz49B/BD5RQY2S5e6XGp+YRwClg7JUO
         1lKzRYsM7rIFumsFTXllZkAKmnVhEbZ+gbnXS2aTvqKceWxC5Mna88o6Mii+lvWEFOpB
         sqzm24QVieegXsKuhqQUEfwzqr9S6F5QMBxUaMwPU9Wg9eFun1+wFgagTcDmhII9EQsO
         FC2A==
In-Reply-To: <20220510001807.4132027-1-yosryahmed@google.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, Andrii Nakryiko <andrii@kernel.org>, Martin KaFai Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>, John Fastabend <john.fastabend@gmail.com>, KP Singh <kpsingh@kernel.org>, Hao Luo <haoluo@google.com>, Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Shuah Khan <shuah@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, Michal Hocko <mhocko@kernel.org>
Cc: Stanislav Fomichev <sdf@google.com>, David Rientjes <rientjes@google.com>, Greg Thelen <gthelen@google.com>, Shakeel Butt <shakeelb@google.com>, linux-kernel@vger.kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org, cgroups@vger.kernel.org, Yosry Ahmed <yosryahmed@google.com>

When a cgroup is popped from the rstat updated tree, subsystems rstat
flushers are run through the css_rstat_flush() callback. Also run bpf
flushers for all subsystems that have at least one bpf rstat flusher
attached, and are enabled for this cgroup.

A list of subsystems that have attached rstat flushers is maintained to
avoid looping through all subsystems for all cpus for every cgroup that
is being popped from the updated tree. Since we introduce a lock here to
protect this list, also use it to protect rstat_flushers lists inside
each subsystem (since they both need to locked together anyway), and get
read of the locks in struct cgroup_subsys_bpf.

rstat flushers are run for any enabled subsystem that has flushers
attached, even if it does not subscribe to css flushing through
css_rstat_flush(). This gives flexibility for bpf programs to collect
stats for any subsystem, regardless of the implementation changes in the
kernel.

Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
---
 include/linux/bpf-cgroup-subsys.h |  7 +++-
 include/linux/cgroup.h            |  2 ++
 kernel/bpf/cgroup_subsys.c        | 60 +++++++++++++++++++++++++++----
 kernel/cgroup/cgroup.c            |  5 +--
 kernel/cgroup/rstat.c             | 11 ++++++
 5 files changed, 75 insertions(+), 10 deletions(-)

diff --git a/include/linux/bpf-cgroup-subsys.h b/include/linux/bpf-cgroup-subsys.h
index 4dcde06b5599..e977b9ef5754 100644
--- a/include/linux/bpf-cgroup-subsys.h
+++ b/include/linux/bpf-cgroup-subsys.h
@@ -10,7 +10,11 @@
 struct cgroup_subsys_bpf {
 	/* Head of the list of BPF rstat flushers attached to this subsystem */
 	struct list_head rstat_flushers;
-	spinlock_t flushers_lock;
+	/*
+	 * A list that runs through subsystems that have at least one rstat
+	 * flusher.
+	 */
+	struct list_head rstat_subsys_node;
 };
 
 struct bpf_subsys_rstat_flusher {
@@ -26,5 +30,6 @@ struct bpf_cgroup_subsys_link {
 
 int cgroup_subsys_bpf_link_attach(const union bpf_attr *attr,
 				  struct bpf_prog *prog);
+void bpf_run_rstat_flushers(struct cgroup *cgrp, int cpu);
 
 #endif  // _BPF_CGROUP_SUBSYS_H_
diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index 0d1ada8968d7..5408c74d5c44 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -97,6 +97,8 @@ extern struct css_set init_css_set;
 
 bool css_has_online_children(struct cgroup_subsys_state *css);
 struct cgroup_subsys_state *css_from_id(int id, struct cgroup_subsys *ss);
+struct cgroup_subsys_state *cgroup_css(struct cgroup *cgrp,
+				       struct cgroup_subsys *ss);
 struct cgroup_subsys_state *cgroup_e_css(struct cgroup *cgroup,
 					 struct cgroup_subsys *ss);
 struct cgroup_subsys_state *cgroup_get_e_css(struct cgroup *cgroup,
diff --git a/kernel/bpf/cgroup_subsys.c b/kernel/bpf/cgroup_subsys.c
index 9673ce6aa84a..1d10319a34e9 100644
--- a/kernel/bpf/cgroup_subsys.c
+++ b/kernel/bpf/cgroup_subsys.c
@@ -6,10 +6,46 @@
  */
 
 #include <linux/bpf-cgroup-subsys.h>
+#include <linux/cgroup.h>
 #include <linux/filter.h>
 
 #include "../cgroup/cgroup-internal.h"
 
+/* List of subsystems that have rstat flushers attached */
+static LIST_HEAD(bpf_rstat_subsys_list);
+/* Protects the above list, and the lists of rstat flushers in each subsys */
+static DEFINE_SPINLOCK(bpf_rstat_subsys_lock);
+
+
+void bpf_run_rstat_flushers(struct cgroup *cgrp, int cpu)
+{
+	struct cgroup_subsys_bpf *ss_bpf;
+	struct cgroup *parent = cgroup_parent(cgrp);
+	struct bpf_rstat_ctx ctx = {
+		.cgroup_id = cgroup_id(cgrp),
+		.parent_cgroup_id = parent ? cgroup_id(parent) : 0,
+		.cpu = cpu,
+	};
+
+	rcu_read_lock();
+	migrate_disable();
+	spin_lock(&bpf_rstat_subsys_lock);
+	list_for_each_entry(ss_bpf, &bpf_rstat_subsys_list, rstat_subsys_node) {
+		struct bpf_subsys_rstat_flusher *rstat_flusher;
+		struct cgroup_subsys *ss = container_of(ss_bpf,
+							struct cgroup_subsys,
+							bpf);
+
+		/* Subsystem ss is not enabled for cgrp */
+		if (!cgroup_css(cgrp, ss))
+			continue;
+		list_for_each_entry(rstat_flusher, &ss_bpf->rstat_flushers, list)
+			(void) bpf_prog_run(rstat_flusher->prog, &ctx);
+	}
+	spin_unlock(&bpf_rstat_subsys_lock);
+	migrate_enable();
+	rcu_read_unlock();
+}
 
 static int cgroup_subsys_bpf_attach(struct cgroup_subsys *ss, struct bpf_prog *prog)
 {
@@ -20,28 +56,38 @@ static int cgroup_subsys_bpf_attach(struct cgroup_subsys *ss, struct bpf_prog *p
 		return -ENOMEM;
 	rstat_flusher->prog = prog;
 
-	spin_lock(&ss->bpf.flushers_lock);
+	spin_lock(&bpf_rstat_subsys_lock);
+	/* Add ss to bpf_rstat_subsys_list when we attach the first flusher */
+	if (list_empty(&ss->bpf.rstat_flushers))
+		list_add(&ss->bpf.rstat_subsys_node, &bpf_rstat_subsys_list);
 	list_add(&rstat_flusher->list, &ss->bpf.rstat_flushers);
-	spin_unlock(&ss->bpf.flushers_lock);
+	spin_unlock(&bpf_rstat_subsys_lock);
 
 	return 0;
 }
 
 static void cgroup_subsys_bpf_detach(struct cgroup_subsys *ss, struct bpf_prog *prog)
 {
-	struct bpf_subsys_rstat_flusher *rstat_flusher = NULL;
+	struct bpf_subsys_rstat_flusher *iter, *rstat_flusher = NULL;
 
-	spin_lock(&ss->bpf.flushers_lock);
-	list_for_each_entry(rstat_flusher, &ss->bpf.rstat_flushers, list)
-		if (rstat_flusher->prog == prog)
+	spin_lock(&bpf_rstat_subsys_lock);
+	list_for_each_entry(iter, &ss->bpf.rstat_flushers, list)
+		if (iter->prog == prog) {
+			rstat_flusher = iter;
 			break;
+		}
 
 	if (rstat_flusher) {
 		list_del(&rstat_flusher->list);
 		bpf_prog_put(rstat_flusher->prog);
 		kfree(rstat_flusher);
 	}
-	spin_unlock(&ss->bpf.flushers_lock);
+	/*
+	 * Remove ss from bpf_rstat_subsys_list when we detach the last flusher
+	 */
+	if (list_empty(&ss->bpf.rstat_flushers))
+		list_del(&ss->bpf.rstat_subsys_node);
+	spin_unlock(&bpf_rstat_subsys_lock);
 }
 
 static void bpf_cgroup_subsys_link_release(struct bpf_link *link)
diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index 7b1448013009..af703cfcb9d2 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -478,8 +478,8 @@ static u16 cgroup_ss_mask(struct cgroup *cgrp)
  * keep accessing it outside the said locks.  This function may return
  * %NULL if @cgrp doesn't have @subsys_id enabled.
  */
-static struct cgroup_subsys_state *cgroup_css(struct cgroup *cgrp,
-					      struct cgroup_subsys *ss)
+struct cgroup_subsys_state *cgroup_css(struct cgroup *cgrp,
+				       struct cgroup_subsys *ss)
 {
 	if (CGROUP_HAS_SUBSYS_CONFIG && ss)
 		return rcu_dereference_check(cgrp->subsys[ss->id],
@@ -5746,6 +5746,7 @@ static void __init cgroup_init_subsys(struct cgroup_subsys *ss, bool early)
 	idr_init(&ss->css_idr);
 	INIT_LIST_HEAD(&ss->cfts);
 	INIT_LIST_HEAD(&ss->bpf.rstat_flushers);
+	INIT_LIST_HEAD(&ss->bpf.rstat_subsys_node);
 
 	/* Create the root cgroup state for this subsystem */
 	ss->root = &cgrp_dfl_root;
diff --git a/kernel/cgroup/rstat.c b/kernel/cgroup/rstat.c
index 24b5c2ab5598..af553a0ccc0d 100644
--- a/kernel/cgroup/rstat.c
+++ b/kernel/cgroup/rstat.c
@@ -2,6 +2,7 @@
 #include "cgroup-internal.h"
 
 #include <linux/sched/cputime.h>
+#include <linux/bpf-cgroup-subsys.h>
 
 static DEFINE_SPINLOCK(cgroup_rstat_lock);
 static DEFINE_PER_CPU(raw_spinlock_t, cgroup_rstat_cpu_lock);
@@ -173,6 +174,16 @@ static void cgroup_rstat_flush_locked(struct cgroup *cgrp, bool may_sleep)
 			list_for_each_entry_rcu(css, &pos->rstat_css_list,
 						rstat_css_node)
 				css->ss->css_rstat_flush(css, cpu);
+			/*
+			 * We run bpf flushers in a separate loop in
+			 * bpf_run_rstat_flushers()  as the above
+			 * loop only goes through subsystems that have rstat
+			 * flushing registered in the kernel.
+			 *
+			 * This gives flexibility for BPF programs to utilize
+			 * rstat to collect stats for any subsystem.
+			 */
+			bpf_run_rstat_flushers(pos, cpu);
 			rcu_read_unlock();
 		}
 		raw_spin_unlock_irqrestore(cpu_lock, flags);
-- 
2.36.0.512.ge40c2bad7a-goog

